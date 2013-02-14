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

    def initialize(devkey_script_path, lease_script_path, secret_keyword, num_threads, logger)
        @devkey_script_path = devkey_script_path
        @lease_script_path  = lease_script_path
        @secret_keyword     = secret_keyword
        @num_threads        = num_threads
        @logger             = logger
    end

    def generate_devkeys(secret_keyword="", hashes_list={})
        authsin(secret_keyword)
        exec_list = []
        devkeys_list = []

        hashes_list.each { |hash|
            if valid_hash(hash)
                exec_list.push("#{hash["serial_number"]} #{hash["uuid"]}")
            end   
        }

        devkeys_list = do_generate(@devkey_script_path, exec_list)
        { "devkeys_list" => devkeys_list }
    end

    def generate_leases(secret_keyword="", hashes_list={}, duration=0)
        authsin(secret_keyword)
        exec_list = []
        leases_list = []

        hashes_list.each { |hash|
            if valid_hash(hash)
                exec_list.push("#{hash["serial_number"]} #{hash["uuid"]} #{duration}")
            end
        }

        leases_list = do_generate(@lease_script_path, exec_list)
        { "leases_list" => leases_list }
    end

    private

    def authsin(secret_keyword)
      raise "Alert! Intruders." if @secret_keyword != secret_keyword
    end

    def valid_hash(hash)
        # for some strange reason, Ruby's regexp checking accepts newlines
        # outside of the regex match? make sure we get rid of any...
        hash["serial_number"].strip!
        hash["uuid"].strip!
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

    def run_in_thread(exec_path, script_file, params)
      cmd = "cd #{exec_path}; ./#{script_file} #{params}"
      fd = IO.popen(cmd)
      @logger.info("Run #{fd.pid}: #{cmd}")
      @procs[fd.pid] = fd
    end

    def reap()
      begin
        pid, status = Process.wait2
        fd = @procs[pid]
        @logger.error("Reaped pid #{pid} status #{status.exitstatus}")
        if fd.nil?
          @logger.error("pid not found in table?")
          return false
        end
        @results.push(fd.readlines)
        fd.close
        @procs.delete(pid)
        true
      rescue Errno::ECHILD
        false
      end
    end

    def do_generate(script_path, requests)
      @results = []
      @procs = Hash.new
      exec_path = File.dirname(script_path)
      script_file = File.basename(script_path)

      # seed initial processes
      for i in 1..@num_threads
        params = requests.pop
        break if not params
        run_in_thread(exec_path, script_file, params)
      end

      # run a new process for every one that terminates
      while requests.any?
        reap()
        run_in_thread(exec_path, script_file, requests.pop)
      end

      while reap()
      end

      @results
    end

end
