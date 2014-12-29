module Verbalizeit
  class Task

    def self.from(body, client)
      parsed_body = JSON.parse(body)
      new(parsed_body, client)
    end

    def initialize(task, client)
      @task = task
      @client = client
    end

    def id
      @task["id"]
    end

    def url
      @task["url"]
    end

    def status
      @task["status"]
    end

    def rush_order
      @task["rush_order"]
    end

    def project_name
      @task["project_name"]
    end

    def source_language
      Language.find_by_language_region_code(@client.languages, @task["source_language"])
    end

    def target_language
      Language.find_by_language_region_code(@client.languages, @task["target_language"])
    end

    def price_currency
      @task["price_currency"]
    end

    def price_amount
      @task["price_amount"]
    end

    def due_at
      @task["due_at"]
    end

    def completed_at
      @task["completed_at"]
    end

    def created_at
      @task["created_at"]
    end

    def operation
      @task["operation"]
    end

    def download_url
      @task["download_url"]
    end

    def source_download_url
      @task["source_download_url"]
    end

    def source_filename
      @task["source_filename"]
    end

    def unit_count
      @task["unit_count"]
    end

    def unit_type
      @task["unit_type"]
    end

    def translation_units
      @task["translation_units"]
    end

    def translation_units_complete
      @task["translation_units_complete"]
    end

    def translator
      Translator.new(@task["translator"])
    end

    def reviewer
      Translator.new(@task["reviewer"])
    end

    def postback_url
      @task["postback_url"]
    end

    def status_url
      @task["status_url"]
    end

  end
end