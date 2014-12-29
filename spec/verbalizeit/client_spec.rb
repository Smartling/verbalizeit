require 'spec_helper'

describe Verbalizeit::Client do

  let(:staging_api_key) { ENV['STAGING_API_KEY'] }
  let(:source_language) { 'eng-US' }
  let(:target_language) { 'fra-FR' }
  let(:operation) { 'text_translation' }
  let(:video) { 'video_transcription' }
  let(:file_xliff) { File.open(File.expand_path('./spec/support/sample.xliff'), 'r') }
  let(:file_srt) { File.open(File.expand_path('./spec/support/sample.srt'), 'r') }
  let(:media_resource_url) { 'http://vimeo.com/100265082' }
  let(:postback_url) { 'https://verbalizeit.com/postback' }
  let(:status_url) { 'https://verbalizeit.com/status' }

  describe 'initialize' do

    it 'raises Verbalizeit::Error::Unauthorized if api key is invalid' do
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

  describe 'create task' do

    it 'raises Verbalizeit::Error::BadRequest if no source_language is present' do
      VCR.use_cassette('client/no_source_language') do
        client = Verbalizeit::Client.new(staging_api_key, :staging)

        options = {file: file_xliff}

        expect {
          client.create_task(nil, target_language, operation, options)
        }.to raise_error(Verbalizeit::Error::BadRequest)
      end
    end

    it 'raises Verbalizeit::Error::BadRequest if no target_language is present' do
      VCR.use_cassette('client/no_target_language') do
        client = Verbalizeit::Client.new(staging_api_key, :staging)

        options = {file: file_xliff}

        expect {
          client.create_task(source_language, nil, operation, options)
        }.to raise_error(Verbalizeit::Error::BadRequest)
      end
    end

    it 'raises Verbalizeit::Error::BadRequest if no operation is present' do
      VCR.use_cassette('client/no_operation') do
        client = Verbalizeit::Client.new(staging_api_key, :staging)

        options = {file: file_xliff}

        expect {
          client.create_task(source_language, target_language, nil, options)
        }.to raise_error(Verbalizeit::Error::BadRequest)
      end
    end

    it 'raises Verbalizeit::Error::BadRequest if no url or file is present' do
      VCR.use_cassette('client/no_file_or_url') do
        client = Verbalizeit::Client.new(staging_api_key, :staging)

        expect {
          client.create_task(source_language, target_language, operation)
        }.to raise_error(Verbalizeit::Error::BadRequest)
      end
    end

    it 'creates a task' do
      VCR.use_cassette('client/create_task') do
        client = Verbalizeit::Client.new(staging_api_key, :staging)

        options = {file: file_xliff}

        task = client.create_task(source_language, target_language, operation, options)
        expect(task.id).to_not eq(nil)
        expect(task.status).to_not eq(nil)
        expect(task.rush_order).to eq(false)
        expect(task.price_amount > 0).to eq(true)
        expect(task.translation_units).to eq(3)
        expect(task.status).to eq('preview')
      end
    end

    it 'creates a task with postback/status urls as a rush order' do
      VCR.use_cassette('client/create_postback_task') do
        client = Verbalizeit::Client.new(staging_api_key, :staging)

        options = {
          file: file_xliff, postback_url: postback_url,
          status_url: status_url
        }

        task = client.create_task(source_language, target_language, operation, options)
        expect(task.id).to_not eq(nil)
        expect(task.status).to_not eq(nil)
        expect(task.rush_order).to eq(false)
        expect(task.price_amount > 0).to eq(true)
        expect(task.status).to eq('preview')
        expect(task.postback_url).to eq(postback_url)
        expect(task.status_url).to eq(status_url)
      end
    end

    it 'creates a task and starts it' do
      VCR.use_cassette('client/create_task_start_task') do
        client = Verbalizeit::Client.new(staging_api_key, :staging)

        options = {
          file: file_srt, media_resource_url: media_resource_url,
          start: true, rush_order: true
        }

        task = client.create_task(source_language, target_language, video, options)
        expect(task.id).to_not eq(nil)
        expect(task.status).to_not eq(nil)
        expect(task.rush_order).to eq(true)
        expect(task.price_amount > 0).to eq(true)
        expect(task.status).to eq('processing')
      end
    end

  end

  describe 'list tasks' do

    it 'gets a list of all the tasks' do
      VCR.use_cassette('client/list_tasks') do
        client = Verbalizeit::Client.new(staging_api_key, :staging)

        tasks = client.list_tasks

        expect(tasks[:total]).to eq(7)
        expect(tasks[:start]).to eq(0)
        expect(tasks[:limit]).to eq(10)
        expect(tasks[:tasks].first.id).to_not eq(nil)
      end
    end

    it 'can specify a start and limit' do
      VCR.use_cassette('client/list_tasks_start_limit') do
        client = Verbalizeit::Client.new(staging_api_key, :staging)

        tasks = client.list_tasks({start: 2, limit: 5})

        expect(tasks[:total]).to eq(7)
        expect(tasks[:start]).to eq(2)
        expect(tasks[:limit]).to eq(5)
        expect(tasks[:tasks].first.id).to_not eq(nil)
        expect(tasks[:tasks].size).to eq(5)
      end
    end

    it 'can specify a status' do
      VCR.use_cassette('client/list_tasks_status') do
        client = Verbalizeit::Client.new(staging_api_key, :staging)

        tasks = client.list_tasks({status: 'preview'})

        expect(tasks[:total]).to eq(6)
        expect(tasks[:start]).to eq(0)
        expect(tasks[:limit]).to eq(10)
        expect(tasks[:tasks].first.id).to_not eq(nil)
        expect(tasks[:tasks].size).to eq(6)
      end
    end

    it 'raises VerbalizeIt::Error::NotImplemented if an error response is received' do
      VCR.use_cassette('client/list_tasks_not_implemented') do
        struct = Struct.new(:code, :body)
        response = struct.new(400, {}.to_json)

        allow(Typhoeus).to receive(:get).and_return(response)

        client = Verbalizeit::Client.new(staging_api_key, :staging)

        expect { client.list_tasks }.to raise_error(Verbalizeit::Error::NotImplemented)
      end
    end

  end

  describe 'get task' do

    it 'raises VerbalizeIt::Error::NotFound if the task does not exist' do
      VCR.use_cassette('client/get_task_not_found') do
        client = Verbalizeit::Client.new(staging_api_key, :staging)

        expect {
          client.get_task('garbage')
        }.to raise_error(Verbalizeit::Error::NotFound)
      end
    end

    it 'raises VerbalizeIt::Error::Forbidden if the task does not belong to the account' do
      VCR.use_cassette('client/get_task_forbidden') do
        struct = Struct.new(:code, :body)
        response = struct.new(403, {}.to_json)

        allow(Typhoeus).to receive(:get).and_return(response)

        client = Verbalizeit::Client.new(staging_api_key, :staging)

        expect {
          client.get_task('sd9f8w3j434')
        }.to raise_error(Verbalizeit::Error::Forbidden)
      end
    end

    it 'can get an individual task' do
      VCR.use_cassette('client/get_task') do
        client = Verbalizeit::Client.new(staging_api_key, :staging)

        id = 'T2EB60C'
        response = client.get_task(id)

        expect(response.id).to eq(id)
        expect(response.status).to_not eq(nil)
      end
    end

  end

  describe 'start task' do

    it 'raises VerbalizeIt::Error::NotFound if the task does not exist' do
      VCR.use_cassette('client/start_task_not_found') do
        client = Verbalizeit::Client.new(staging_api_key, :staging)

        expect {
          client.start_task('garbage')
        }.to raise_error(Verbalizeit::Error::NotFound)
      end
    end

    it 'raises VerbalizeIt::Error::Forbidden if the task does not belong to the account' do
      VCR.use_cassette('client/start_task_forbidden') do
        struct = Struct.new(:code, :body)
        response = struct.new(403, {}.to_json)

        allow(Typhoeus).to receive(:get).and_return(response)

        client = Verbalizeit::Client.new(staging_api_key, :staging)

        expect {
          client.start_task('sd9f8w3j434')
        }.to raise_error(Verbalizeit::Error::Forbidden)
      end
    end

    it 'starts a task' do
      VCR.use_cassette('client/start_task') do
        client = Verbalizeit::Client.new(staging_api_key, :staging)
        options = {file: file_xliff}
        task = client.create_task(source_language, target_language, operation, options)

        expect(task.status).to_not eq('processing')

        response = client.start_task(task.id)

        expect(response).to eq(true)
      end
    end

  end

  describe 'task completed file' do

    it 'raises VerbalizeIt::Error::NotFound if the task does not exist' do
      VCR.use_cassette('client/completed_file_not_found') do
        client = Verbalizeit::Client.new(staging_api_key, :staging)

        expect {
          client.task_completed_file('garbage')
        }.to raise_error(Verbalizeit::Error::NotFound)
      end
    end

    it 'raises VerbalizeIt::Error::Forbidden if the task does not belong to the account' do
      VCR.use_cassette('client/completed_file_forbidden') do
        struct = Struct.new(:code, :body)
        response = struct.new(403, {}.to_json)

        allow(Typhoeus).to receive(:get).and_return(response)

        client = Verbalizeit::Client.new(staging_api_key, :staging)

        expect {
          client.task_completed_file('sd9f8w3j434')
        }.to raise_error(Verbalizeit::Error::Forbidden)
      end
    end

    it 'returns the completed file' do
      VCR.use_cassette('client/completed_file') do
        client = Verbalizeit::Client.new(staging_api_key, :staging)

        file = client.task_completed_file('T399ECD')

        expect(file).to include('I am sample translated text.')
      end
    end

  end

end
