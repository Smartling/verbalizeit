require 'spec_helper'

describe Verbalizeit::Language do

  describe 'initialize with strings' do

    before(:all) do
      @language = Verbalizeit::Language.new({'name' => 'English', 'language_region_code' => 'eng-US'})
    end

    it 'has a name' do
      expect(@language.name).to eq('English')
    end

    it 'has a language_region_code' do
      expect(@language.language_region_code).to eq('eng-US')
    end

  end

  describe 'initialize with symbols' do

    before(:all) do
      @language = Verbalizeit::Language.new({name: 'English', language_region_code: 'eng-US'})
    end

    it 'has a name' do
      expect(@language.name).to eq('English')
    end

    it 'has a language_region_code' do
      expect(@language.language_region_code).to eq('eng-US')
    end

  end

  describe 'find_by_language_region_code' do

    it 'can find a language given a language region code and a list of languages' do
      VCR.use_cassette('language/find_by_language_region_code') do
        client = Verbalizeit::Client.new(ENV['STAGING_API_KEY'], :staging)
        language = Verbalizeit::Language.find_by_language_region_code(client.languages, 'eng-US')
        expect(language.name).to eq('English')
        expect(language.language_region_code).to eq('eng-US')
      end
    end

  end

end