module Verbalizeit
  class Language

    attr_reader :name, :language_region_code

    def initialize(attributes)
      @name = attributes[:name] || attributes["name"]
      @language_region_code = attributes[:language_region_code] || attributes["language_region_code"]
    end

  end
end