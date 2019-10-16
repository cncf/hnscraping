require 'rubygems'
require 'bundler'

Bundler.require

require File.join(__dir__, 'lib', 'app')
run App
