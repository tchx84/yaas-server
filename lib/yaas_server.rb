# Copyright Paraguay Educa 2010, Martin Abente
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>
#

# Yet Another Activation System - Server

require "etc"
require "yaml"
require "openssl"
require "webrick"
require "webrick/https"
require "xmlrpc/server"
require File.join(File.dirname(__FILE__), "yaas_agent.rb")

class YaasServer

    def initialize(config_path)
        config                = YAML.load_file(config_path)

        @bind_address         = config["bind_address"]
        @port                 = config["port"]
        @host_handler         = config["host_handler"]
        @devkey_script_path   = config["devkey_script_path"]
        @lease_script_path    = config["lease_script_path"]
        @system_username      = config["system_username"]
        @enable_ip_validation = config["enable_ip_validation"]
        @allowed_ip_addresses = config["allowed_ip_addresses"]
        @private_key_path     = config["private_key_path"]
        @certificate_path     = config["certificate_path"]
        @secret_keyword       = config["secret_keyword"]
    end

    def run
        switch_user()

        private_key_content = File.open(@private_key_path).read
        private_key         = OpenSSL::PKey::RSA.new(private_key_content)

        certificate_content = File.open(@certificate_path).read
        certificate         = OpenSSL::X509::Certificate.new(certificate_content)

        handler             = YaasAgent.new(@devkey_script_path, @lease_script_path, @secret_keyword)
        servlet             = XMLRPC::WEBrickServlet.new
        server              = WEBrick::HTTPServer.new(

          :Port             => @port,
          :BindAddress      => @bind_address,
          :SSLEnable        => true,
          :SSLVerifyClient  => OpenSSL::SSL::VERIFY_NONE,
          :SSLCertificate   => certificate,
          :SSLPrivateKey    => private_key
        )

        setup_security(servlet)
        servlet.add_handler(@host_handler, handler)
        server.mount("/RPC2", servlet)

        trap("INT"){ server.shutdown }
        server.start
    end

    private

    def switch_user()
        user = Etc::getpwnam(@system_username)

        Process::Sys::setegid(user.gid)
        Process::Sys::setgid(user.gid)
        Process::Sys::setuid(user.gid)

        if Process::Sys::getuid == 0
            raise "You can NOT run this service as root"
        end
    end

    def setup_security(server)

        if @enable_ip_validation

            if !@allowed_ip_addresses.is_a?(Array)
                raise "Allowed IP addresses must be an array"
            end

            if @allowed_ip_addresses.length == 0
                @allowed_ip_addresses.push("127.0.0.1")
            end

            #Hack for bug related to ruby's xmlrpc/server.rb (supports regexp only)
            regexp_ip_addresses = @allowed_ip_addresses.map { |address| Regexp.new(address) }
            server.set_valid_ip(*regexp_ip_addresses)
        end
    end

end
