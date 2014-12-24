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

end