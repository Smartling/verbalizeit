require 'typhoeus'
require 'json'
module Verbalizeit
  class Client

    attr_reader :languages

    def initialize(api_key, environement)
      @api_key = api_key
      @environment = environement
      @languages = fetch_languages
    end

    def create_task(source_language, target_language, operation, options = {})
      body = {
        source_language: source_language,
        target_language: target_language,
        operation: operation,
        file: options[:file],
        media_resource_url: options[:media_resource_url],
        start: "#{options[:start]}",
        rush_order: "#{options[:rush_order]}",
        postback_url: options[:postback_url],
        status_url: options[:status_url]
      }

      response = Typhoeus.post(create_task_url, body: body, headers: authorization_header)

      if response.code == 200
        Verbalizeit::Task.from(response.body, self)
      elsif response.code == 400
        raise Error::BadRequest, format_errors(response.body)
      elsif response.code == 401
        raise Error::Unauthorized
      end
    end

    private

    def fetch_languages
      response = Typhoeus.get(languages_url, headers: authorization_header)

      if response.code == 200
        parsed_body = JSON.parse(response.body)
        parsed_body.map { |language| Language.new(language) }
      elsif response.code == 401
        raise Error::Unauthorized
      end
    end

    def create_task_url
      base_url << "tasks"
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
          raise Error::UnknownEnvironment, "you may specify :staging or :production"
      end
    end

    def authorization_header
      {"x-api-key" => @api_key}
    end

    def format_errors(body)
      JSON.parse(body).map { |_, errors| errors.map { |type, error| error } }.flatten.join(".")
    end

  end
end