require 'net/http'
require 'digest/md5'
require 'json'
require 'base64'

require './lib/e_pochta_base.rb'
require './lib/e_pochta_sms.rb'
require './lib/e_pochta_email.rb'

include EPochtaService

