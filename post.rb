#!/usr/bin/env ruby
# My Awesome Blogging Script

require 'pathname'
require 'fileutils'
require 'yaml'

class String
  def shorten (count = 30)
    if self.length >= count 
      shortened = self[0, count]
      splitted = shortened.split('/\s/')
      words = splitted.length
      splitted[0, words-1].join(" ")
    else 
      self
    end
  end
  
  def multiline_shorten(count = 150, lines = nil, res = "")
    unless lines
      lines = self.split("\n")
    end
    
    res += "\n" + lines.shift
    return res if lines.empty?
    
    if res.length > count
      return res
    else
      multiline_shorten count, lines, res
    end
  end
end

post = {}

puts "Whats it called?"
post[:title]  = gets.chomp
post[:poster] = ENV['USER']
post[:created_at] = Time.now
post[:key] = "#{post[:created_at].strftime('%G%m%d')}-#{post[:title].shorten.downcase.gsub(' ','_')}"
post[:haml] = "blog/haml/#{post[:key]}.haml"
yaml_file   = "blog/yaml/#{post[:key]}.yaml"
FileUtils.touch post[:haml]
`#{ENV['BLOG_EDITOR']} #{post[:haml]}`

puts 'reading content from haml file...'
post[:content] = open(post[:haml]).read
post[:summary] = post[:content].multiline_shorten
File.open(yaml_file, 'w') do |post_file|
  post_file.write post.to_yaml
end

puts "done! now run:\n./build_posts.rb"
