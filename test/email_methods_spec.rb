# coding: utf-8
require './e_pochta.rb'
require 'rspec'


describe EPochtaEmail do	

	subject { EPochtaEmail.new(:public_key => 'd6029849011e7f86a97792d6e46be1a6', :private_key => '8e564896226d0e02d077cd1f671d6180') }

	describe '.create_address_book' do		
		it 'return value shoud be an ID of sended message' do
			@addr_book_id = subject.create_address_book({'name' => "My adress book #{Random.rand 1000}"})
			@addr_book_id.class.should be(Fixnum)
		end	

		after do
			STDERR.puts @addr_book_id.inspect
		end	
	end

	describe '.add_to_address_book' do
		before do
			
		end
		context 'return value' do
			it 'should be an ID of created sms Campaign'
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
