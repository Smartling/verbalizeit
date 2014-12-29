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

      response = Typhoeus.post(tasks_url, body: body, headers: authorization_header)

      if response.code == 200
        Task.from(parse_body(response.body), self)
      elsif response.code == 400
        raise Error::BadRequest, format_errors(response.body)
      elsif response.code == 401
        raise Error::Unauthorized
      end
    end

    def list_tasks(options = {})
      params = {
        start: options[:start],
        limit: options[:limit] || 10,
        status: options[:status]
      }
      response = Typhoeus.get(tasks_url, params: params, headers: authorization_header)

      if response.code == 200
        list_tasks_success(response.body)
      else
        raise Error::NotImplemented
      end
    end

    private

    def list_tasks_success(body)
      parsed_body = parse_body(body)

      {
        total: parsed_body["total"],
        start: parsed_body["start"],
        limit: parsed_body["limit"],
        tasks: parsed_body["tasks"].map { |task| Task.from(task, self) }
      }
    end

    def fetch_languages
      response = Typhoeus.get(languages_url, headers: authorization_header)

      if response.code == 200
        parsed_body = JSON.parse(response.body)
        parsed_body.map { |language| Language.new(language) }
      elsif response.code == 401
        raise Error::Unauthorized
      end
    end

    def tasks_url
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
      parse_body(body).map { |_, errors| errors.map { |type, error| error } }.flatten.join(".")
    end

    def parse_body(body)
      JSON.parse(body)
    end

  end
end