module EPochtaService	
	
	class EPochtaBase
		attr_accessor :public_key, :private_key, :parameters
		
		# options hash: public_key, private_key
		def initialize(options)
			if options.is_a? Hash
				self.public_key  = options[:public_key]
				self.private_key = options[:private_key]
			else
				raise ArgumentError, "expected Hash argument, got #{options.class}"
			end
		end

		def calculate_md5(params)
			result = ''
			params['key'] = self.public_key					
			#stringify_keys
			stringified_params = {}
			params.each {|key, value| stringified_params[key.to_s] = value.to_s}
			#sort & concatenate all values    
			stringified_params.sort.each { |value| result = result + value[1] }				
			result = result + self.private_key
			Digest::MD5.hexdigest( result )
		end

		def form_request(params, action)		
			params['sum'] = calculate_md5 params
			self.parameters = params.each {|k,v| v = URI.escape v.to_s }
			
			url = URI("#{self.class::URL}#{action}")
			url.query = URI.encode_www_form params			
			url
		end

		def exec_command(params, action)
			uri = form_request(params, action)		
			result = Net::HTTP.post_form(uri, self.parameters)
		end
	end		
end