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

require File.join(File.dirname(__FILE__), "../lib/yaas_server.rb")

config_file = File.join(File.dirname(__FILE__), "../etc/test.config")
yaas_server = YaasServer.new(config_file)
yaas_server.run()
