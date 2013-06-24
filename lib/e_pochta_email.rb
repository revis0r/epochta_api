module EPochtaService
	class EPochtaEmail < EPochtaBase
		URL = 'http://atompark.com/api/email/3.0/'

		[
			:addAddressbook, :delAddressbook, :addAddresses,
			:getAddressbook, :activateEmails
		].each do |method|
			define_method(method) do |params|
				params['action'] = method.to_s	
				result = exec_command(params)
				result = JSON.parse(result.body)
				STDERR.puts result.inspect
				if result.has_key? 'error'							
					false
				else
					result['result']
				end
			end
		end

		def create_address_book(params)			
			params['action'] 	 = 'addAddressbook'				
			result = exec_command(params)
			result = JSON.parse(result.body)

			if result.has_key? 'error'							
				false
			else
				result['result']['addressbook_id']
			end
		end

		def delete_address_book(params)
			params['action'] 	 = 'delAddressbook'						
			result = exec_command(params)
			result = JSON.parse(result.body)

			if result.has_key? 'error'							
				false
			else
				result['result']
			end
		end

		def get_balance()
			params = {}
			params['action'] 	 = 'getUserBalance'
			params['version']  = '3.0'
			params['currency'] = 'RUB'
			result = exec_command(params, 'getUserBalance')
			result = JSON.parse(result.body)

			if result.has_key? 'error'			
				false
			else
				result['result']['balance_currency']
			end
		end

		def delete_address_book(params)
			params['action'] = 'delAddressbook'
			params['version'] = '3.0'
			result = exec_command(params, 'delAddressbook')
			result = JSON.parse(result.body)		
			if result.has_key? 'error'			
				false
			else
				true
			end		
		end

		def add_phones(params)
			params['action'] = 'addPhoneToAddressBook'
			params['version'] = '3.0'
			result = exec_command(params, 'addPhoneToAddressBook')
			result = JSON.parse(result.body)		
			if result.has_key? 'error'			
				false
			else
				true
			end	
		end

		def send_sms(params)		
			params['action'] 	 = 'sendSMS'
			params['version']  = '3.0'		
			result = exec_command(params, 'sendSMS')
			result = JSON.parse(result.body)

			if result.has_key? 'error'			
				false
			else
				result['result']['id']
			end
		end

		def create_campaign(params)
			params['action'] 	 = 'createCampaign'
			params['version']  = '3.0'		
			result = exec_command(params, 'createCampaign')
			result = JSON.parse(result.body)

			if result.has_key? 'error'			
				false
			else
				result['result']['id']
			end
		end

		# params = {'id' => 12345} campaign_id
		def get_campaign_status(params)
			params['action'] 	 = 'getCampaignInfo'
			params['version']  = '3.0'		
			result = exec_command(params, 'getCampaignInfo')
			result = JSON.parse(result.body)

			if result.has_key? 'error'			
				false
			else
				result['result']['status_text'] = get_status_text(result['result']['status'].to_i)
				result['result']
			end
		end

		# params = {'id' => 12345} campaign_id
		def campaign_delivery_statuses(params)
			params['action'] 	 = 'getCampaignDeliveryStats'
			params['version']  = '3.0'		
			response = exec_command(params, 'getCampaignDeliveryStats')
			response = JSON.parse(response.body)

			if response.has_key? 'error'			
				false
			else
				# makes "phone->status" structure from returned response
				format_delivery_status_hash(response['result'])
			end
			
		end

		private
		# helpers
		def get_status_text(code)
			status_text = case code
				when 0 then 'epochta_pending'
				when 1 then 'not_enought_money'
				when 2 then 'in_process'
				when 3 then 'done'
				when 4 then 'wrong_numbers'
				when 5 then 'partialy_done'
				when 6 then 'spam'
				when 7 then 'wrong_sender_name'
				when 8 then 'paused'
				when 9 then 'planned'
				when 10 then 'on_moderation'
			end		
		end

		
	end
end