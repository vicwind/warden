#!/usr/bin/env ruby
require 'erb'

project_name = ARGV[0]

puts ERB.new(File.read("#{ENV['WARDEN_HOME']}/etc/default_project_init.erb")).result(binding)

