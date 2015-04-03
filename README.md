# Laboristo

[![Gem Version](https://badge.fury.io/rb/laboristo.svg)][gem]
[![Dependency Status](https://gemnasium.com/matiasow/laboristo.svg)][gemnasium]
[![Code Climate](https://codeclimate.com/github/matiasow/laboristo/badges/gpa.svg)][codeclimate]
[![Build Status](https://travis-ci.org/matiasow/laboristo.svg?branch=master)][travis]
[![Test Coverage](https://codeclimate.com/github/matiasow/laboristo/badges/coverage.svg)][codeclimate]

[gem]: http://badge.fury.io/rb/laboristo
[gemnasium]: https://gemnasium.com/matiasow/laboristo
[codeclimate]: https://codeclimate.com/github/matiasow/laboristo
[travis]: https://travis-ci.org/matiasow/laboristo

Laboristo is an attempt to port [Ost](https://github.com/soveran/ost) simplicity to AWS SQS.

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

	AWS_REGION=<your_aws_region>
	AWS_ACCOUNT_ID=<your_aws_account_id>
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

To push a message to the queue:

```ruby
require 'laboristo'

Laboristo['my_queue_name'] << 'some message'
```

And get messages from a queue:
```ruby
require 'laboristo'
Laboristo['my_queue_name'].each do |msg|
  # Do something with msg...
end
```

### Workers

Workers can be as simple as this:

```ruby
  require 'my_app'

  Laboristo['my_queue'].each do |message|
    # Do some magic stuff with the message
  end
```

Place worker at ```./workers/my_worker.rb``` and run this code to run worker in foreground:

```
  $ laboristo my_worker
```

To run it in background you can use ```-d``` flag to daemonize the process:

```
  $ laboristo my_worker -d
```

You can stop the workers by killing the process. Keep in mind that, because of how SQS works, unprocessed messages will go back to the queue.

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

First of all, add more tests! This gem stated as an experiment, so you can expect bugs.

In future versions, I'd like to improve the worker bin so that it can be started/stopped in a more elegant fashion than simply killing the process ;-)

Feel free to report bugs, open issues, comments and pull requests. Only keep in mind that I just want to keep this gem neat and simple.

## Credits

Most of the credit for this gem goes to [@soveran](https://github.com/soveran/ost) and [@djanowski](https://github.com/djanowski/ost-bin), who created the code this gem is based in. Kudos to them!

## License
Laboristo is released under the [MIT License](http://www.opensource.org/licenses/MIT).
