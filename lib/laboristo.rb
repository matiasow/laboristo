require 'aws-sdk-core'
require 'base64'

module Laboristo
  class Queue
    attr_accessor :name
    attr_accessor :url
    attr_accessor :sqs

    def initialize(name)
      @name = name
      @sqs = Aws::SQS::Client.new
      @url = "https://sqs.#{ENV['AWS_REGION']}.amazonaws.com/#{ENV['AWS_ACCOUNT_ID']}/#{@name}"
    end

    def push(message)
      encoded = Base64.encode64(message.to_s)
      @sqs.send_message(queue_url: @url, message_body: encoded)
    end

    def each(&block)
      loop do
        resp = @sqs.receive_message(queue_url: @url,
                                    attribute_names: ['All'],
                                    max_number_of_messages: 10).data.to_hash

        resp[:messages] && resp[:messages].each do |msg|
          begin
            block.call(Base64.decode64 msg[:body])
            @sqs.delete_message(queue_url: @url,
                                receipt_handle: msg[:receipt_handle])
          rescue StandardError => e
            $stderr.puts "ERROR: Can't process message #{msg[:message_id]}.\n#{e}"
          end
        end
      end
    end

    alias << push
    alias pop each

    def purge
      @sqs.purge_queue(queue_url: @url)
    end
  end

  def self.[](queue)
    Queue.new(queue)
  end
end
