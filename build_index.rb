#!/usr/bin/env ruby
# My Awesome Blogging Script

require 'pathname'
require 'fileutils'
require 'yaml'
require 'erb'

template = ERB.new open('blog/templates/index.haml.erb').read
whitespace = "      "
posts = []

puts "building blog index"
Dir.glob('blog/yaml/*').each do |yaml_file|
  post = YAML.load open(yaml_file)
  
  contents = post[:summary].split("\n")
  first_line = contents.shift
  contents.collect! do |line|
    line = whitespace + line
  end
  contents.unshift first_line
  post[:summary] = contents.join("\n")
  
  posts << post
end

File.open('src/pages/blog/index.haml', 'w') do |file|
  file.write template.result(binding)
end
