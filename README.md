#e_pochta
This is an API wrapper for online SMS and Email service [E-pochta](http://www.epochta.ru/) and it's API v3.0.
You can read about this API [here (russian)] (http://www.epochta.ru/products/sms/v3.php)

##Usage

```ruby
# provide your user keys
epochta = EPochtaService::EPochtaSMS.new(:private_key => 'your_private_key', :public_key => 'your_public_key')
# send sms
result = epochta.send_sms({
		# read the api to provide correct arguments
		'sender' => 'Name',
		'text'	 => 'Hello World!',
		'phone'	 => '71234567890',
		'datetime' => '',
		'sms_lifetime' => 0
	})

puts result # sms_id on epochta server 
```

##Email
From version 0.5.0 gem has new class for EPochta email campaigns.
```ruby
# provide your user keys
epochta = EPochtaService::EPochtaEmail.new(:private_key => 'your_private_key', :public_key => 'your_public_key')
# create email campaign
campaign = epochta.createCampaign({
	# read the api to provide correct arguments
	'name' => 'test campaign',
	'sender_name' => 'Vasya',
	'sender_email' => 'example@yandex.ru',
	'subject' => 'test email',
	'body' => Base64.encode64("<h2>test</h2> <p>my mail</p>"),
	'list_id' => @addr_book_id			
	})				

puts campaign['id'] # created campaign id on epochta server
```

You can also install it as a gem.

```
gem install e_pochta
```