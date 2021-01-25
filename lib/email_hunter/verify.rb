# frozen_string_literal: true

require 'faraday'
require 'json'

API_VERIFY_URL = 'https://api.hunter.io/v2/email-verifier?'

module EmailHunter
  class Verify
    attr_reader :result, :score, :regexp, :gibberish, :disposable, :webmail, :mx_records, :smtp_server, :smtp_check, :accept_all, :sources, :meta

    def initialize(email, key)
      @email = email
      @key = key
    end

    def hunt
      response = apiresponse
      Struct.new(*response.keys).new(*response.values) unless response.empty?
    end

    private

    def apiresponse
      url = "#{API_VERIFY_URL}#{URI.encode_www_form(api_key: @key, email: @email)}"
      response = Faraday.new(url).get
      response.success? ? JSON.parse(response.body, { symbolize_names: true }) : []
    end
  end
end
