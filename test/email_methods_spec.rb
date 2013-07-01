# coding: utf-8
require 'e_pochta'
require 'rspec'


describe EPochtaEmail do	

	subject { EPochtaEmail.new(:public_key => 'd6029849011e7f86a97792d6e46be1a6', :private_key => '8e564896226d0e02d077cd1f671d6180') }

	describe 'Address book method' do	
		before(:all) do
			@addr_book_id = subject.addAddressbook({'name' => "My adress book #{Random.rand 1000}"})['addressbook_id']
		end

		context 'addAddressbook' do
			it 'return value shoud be an ID of sended message' do			
				@addr_book_id.class.should be(Fixnum)
			end	
		end

		context 'addAddresses' do
			it 'return value should be 1' do				
				subject.addAddresses('id_list' => @addr_book_id, 'email[]' => ['zxc@zxc.ru', 'asd@asd.ru']).should be_equal(1)				
			end
		end

		context 'getAddressbook' do
			it 'return value should contain id number' do
				subject.getAddressbook('id' => @addr_book_id)['id'].should be_equal(@addr_book_id)
			end
		end

		# context 'activateEmails' do
		# 	it 'return value should contain count of numbers, set for activation' do
		# 		sleep(5)
		# 		subject.activateEmails('id' => @addr_book_id, 'description' => 'sdaad').has_key?('activation_request_qty').should be true
		# 	end
		# end

		context 'delEmail' do
			it 'return value should be 1' do				
				subject.delEmail('id' => @addr_book_id, 'email' => 'zxc@zxc.ru').should be_equal(1)
			end
		end

		after(:all) do
			subject.delAddressbook :id => @addr_book_id
		end	
	end

	describe 'Campaign method' do
		before(:all) do
			@addr_book_id = subject.addAddressbook({'name' => "My adress book #{Random.rand 1000}"})['addressbook_id']			
			subject.addAddresses('id_list' => @addr_book_id, 'email[]' => ['timurt1988@gmail.com', 'noodledoomer@rambler.ru'])
			sleep(6)
			subject.activateEmails('id' => @addr_book_id, 'description' => 'Моя почта для теста')			
			sleep(6)
		end

		context 'createCampaign' do
			it 'return value should contain id of created campaign' do
				
				campaign = subject.createCampaign({
					'name' => 'test campaign',
					'sender_name' => 'Тимур',
					'sender_email' => 'rouge1988@yandex.ru',
					'subject' => 'test email',
					'body' => Base64.encode64("<h2>test</h2> <p>my mail</p>"),
					'list_id' => @addr_book_id			
					})				
				campaign['id'].class.should be(Fixnum)
			end
		end

		context 'getCampaignStats' do
			it 'return value should have key "statistics"' do
				subject.getCampaignStats('id' => 20320).has_key?('statistics').should be true
			end
		end
	end

	describe 'getUserBalance method' do
		it 'should return balance_currency value' do
			subject.getUserBalance({'currency' => 'RUB'}).has_key?('balance_currency').should	be true
		end
	end

end
