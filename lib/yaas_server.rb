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

require "xmlrpc/server"
require File.join(File.dirname(__FILE__), 'config_file.rb')
require File.join(File.dirname(__FILE__), 'yaas_agent.rb')

class YaasServer

    def initialize(config_path)
        config = ConfigFile.new(config_path)
        config.read_file()

        @listen_address     = config.get_key('listen_address')
        @port               = config.get_key('port')
        @host_handler       = config.get_key('host_handler')
        @devkey_script_path = config.get_key('devkey_script_path')
        @lease_script_path  = config.get_key('lease_script_path')        
    end

    def run
        handler             = YaasAgent.new(@devkey_script_path, @lease_script_path)
        server              = XMLRPC::Server.new(@port, @listen_address)

        server.add_handler(@host_handler, handler)
        server.serve
    end

end

