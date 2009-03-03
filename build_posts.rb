#!/usr/bin/env ruby
# My Awesome Blogging Script

require 'pathname'
require 'fileutils'
require 'yaml'
require 'erb'

template_file = open('blog/templates/post.haml.erb').read
template = ERB.new template_file
whitespace = template_file.split("\n")[-1].split("<").first

puts "building haml files in src/ from yaml files in blog/yaml/"
Dir.glob('blog/yaml/*').each do |yaml_file|
  post = YAML.load open(yaml_file)

  contents = post[:content].split("\n")
  first_line = contents.shift
  contents.collect! do |line|
    line = whitespace + line
  end
  contents.unshift first_line
  post[:content] = contents.join("\n")
  
  haml_file = "src/pages/blog/posts/#{post[:key]}.haml"
  File.open(haml_file, 'w+') do |file|
    if file.read == ""
      file.write template.result(binding)      
      break
    end
  
    unless file.read == haml
      puts "(#{haml_file}) error: \n it seems as though the source has been tampered with, or the template 
      has changed since the file was created. To allow overwrite of the file, please truncate(bash$ >filename) 
      it first."
    end
  end
end
