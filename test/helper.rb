require 'laboristo'
require 'securerandom'

if ENV['TRAVIS']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

def send_message(message)
  @client.send_message(queue_url: @url, message_body: Base64.encode64(message))
end

def fetch_last_message
  fetched = @client.receive_message(queue_url: @url,
                                    max_number_of_messages: 1,
                                    wait_time_seconds: 0).data.to_hash

  fetched[:messages].first
end

def message_body(msg)
  Base64.decode64(msg[:body])
end

def delete_message(msg)
  @client.delete_message(queue_url: @url,
                         receipt_handle: msg[:receipt_handle])
end

test 'environment' do
  assert ENV['AWS_REGION']
  assert ENV['AWS_ACCESS_KEY_ID']
  assert ENV['AWS_SECRET_ACCESS_KEY']
  assert ENV['AWS_ACCOUNT_ID']
end

@account = ENV['AWS_ACCOUNT_ID']
@region = ENV['AWS_REGION']
@client = Aws::SQS::Client.new

@queue_name = 'laboristo_test_' + SecureRandom.uuid
@url = @client.create_queue(queue_name: @queue_name).data.to_hash[:queue_url]
