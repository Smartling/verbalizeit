require 'spec_helper'

describe Verbalizeit::Client do

  let(:staging_api_key) { ENV['STAGING_API_KEY'] }

  describe 'initialize' do

    it 'raises Verbalizeit::Error::Unauthenticated if api key is invalid' do
      VCR.use_cassette('client/unauthorized') do
        expect { Verbalizeit::Client.new(12345, :staging) }.to raise_error(Verbalizeit::Error::Unauthorized)
      end
    end

    it 'raises Verbalizeit::Error:UnknownEnvironment if the environment is unknown' do
      expect { Verbalizeit::Client.new(staging_api_key, :foo) }.to raise_error(Verbalizeit::Error::UnknownEnvironment)
    end

    it 'authenticates the user and fetches the language list' do
      VCR.use_cassette('client/language_list') do
        client = Verbalizeit::Client.new(staging_api_key, :staging)

        expect(client.languages.count > 1).to eq(true)
        expect(client.languages.first.name).to eq('English')
        expect(client.languages.first.language_region_code).to eq('eng-US')
      end
    end

  end

end