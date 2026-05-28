#!/usr/bin/env ruby
require 'digest/sha2'

gem_name = ARGV[0]
built_gem_path = File.join('pkg', "#{gem_name}.gem")
return "gem #{gem_name} doesn't exist!" unless File.exists?(built_gem_path)

checksum = Digest::SHA512.new.hexdigest(File.read(built_gem_path))
FileUtils.mkdir 'checksum'
checksum_path = File.join("checksum", "#{gem_name}.gem.sha512")
File.open(checksum_path, 'w') {|f| f.write(checksum) }
