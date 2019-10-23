class App < Sinatra::Base
  post '/deploy' do
    request.body.rewind
    payload_body = request.body.read
    verify_signature(payload_body)
    event = request.env['HTTP_X_GITHUB_EVENT']
    push = JSON.parse(payload_body)
    if event == 'push' && push['ref'] == 'refs/heads/master'
      directory = File.expand_path(File.join(__dir__, '..'))
      log_file = "#{directory}/log/deploy.log"
      command = %{nohup bash -c "cd #{directory} && bin/provision" > #{log_file} & disown}
      `#{command}`
      "Deploy triggered.\n\nExecuting command: #{command}.\n\nLogs saved at #{log_file}\n"
    else
      "Not deploying.\nEvent: #{event}\nRef: #{push['ref']}\n"
    end
  end

  private

  def verify_signature(payload_body)
    return if ENV['RACK_ENV'] == 'development'
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV.fetch('GITHUB_TOKEN'), payload_body)
    return halt 500, "Signatures didn't match!" unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
  end
end
