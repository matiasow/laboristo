# Laboristo

[![Gem Version](https://badge.fury.io/rb/laboristo.svg)][gem]
[![Dependency Status](https://gemnasium.com/matiasow/laboristo.svg)][gemnasium]
[![Code Climate](https://codeclimate.com/github/matiasow/laboristo/badges/gpa.svg)][codeclimate]
[![Build Status](https://travis-ci.org/matiasow/laboristo.svg?branch=master)][travis]

[gem]: http://badge.fury.io/rb/laboristo
[gemnasium]: https://gemnasium.com/matiasow/laboristo
[codeclimate]: https://codeclimate.com/github/matiasow/laboristo
[travis]: https://travis-ci.org/matiasow/laboristo

Laboristo is an attempt to port [Ost](https://github.com/soveran/ost) simplicity to AWS SQS.

![enter image description here](http://i.imgur.com/F6ZZNrx.jpg)

## Installation

Simply run:

	$ gem install laboristo

### Using Bundler?

Add this line to your application's Gemfile:

```ruby
gem 'laboristo'
```

And then execute:

    $ bundle


## Configuration

Before using Laboristo, you will need to set some environment variables:

	AWS_ACCESS_KEY_ID=<your_aws_access_key>
	AWS_SECRET_ACCESS_KEY=<your_aws_secret_key>

Please, refer to [AWS documentation](%28http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html%29) to obtain the corresponding values for your account.

## Considerations

First of all, if you are not familiar with AWS SQS I hardly recommend that you begin reading the [AWS SQS Getting Started Guide](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/Welcome.html).

Here are some considerations that you need to know when using Laboristo and SQS:

 - Laboristo does not create queues. You will have to set them up before sending messages to it (pretty obvious, right?). For instance, you can use [AWS Console](http://console.aws.amazon.com/) to create quehes.
 - When creating queues, you can set up queue attributes such as *DelaySeconds*, *MaximumMessageSize*, *MessageRetentionPeriod*, *Policy*, *ReceiveMessageWaitTimeSeconds* and *VisibilityTimeout*. Tune this settings according to your needs to efficiently use the service, and keep usage costs at a minimum level.
 - Laboristo retrieves the message, yields the process to your code, and then deletes the message from the queue. If something fails in between, the message will go back to the queue. I encourage you to consider using [Dead Letter Queues](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/SQSDeadLetterQueue.html) to prevent eternal processing of invalid/wrong messages.

## Usage

To refer to a particular queue, you will need the corresponding queue url, an attribute defined by AWS SQS when you create a queue. You can check the queue url in the AWS SQS Console. In the following examples, we will assume a queue having an url like this:

```
  https://sqs.us-east-1.amazonaws.com/123456789/my_queue
```

To push a message to the queue:

```ruby
require 'laboristo'

Laboristo['https://sqs.us-east-1.amazonaws.com/123456789/my_queue'] << 'some message'
```

And get messages from a queue:
```ruby
require 'laboristo'
Laboristo['https://sqs.us-east-1.amazonaws.com/123456789/my_queue'].each do |msg|
  # Do something with msg...
end
```

### Workers

Workers can be as simple as this:

```ruby
  require 'my_app'

  Laboristo['https://sqs.us-east-1.amazonaws.com/123456789/my_queue'].each do |message|
    # Do some magic stuff with the message
  end
```

For instance, you can place your worker at ```./workers/my_worker.rb``` and run this code to run worker in foreground:

```
  $ laboristo workers/my_worker
```

To run it in background you can use ```-d``` flag to daemonize the process:

```
  $ laboristo workers/my_worker -d
```

And, to stop a worker running in background, you can confidently kill the process:

```
  $ kill $$(cat /tmp/my_worker.pid)
```

Keep in mind that, because of how SQS works, unprocessed messages will go back to the queue. So, if you kill the worker process, unprocessed messages will go back to queue.

### Purging

Delete all messages from a queue:

```ruby
  Laboristo['https://sqs.us-east-1.amazonaws.com/123456789/my_queue'].purge
```

Because of AWS SQS restrictions, you can purge a queue only once every 60 seconds.

## Development

After cloning repository install dependencies using [dep](https://github.com/cyx/dep):

```
  $ dep install
```

Set environment variables as explained before in this document, and run the tests:

```
  $ make
```

### TO-DO:

First of all, help me adding more tests! This gem stated as an experiment, so you can expect bugs.

Feel free to report bugs, open issues, comments and pull requests. Only keep in mind that I just want to keep this gem neat and simple.

## Credits

Most of the credit for this gem goes to [@soveran](https://github.com/soveran/ost) and [@djanowski](https://github.com/djanowski/ost-bin), who created the code this gem is based on. Kudos to them!

## License
Laboristo is released under the [MIT License](http://www.opensource.org/licenses/MIT).
