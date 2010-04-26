#!/usr/bin/ruby

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

require "json"
require "xmlrpc/client"
require File.join(File.dirname(__FILE__), "../lib/yaas_client.rb")

yaas_client = YaasClient.new("localhost", "9090", "yaas")
hashes_list = [ {"serial_number" => "TCH12345678", "uuid" => "9D97000F-9082-4CB2-A8CC-097835906FCB"} ]
duration    = 10

devkeys_list = yaas_client.generate_devkeys(hashes_list)
puts devkeys_list.to_json

leases_list = yaas_client.generate_leases(hashes_list, duration)
puts leases_list.to_json
