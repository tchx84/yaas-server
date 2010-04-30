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

    def initialize(devkey_script_path, lease_script_path, secret_keyword)
        @devkey_script_path = devkey_script_path
        @lease_script_path  = lease_script_path
        @secret_keyword     = secret_keyword
    end

    def generate_devkeys(secret_keyword="", hashes_list={})
        authsin(secret_keyword)
        devkeys_list = []

        hashes_list.each { |hash|
            if valid_hash(hash)
                devkey = generate_devkey(hash["serial_number"], hash["uuid"])
                devkeys_list.push(devkey)
            end   
        }

        { "devkeys_list" => devkeys_list }
    end

    def generate_leases(secret_keyword="", hashes_list={}, duration=0)
        authsin(secret_keyword)
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

    def authsin(secret_keyword)
      raise "Alert! Intruders." if @secret_keyword != secret_keyword
    end

    def valid_hash(hash)
        return true if (valid_serial_number(hash["serial_number"]) and valid_uuid(hash["uuid"]))
        false
    end

    def valid_serial_number(serial_number)
        return true if serial_number.upcase.match("^[A-Z]{3}[(0-9)|(A-F)]{8}$")
        false
    end

    def valid_uuid(uuid)
        return true if uuid.upcase.match("^[(0-9)|(A-F)]{8}(-[(0-9)|(A-F)]{4}){3}-[(0-9)|(A-F)]{12}$")
        false
    end

    def generate_devkey(serial_number, uuid)
        params   = "#{serial_number} #{uuid}"
        run_cmd(@devkey_script_path, params)
    end

    def generate_lease(serial_number, uuid, duration)
        params   = "#{serial_number} #{uuid} #{duration}"
        run_cmd(@lease_script_path, params)
    end

    def run_cmd(script_path, params)
        exec_path = File.dirname(script_path)
        script_file = File.basename(script_path)

        # I know, I know this hack sucks...
        IO.popen("cd #{exec_path}; ./#{script_file} #{params}") do |cmd|
          cmd.readlines.join('')
        end
    end

end
