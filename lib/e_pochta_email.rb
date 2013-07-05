module EPochtaService
	class EPochtaEmail < EPochtaBase
		URL = 'http://atompark.com/api/email/3.0/'

		[
			:addAddressbook, :delAddressbook, :addAddresses,
			:getAddressbook, :activateEmails, :createCampaign,
			:delEmail, :getUserBalance, :getCampaignStats			
		].each do |method|
			define_method(method) do |params|
				params['action'] = method.to_s	
				result = exec_command(params)
				STDERR.puts result.body
				result = JSON.parse(result.body)
				
				if result.has_key? 'error'							
					false
				else					
					result['result'] || result
				end
			end
		end

		def getCampaignDeliveryStats(params)
			params['action'] = 'getCampaignDeliveryStats'	
			result = exec_command(params)
			
			result = JSON.parse(result.body)
			
			if result.has_key? 'error'							
				false
			else					
				fetch_statuses result['result']
			end		
		end	

		private

		def fetch_statuses(raw_statuses)
			#raw status is an array ['email@example.com', 1, #DateTime#]
			statuses = {}
			raw_statuses.each {|status_array| statuses[status_array[0]] = status_array[1] }
			return statuses			
		end	
	end
end