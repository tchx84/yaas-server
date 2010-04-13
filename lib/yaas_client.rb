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

# Yet Another Activation System - Client

require "xmlrpc/client"

class YaasClient

    def initialize(server_host, port, host_handler)
        @server_host = server_host
        @port = port
        @host_handler = host_handler
    end

    def generate_devkeys(hashes_list)
        results = request_to_server("generate_devkeys", hashes_list)
        results["devkeys_list"]
    end

    def generate_leases(hashes_list, duration)
        results = request_to_server("generate_leases", hashes_list, duration)
        results["leases_list"]
    end

    private

    def request_to_server(method, *params)
       tmp_server = XMLRPC::Client.new(@server_host, nil, @port)
       tmp_server.call("#{@host_handler}.#{method}", *params)
    end
    
end

