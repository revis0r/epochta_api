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
			params.each do |key, value|
				# This is hack for correct md5 summ calculating
				# when we have array value in param, we must concatenate with 'Array' string
				# instead of value of this array =\
				# because of PHP origin of EPochta engine:
				
				# this is PHP example of control summ calculating, which is correct

				# ksort($arrayRequest);
        #    $sum = '';
        #    foreach ($arrayRequest as $v)
        #       $sum .= $v; // if $v is Array then it evaluates to 'Array' string value

				if value.is_a?(Array) 
					stringified_params[key.to_s] = 'Array'
					next
				end
				# =========				
				stringified_params[key.to_s] = value.to_s
			end
			
			#sort & concatenate all values    
			stringified_params.sort.each {|value|	result = result + value[1] }
			result = result + self.private_key
			Digest::MD5.hexdigest( result )
		end

		def form_request(params)
			params['version']	= '3.0'
			params['sum'] = calculate_md5 params
			self.parameters = params.each {|k,v| v = URI.escape v.to_s }
			
			url = URI("#{self.class::URL}#{params['action']}")
			url.query = URI.encode_www_form params
			url
		end

		def exec_command(params)
			uri = form_request(params)		
			result = Net::HTTP.post_form(uri, self.parameters)
		end
	end		
end