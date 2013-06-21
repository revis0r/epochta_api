# coding: utf-8
require './e_pochta.rb'
require 'rspec'

describe EPochtaSMS do	

	subject { EPochtaSMS.new(:public_key => '42e461a8affce1cff775b3a603941e8e', :private_key => '89bbb6dab9bed6758aaf137560440e9f') }

	it 'must have constant api url' do
		EPochtaSMS::URL.should_not be_nil
	end

	context 'on creation' do
		it 'should have public and private api key ' do			
			[subject.public_key, subject.private_key].each {|val| val.should_not be_nil}
		end

		it 'should take options hash ' do
			expect { EPochtaSMS.new([1,2,3]) }.to raise_error(ArgumentError)
		end
	end

	describe '.calculate_md5' do
		it 'should return a string' do
			params = {b: '123', a: 1, c: 256}
			result = subject.calculate_md5 params
			expect(result.class).to eq(String)
		end

		it 'should return md5 string (32 chars), generated from argument' do
			params = {b: '123', a: 1, c: 256}
			result = subject.calculate_md5 params
			result.length.should == 32
		end
	end

	describe '.exec_command' do
		
		context 'responce value' do
			before(:each) do
				@addr_book_request = {'name' => "test adress book #{Random.rand 1000}", 'description' => 'test book'}
				@request_result = subject.exec_command(@addr_book_request, 'addAddressbook')			
			end

			it 'should have 200 status: OK' do				
				expect(@request_result.class).to eq(Net::HTTPOK)
			end			
		end
	end

	describe '.form_request' do
		context 'return value' do
			before(:each) do
				@addr_book_request = {'name' => "test adress book #{Random.rand 1000}", 'description' => 'test book'}
				@query_string = subject.form_request(@addr_book_request, 'addAddressbook')
			end

			it 'should be a URI object' do
				@query_string.class.should be URI::HTTP
			end

			it 'should not be empty' do						
				@query_string.to_s.should_not == ''
			end
		
			it 'must contain "sum" key' do
				@query_string.to_s.should =~ /sum/
			end

			it 'must contain "key" key' do
				@query_string.to_s.should =~ /key/
			end
		end
	end

	describe '.create_address_book' do
		before(:each) do
			@good_params = {'name' => "test adress book", 'description' => 'test book'}			
		end

		context 'return value' do
			it 'should be ID of created address book' do			
				id = subject.create_address_book(@good_params)			
				expect(id.class).to eq(Fixnum)
			end

			it 'should not be false' do	
				id = subject.create_address_book(@good_params)					
				expect(id).not_to eq(false)
			end			
		end
	end

	describe '.delete_address_book' do
		before(:each) do
			address_book_id	= subject.create_address_book({'name' => "test delete book"})
			@good_params = { 'idAddressBook' => address_book_id }
			@bad_params  = { 'idAddressBook' => 123454568 }			
		end

		context 'return value' do
			it 'should be true' do
				subject.delete_address_book(@good_params).should be(true)
			end
			it 'should be false with bad params' do
				subject.delete_address_book(@bad_params).should be(false)
			end
		end
	end

	describe '.add_phones' do
		before do 
			@address_book_id = subject.create_address_book({'name' => "with users"})
		end

		context 'return value' do
			before do			
				@good_params = { 
					'idAddressBook' => @address_book_id, 
					'data' => [["89085085077", "Тимур Русланович"], ['89518408051', 'Кристина'] ].to_json }
				@bad_params  = {
					'idAddressBook' => 1251255, 
					'data' => [["89085085077", "Тимур Русланович"], ['89518408051', 'Кристина'] ].to_json }	
			end

			it 'should be true' do
				subject.add_phones(@good_params).should be(true)
			end

			it 'should be false with bad params' do
				subject.add_phones(@bad_params).should be(false)
			end
		end
	end

	describe '.get_balance' do
		context 'return value' do
			it 'should be a number, which represent current account balance' do
				balance = subject.get_balance()
				puts balance
				expect(balance.class).to be(Float)
			end
		end
	end

end
