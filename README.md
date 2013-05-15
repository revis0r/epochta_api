#e_pochta
This is an API wrapper for online SMS-service [E-pochta](http://www.epochta.ru/) and it's API v3.0.
You can read about this API [here (russian)] (http://www.epochta.ru/products/sms/v3.php)

##Usage

```ruby
# provide your user keys
epochta = EPochta.new(:private_key => 'your_private_key', :public_key => 'your_public_key')
# send sms
result = epochta.send_sms({
		'sender' => 'Name',
		'text'	 => 'Hello World!',
		'phone'	 => '71234567890',
		'datetime' => '',
		'sms_lifetime' => 0
	})
puts result # sms_id on epochta server 

```

You can also install it as a gem.

```
gem install e_pochta
```