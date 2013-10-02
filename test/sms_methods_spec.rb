# coding: utf-8
require 'e_pochta'
require 'rspec'


describe EPochtaSMS do	

	subject { EPochtaSMS.new(:public_key => '42e461a8affce1cff775b3a603941e8e', :private_key => '89bbb6dab9bed6758aaf137560440e9f') }

	describe '.send_sms' do
		before do
			@good_params = {
				'sender' => 'Dealer',
				'text'	 => 'YOUR TEXT',
				'phone'	 => '***PHONE NUMBER***',
				'datetime' => '',
				'sms_lifetime' => 0
			}
			@bad_params = {}
		end

		context 'return value' do
			it 'shoud be an ID of sended message' do
				subject.send_sms(@good_params).class.should be(Fixnum)
			end

			it 'should be false with bad params' do
				subject.send_sms(@bad_params).should be(false)
			end
		end
	end

	describe '.create_campaign' do
		before do
			@address_book_id = subject.create_address_book('name' => "campaign 2 test", 'description' => 'for campaign')
			subject.add_phones({ 
					'idAddressBook' => @address_book_id, 
					'data' => [["***PHONE NUMBER***", "TEST"] ].to_json 
				})

			@good_params = {
				'sender' => '12345',
				'list_id' => @address_book_id,
				'text'	=> '%1%, представляем Вам CRM Dealerpoint!',
				'datetime' => '',
				'batch' => 0,
				'batchinterval' => 0,
				'sms_lifetime' => 0,
				'controlphone' => ''
			}
		end
		context 'return value' do
			it 'should be an ID of created sms Campaign' do
				subject.create_campaign(@good_params).class.should be (Fixnum)
			end
		end
	end

end
