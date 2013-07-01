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
				result = JSON.parse(result.body)
				
				if result.has_key? 'error'							
					false
				else					
					result['result'] || result
				end
			end
		end		
	end
end