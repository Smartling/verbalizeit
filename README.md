# Verbalizeit

The VerbalizeIt gem is a wrapper for [VerbalizeIt’s](https://www.verbalizeit.com) V2 API. Full documentation for the V2 API can be found [here](https://customers.verbalizeit.com/api_documentation). The VerbalizeIt API allows developers to submit files for translation or transcription directly, without using the Customer Dashboard.

## Code Status

[![Circle CI](https://circleci.com/gh/VerbalizeItInc/verbalizeit.svg?style=svg)](https://circleci.com/gh/VerbalizeItInc/verbalizeit)
[![Code Climate](https://codeclimate.com/github/VerbalizeItInc/verbalizeit/badges/gpa.svg)](https://codeclimate.com/github/VerbalizeItInc/verbalizeit)

## Installation

Add this line to your application's Gemfile:

    gem 'verbalizeit'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install verbalizeit

## Usage

The VerbalizeIt gem supports the same endpoints as the V2 API.

### Authentication

Initialize the VerbalizeIt client with your API key and the API environment. The supported API environments are `:staging` and `:production`.

```ruby
client = VerbalizeIt::Client.new('my_key', :staging)
```

### Languages

##### List

Returns an array of `Verbalizeit::Language` objects.

```ruby
languages = client.languages
#=> [Verbalizeit::Language,...]
```

A `Verbalizeit::Language` has a `name` and a `language_region_code`

```ruby
language = languages.first

language.name
#=> "English"
language.language_region_code 
#=> "eng-US"
```

### Tasks

##### List

Returns an array of `Verbalizeit::Task` objects. `list_tasks` has three optional parameters: `start`, `limit`, and `status`. By default, the `limit` is set to 10.

```ruby
client.list_tasks({start: 0, limit: 5, status: 'preview'})
#=> {
#  total: 10,
#  start: 0,
#  limit: 5,
#  tasks: [Verbalizeit::Task,...]
# }
```

##### Show

Returns a `Verbalizeit::Task` object.

```ruby
id = 'T2EB60C'
task = client.get_task(id)
#=> Verbalizeit::Task
```

A task has methods for each attribute. See the [tasks show response](https://customers.verbalizeit.com/api_documentation#tasks_show) in the V2 API documentation for a full list of attributes.

```ruby
task.id
#=> 'T2EB60C'

task.status
#=> 'preview'

task.price_amount
#=> 11.22
```

##### Create

Creates a new task in the VerbalizeIt system. Returns a `Verbalizeit::Task`.

Required parameters: `operation`, `source_language`, `target_language`, at least one of `file` or `media_resource_url`.
Optional parameters: `postback_url`, `status_url`, `start`, `rush_order`

Optional parameters, as well as the `file` and `media_resource_url`, are passed in through an options hash.

```ruby
client.create_task('text_translation', 'eng-US', 'fra-FR', {file: 'file.xliff', postback_url: 'https://www.postback.com'})
#=> Verbalizeit::Task
```

##### Start

Starts a created task. Returns a status code of `200`.

```ruby
id = 'T2EB60C'
client.start_task(id)
#=> 200
```

##### Download Completed File

Returns a struct with the filename and body of a completed file for a task. Only available if the task is in the "complete" state.

```ruby
id = 'T2EB60C'
completed_file = client.task_completed_file(id)
completed_file.filename
#=> sample.txt
completed_file.content
#=> "This is some sample text. \n\n And here is another paragraph"
```

If you would like to write the file to your local filesytem, you could do something like this.

```ruby
file = File.open(completed_file.filename, "w")
file << completed_file.content
file.close
```

### Errors

There are 5 types of errors.

* `Verbalizeit::Error::Unauthorized` is raised if the `Verbalizeit::Client` is initialized with an invalid API key, or if the API key does not match the environement. API keys can be created from the customer dashboard under 'API' in the left-hand navigation.
* `Verbalizeit::Error::UnknownEnvironment` is raised if the client is initialized with an environment that does not exist. The available environments are `:staging` and `:production`.
* `Verbalizeit::Error::BadRequest` can be raised for a variety of reasons, the error message will help you debug why this is being raised. Common examples would be creating a task with an invalid `operation`, `source_language`, or `target_language`.
* `Verbalizeit::Error::Forbidden` is raised if the user tries to access a task that does not belong to them.
* `Verbalizeit::Error::NotFound` is raised if the user tries to access a task that does not exist.
