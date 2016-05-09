require 'sinatra'
require 'uri'
require 'net/http'
require 'json'

class Travis::Web::SentryDeployHook < Sinatra::Base
  set sentry_api_key: ENV['SENTRY_API_KEY']
  set sentry_org: 'travis-ci'
  set sentry_project: 'travis-web-h4'
  set sentry_releases_endpoint: "https://app.getsentry.com/api/0/projects/#{settings.sentry_org}/#{settings.sentry_project}/releases/"
  set github_commit_url: "https://github.com/travis-web/travis-ci/commit"


  post '/deploy/hooks/sentry' do
    request_body = {
      version: params["head"],
      ref: params["head_long"],
      commit_location: "#{settings.github_commit_url}/#{params["head_long"]}"
    }.to_json

    url = URI(settings.sentry_releases_endpoint)

    request = Net::HTTP::Post.new(url.request_uri, initheader = {'Content-Type' => 'application/json'})
    request.basic_auth settings.sentry_api_key, ''
    request.body = request_body

    Net::HTTP.start(url.host, url.port, use_ssl: true) do |http|
      http.request(request)
    end
  end
end
