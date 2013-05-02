#!/usr/bin/ruby
=begin
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
=end

require "rexml/document"
include REXML
require 'csv'

def usage (message = nil)
  if message
    $stderr.puts "ERROR: #{message}"
  end
  $stderr.puts """Usage: 1pass2keepass.rb 1pass.csv > keepassx.xml

Takes a comma delimeted csv file from 1password and prints XML suitable for import into keepassX
A useful technique is to direct this output to an XML file.
"""
  exit
end


input_file = ARGV[0]
unless input_file
  usage
end
unless File.exists?(input_file)
  usage "File '#{input_file}' does not exist" 
end

begin
  csv_data = CSV.read(input_file)
  headers = csv_data.shift.map {|i| i.to_s }
  string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
  array_of_hashes = string_data.map {|row| Hash[*headers.zip(row).flatten] }
rescue
  usage $!
end


doc = Document.new 
database = doc.add_element 'database'
group = database.add_element 'group'
group.add_element('title').text = 'Import'
group.add_element('icon').text = '26'


array_of_hashes.each do |row|
  entryNode = group.add_element 'entry'
  # The username may be linked from "username" or "user".
  if row['username']
    # "username" is used by 1pass
    entryNode.add_element('username').text = row['username']
  elsif row['user']
    # "user" is used by password gorilla.
    entryNode.add_element('username').text = row['user']
  end
  
  entryNode.add_element('password').text = row['password']
  entryNode.add_element('title').text = row['title']
 
  # The location has a lot of different names. 
  if row['URL/Location']
    # "URL/Location" isused by 1pass
    entryNode.add_element('url').text = row['URL/Location']
  elsif row['url']
    # "url" is used by password gorilla
    entryNode.add_element('url').text = row['url']
  elsif row['hostname']
    # "hostname" is used by some firefox export utility.
    entryNode.add_element('url').text = row['hostname']
  end

  entryNode.add_element('comment').text = row['notes']
end

doc << XMLDecl.new
doc.write($stdout,2)
