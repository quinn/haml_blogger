#!/usr/bin/env ruby
# My Awesome Blogging Script

require 'pathname'
require 'fileutils'
require 'yaml'

class String
  def shorten (count = 30)
    if self.length >= count 
      shortened = self[0, count]
      splitted = shortened.split(/\s/)
      words = splitted.length
      splitted[0, words-1].join(" ")
    else 
      self
    end
  end
end
post = {}
post[:key] = ARGV[0]

puts "Whats it called?"
post[:title]  = STDIN.gets.chomp
post[:poster] = ENV['USER']
post[:created_at] = Time.now
post[:haml] = "blog/haml/#{post[:key]}.haml"
yaml_file   = "blog/yaml/#{post[:key]}.yaml"

puts 'reading content from haml file...'
post[:content] = open(post[:haml]).read

File.open(yaml_file, 'w') do |post_file|
  post_file.write post.to_yaml
end

puts "done! now run:\nstaticmatic build ."
