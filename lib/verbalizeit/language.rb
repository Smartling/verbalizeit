module Verbalizeit
  class Language

    attr_reader :name, :language_region_code

    def initialize(attributes)
      @name = attributes[:name] || attributes["name"]
      @language_region_code = attributes[:language_region_code] || attributes["language_region_code"]
    end

    def self.find_by_language_region_code(languages, language_region_code)
      languages.select {|l| l.language_region_code == language_region_code}.first
    end

  end
end