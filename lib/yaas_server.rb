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

require 'etc'
require 'yaml'
require "xmlrpc/server"
require File.join(File.dirname(__FILE__), "yaas_agent.rb")

class YaasServer

    def initialize(config_path)
        config = YAML.load_file(config_path)

        @listen_address     = config["listen_address"]
        @port               = config["port"]
        @host_handler       = config["host_handler"]
        @devkey_script_path = config["devkey_script_path"]
        @lease_script_path  = config["lease_script_path"]
        @system_username    = config["system_username"]
    end

    def switch_user()
        user = Etc::getpwnam(@system_username)

        Process::Sys::setegid(user.gid)
        Process::Sys::setgid(user.gid)
        Process::Sys::setuid(user.gid)

        if Process::Sys::getuid == 0
            raise "User #{@system_user} does not exists."
        end
    end

    def run
        handler             = YaasAgent.new(@devkey_script_path, @lease_script_path)
        server              = XMLRPC::Server.new(@port, @listen_address)

        server.add_handler(@host_handler, handler)
        server.serve
    end

end
