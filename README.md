# Smslane

A simple wrapper gem for the smslane.com HTTP API for sending Bulk SMS in India.

## Installation

Add this line to your application's Gemfile:

    gem 'smslane'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install smslane

## Usage

Create an instance of `Smslane::Client` and pass your smslane.com `username` and `password` as arguments like below:

    client = Smslane::Client.new('username','password')
    
Now using this client you can check your credit balance, send SMS and check delivery reports.

### Checking Credit Balance

To check your balance credits simple call the `check_balance` method on the client:

    client.check_balance
    # => {:result => 'Success', :response => '2000'}
    # or
    # => {:result => 'Failure', :response => 'Invalid Login'}
    # or
    # => {:result => 'Failure', :response => 'Unauthorized Access'}
    # etc

### Sending SMS

SMS is sent using the client through the `send_sms` method. This method requires three arguments: 
  * An array of recipient numbers
  * The message to be sent
  * A boolean indicating whether or not to send the SMS as a flash message
 
Numbers must be of the format `919841254836`.Prefixing with `91` is crucial. But there are mechanisms in the gem that will take care of some malformed numbers.
Recipient numbers are split into groups of 90 numbers and are sent seprately to comply with smslane.com's limits. Malformed numbers will cause the entire group in which they are to fail. So it is crucial that numbers are of the specified format.

The response of this call is an array of hashes. Each hash contains the recipient number and the `message_id` returned by smslane.com. This `message_id` is used to check delivery reports.

    client.send_sms ['919234567888','919999999999'], 'Testing :)', false
    #=> [{:number => '919234567888', :message_id => '677a468d46f342e66e69ddbe5a963d7d'},
         {:number => '919999999999', :message_id => '4c52312229df5fbc82cd07ea29ca4d91'}]

If a number is not present in this response list it indicates that the number is invalid. 

### Delivery Report

To Do.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request