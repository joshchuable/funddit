# Load the rails application
require File.expand_path('../application', __FILE__)

ActiveMerchant::Billing::PaypalExpressGateway.default_currency = 'USD'

# Initialize the rails application
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
Catarse::Application.initialize!

