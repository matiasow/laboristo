require_relative 'helper'

test 'initialize' do
  q = Laboristo::Queue.new(@queue_name)
  assert q.name == @queue_name
  assert q.sqs.is_a? Aws::SQS::Client
  assert q.url == @url
end

test 'initialize through []' do
  q = Laboristo[@queue_name]
  assert q.name == @queue_name
  assert q.sqs.is_a? Aws::SQS::Client
  assert q.url == @url
end

test 'push message to queue' do
  q = Laboristo[@queue_name]
  msg = SecureRandom.uuid

  q.push(msg)

  fetched = fetch_last_message
  delete_message(fetched)

  assert msg == message_body(fetched)
end

test 'push message to queue using <<' do
  q = Laboristo[@queue_name]
  msg = SecureRandom.uuid

  q << msg

  fetched = fetch_last_message
  delete_message(fetched)

  assert msg == message_body(fetched)
end

test 'fetch messages using pop' do
  q = Laboristo[@queue_name]
  msg = SecureRandom.uuid

  send_message(msg)

  q.pop do |m|
    assert m == msg
    break # only fetch one message
  end
end

test 'fetch messages using each' do
  q = Laboristo[@queue_name]
  msg = SecureRandom.uuid

  send_message(msg)

  q.each do |m|
    assert m == msg
    break # only fetch one message
  end
end

# And finally destroy the queue...
@client.delete_queue(queue_url: @url)
