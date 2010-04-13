# Copyright Paraguay Educa 2010
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

class ConfigFile

  def initialize(path)
    @conf_file = path
  end

  def read_file()
    begin
      @conf_settings = Hash.new
      File.open(@conf_file, "r") do |fp|
        lines = fp.readlines()
        lines.each { |l|
          next if l.match(/^#/)
          l.chomp!
          k,v = l.split("=")
          k = clean_str(k)
          v = clean_str(v)
          @conf_settings[k] = v
        }
      end
    rescue
      raise "Error: " + $!.to_s
    end
    @conf_settings
  end

  def get_key(k)
    @conf_settings[k]
  end

  private

  def clean_str(s)
    ret = s
    ret.gsub!(/\"/, "") if ret.match(/\"/)
    ret.gsub!(/ /, "") if ret.match(/ /)
    ret
  end

end
