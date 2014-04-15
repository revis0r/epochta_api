module EPochtaService
	class EPochtaSMS < EPochtaBase
		URL = 'http://atompark.com/api/sms/3.0/'

		def create_address_book(params)
			params['action'] = 'addAddressbook'
			
			result = exec_command(params)
			result = JSON.parse(result.body)

			if result.has_key? 'error'			
				false
			else
				result['result']['addressbook_id']
			end
		end

		def check_campaign_price(params)
			params['action'] = 'checkCampaignPrice'
			
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
			params['currency'] = 'RUB'
			result = exec_command(params)
			result = JSON.parse(result.body)

			if result.has_key? 'error'			
				false
			else
				result['result']['balance_currency']
			end
		end

		def delete_address_book(params)
			params['action'] = 'delAddressbook'
			result = exec_command(params)
			result = JSON.parse(result.body)		
			if result.has_key? 'error'			
				false
			else
				true
			end		
		end

		def add_phones(params)
			params['action'] = 'addPhoneToAddressBook'
			result = exec_command(params)
			result = JSON.parse(result.body)		
			if result.has_key? 'error'			
				false
			else
				true
			end	
		end

		def send_sms(params)		
			params['action'] 	 = 'sendSMS'
			result = exec_command(params)
			result = JSON.parse(result.body)

			if result.has_key? 'error'			
				false
			else
				result['result']['id']
			end
		end

		def create_campaign(params)
			params['action'] 	 = 'createCampaign'
			result = exec_command(params)
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
			result = exec_command(params)
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
					
			response = exec_command(params)
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

		def format_delivery_status_hash(response)
			result = {}
			response['phone'].each_with_index do |client, index|
				result[client] = {status: response['status'][index], delivery_date: response['donedate'][index] }			
			end
			result
		end
	end
end