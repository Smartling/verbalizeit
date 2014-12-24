require 'spec_helper'

describe Verbalizeit::Translator do

  before(:all) do
    translator_info = {
      'name' => 'Jenny S.',
      'avatar' => 'http://assets.verbalizeit.com/translator.jpg'
    }
    @translator = Verbalizeit::Translator.new(translator_info)
  end

  it 'has a name' do
    expect(@translator.name).to eq('Jenny S.')
  end

  it 'has an avatar' do
    expect(@translator.avatar).to eq('http://assets.verbalizeit.com/translator.jpg')
  end

end