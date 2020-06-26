require 'erb'

include ERB::Util

require File.join(__dir__, 'jobs_repository')
require File.join(__dir__, 'helpers', 'debug_helper')

include DebugHelper

feed_template = File.read(File.join(__dir__, 'templates', 'feed.erb'))
debug_template = File.read(File.join(__dir__, 'templates', 'debug.erb'))

@jobs = JobsRepository.fetch_jobs

File.write(File.join(__dir__, '..', 'public', 'feed.xml'), ERB.new(feed_template, nil, '-').result(binding))
File.write(File.join(__dir__, '..', 'public', 'debug.html'), ERB.new(debug_template, nil, '-').result(binding))
