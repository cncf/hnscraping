require 'rubygems'
require 'bundler'

Bundler.require

require File.join(__dir__, 'lib', 'app')
require File.join(__dir__, 'lib', 'generate_files')

run App
