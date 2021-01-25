# frozen_string_literal: true

require 'faraday'
require 'json'

API_EXIST_URL = 'https://api.emailhunter.co/v1/exist?'

module EmailHunter
  class Exist
    attr_reader :status, :email, :exist, :sources

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
      url = "#{API_EXIST_URL}#{URI.encode_www_form(api_key: @key, email: @email)}"
      response = Faraday.new(url).get
      response.success? ? JSON.parse(response.body, { symbolize_names: true }) : []
    end
  end
end
