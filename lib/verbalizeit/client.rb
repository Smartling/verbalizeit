require 'typhoeus'
require 'json'
module Verbalizeit
  class UnknownEnvironmentError < StandardError
  end

  class UnauthorizedError < StandardError
  end

  class Client

    attr_reader :languages

    def initialize(api_key, environement)
      @api_key = api_key
      @environment = environement
      @languages = fetch_languages
    end

    private

    def fetch_languages
      response = Typhoeus.get(languages_url, headers: {"x-api-key" => @api_key})

      if response.code == 200
        parsed_body = JSON.parse(response.body)
        parsed_body.map { |language| Language.new(language) }
      elsif response.code == 401
        raise UnauthorizedError
      end
    end

    def languages_url
      base_url << "languages"
    end

    def base_url
      case @environment
        when :staging
          "https://stagingapi.verbalizeit.com/v2/"
        when :production
          "https://api.verbalizeit.com/v2/"
        else
          raise UnknownEnvironmentError, "you may specify :staging or :production"
      end
    end

  end
end