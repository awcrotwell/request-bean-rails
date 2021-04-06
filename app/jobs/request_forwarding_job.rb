class RequestForwardingJob < ApplicationJob
  queue_as :default

  def perform(request, webhook_url)
    uri = URI(webhook_url) # TODO: don't break if not prefixed with http://
    req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    req.body = request.payload
    Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
  end
end