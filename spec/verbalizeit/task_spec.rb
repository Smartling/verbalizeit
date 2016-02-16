require 'spec_helper'

describe Verbalizeit::Task do

  describe 'initializing a task object from a json response' do

    before(:all) do
      VCR.use_cassette('task/languages') do
        json = File.read('./spec/support/created_task.json')
        body = JSON.parse(json)
        @client = Verbalizeit::Client.new(ENV['STAGING_API_KEY'], :staging)
        @task = Verbalizeit::Task.from(body, @client)
      end
    end

    it 'has an id' do
      expect(@task.id).to eq('TX1234')
    end

    it 'has a url' do
      expect(@task.url).to eq('http://www.verbalizeit.com/v2/tasks/TCAAA')
    end

    it 'has a status' do
      expect(@task.status).to eq('complete')
    end

    it 'knows if it is a rush order' do
      expect(@task.rush_order).to eq(false)
    end

    it 'has a project name' do
      expect(@task.project_name).to eq('Marketing Materials')
    end

    it 'has a source language' do
      expect(@task.source_language.name).to eq('English')
      expect(@task.source_language.language_region_code).to eq('eng-US')
    end

    it 'has a target language' do
      expect(@task.target_language.name).to eq('Spanish')
      expect(@task.target_language.language_region_code).to eq('spa-ES')
    end

    it 'has a price currency' do
      expect(@task.price_currency).to eq('usd')
    end

    it 'has a price amount' do
      expect(@task.price_amount).to eq(11.22)
    end

    it 'has an estimated due at' do
      expect(@task.due_at).to eq('2014-10-13T11:56:02-04:00')
    end

    it 'knows when it was completed' do
      expect(@task.completed_at).to eq('2014-10-09T12:11:06-04:00')
    end

    it 'knows when it was created' do
      expect(@task.created_at).to eq('2014-10-09T11:56:02-04:00')
    end

    it 'has an operation' do
      expect(@task.operation).to eq('text_translation')
    end

    it 'has a download url' do
      expect(@task.download_url).to eq('https://api.verbalizeit.com/v2/tasks/TX1234/completed_file')
    end

    it 'has a source download url' do
      expect(@task.source_download_url).to eq('https://api.verbalizeit.com/v2/tasks/TX1234/source_file')
    end

    it 'has a source filename' do
      expect(@task.source_filename).to eq('marketing_materials.docx')
    end

    it 'has a unit count' do
      expect(@task.unit_count).to eq(66)
    end

    it 'has a unit type' do
      expect(@task.unit_type).to eq('word')
    end

    it 'has a number of translation units' do
      expect(@task.translation_units).to eq(16)
    end

    it 'knows how many of the translation units are complete' do
      expect(@task.translation_units_complete).to eq(16)
    end

    it 'has the translators name' do
      expect(@task.translator.name).to eq('Jenny S.')
    end

    it 'has the translators avatar' do
      expect(@task.translator.avatar).to eq('http://assets.verbalizeit.com/translator.jpg')
    end

    it 'has the reviewers name' do
      expect(@task.reviewer.name).to eq('Stephen D.')
    end

    it 'has the reviewers avatar' do
      expect(@task.reviewer.avatar).to eq('http://assets.verbalizeit.com/revewier.jpg')
    end

    it 'has a postback url' do
      expect(@task.postback_url).to eq('https://api.mycompany.com/finished_task')
    end

    it 'has a status url' do
      expect(@task.status_url).to eq('https://api.mycompany.com/task_changed_status')
    end

    it 'has special instructions' do
      expect(@task.special_instructions).to eq('My instructions')
    end

  end

end