require 'sinatra'
require File.join(__dir__, 'jobs_repository')

class App < Sinatra::Base
  get '/feed' do
    content_type 'text/xml'
    @jobs = JobsRepository.fetch_jobs
    erb :feed
  end
end
