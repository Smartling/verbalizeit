module Verbalizeit
  class Translator

    def initialize(translator)
      @translator = translator
    end

    def name
      @translator["name"]
    end

    def avatar
      @translator["avatar"]
    end

  end
end