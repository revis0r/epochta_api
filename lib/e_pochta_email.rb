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
				STDERR.puts result.inspect
				if result.has_key? 'error'							
					false
				else					
					result['result'] || result
				end
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