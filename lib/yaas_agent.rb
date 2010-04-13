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

# Yet Another Activation System - Agent
# Abstraction layer between yaas-server and generation scripts

class YaasAgent

    def initialize(devkey_script_path, lease_script_path)
        @devkey_script_path = devkey_script_path
        @lease_script_path = lease_script_path
    end

    def generate_devkeys(hashes_list)
        devkeys_list = []

        hashes_list.each { |hash|
            if valid_hash(hash)
                devkey = generate_devkey(hash["serial_number"], hash["uuid"])
                devkeys_list.push(devkey)
            end   
        }

        { "devkeys_list" => devkeys_list }
    end

    def generate_leases(hashes_list, duration)
        leases_list = []

        hashes_list.each { |hash|
            if valid_hash(hash)
                lease = generate_lease(hash["serial_number"], hash["uuid"], duration)
                leases_list.push(lease)
            end
        }

        { "leases_list" => leases_list }
    end

    private

    def valid_hash(hash)
        return true if (valid_serial_number(hash["serial_number"]) and valid_uuid(hash["uuid"]))
        false
    end

    def valid_serial_number(serial_number)
        return true if serial_number.match("^[A-Z]{3}[(0-9)|(A-F)]{8}$")
        false
    end

    def valid_uuid(uuid)
        return true if uuid.match("^[(0-9)|(A-F)]{8}(-[(0-9)|(A-F)]{4}){3}-[(0-9)|(A-F)]{12}$")
        false
    end

    def generate_devkey(serial_number, uuid)
        cmd_line = "#{@devkey_script_path} #{serial_number} #{uuid}"
        run_cmd(cmd_line)
    end

    def generate_lease(serial_number, uuid, duration)
        cmd_line = "#{@lease_script_path} #{serial_number} #{uuid} #{duration}"
        run_cmd(cmd_line)
    end

    def run_cmd(cmd_line)
        IO.popen(cmd_line) do |cmd|
          cmd.readlines.join('')
        end 
    end

end
