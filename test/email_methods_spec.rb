# coding: utf-8
require './e_pochta.rb'
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

		context 'activateEmails' do
			it 'return value should contain count of numbers, set for activation' do
				sleep(5)
				subject.activateEmails('id' => @addr_book_id, 'description' => 'sdaad').has_key?('activation_request_qty').should be true
			end
		end

		after(:all) do
			subject.delAddressbook :id => @addr_book_id
		end	
	end

	describe '.create_campaign' do
		before do
			
		end
		context 'return value' do
			it 'should be an ID of created sms Campaign'
		end
	end

end
