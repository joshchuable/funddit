class CampaignFinisherWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform project_id
    resource = Project.find project_id
    Rails.logger.info "[FINISHING PROJECT #{resource.id}] #{resource.name}"
    resource.finish
    #if resource.state == "successful"
    checkout project_id
    #end
  end

  def checkout project_id
  	project = Project.find project_id
  	project.contributions.each do |contribution|
        #wepay = WePay.new(client_id, client_secret, use_stage)
        wepay ||= WePay.new(PaymentEngines.configuration[:wepay_client_id], PaymentEngines.configuration[:wepay_client_secret])
        response = wepay.call('/checkout/new', project.user.wepay_access_token, {
          :account_id         => project.user.wepay_account_id_string,
          :amount             => (contribution.price_in_cents/100).round(2).to_s,
          :short_description  => 'wepay_description',#t('wepay_description', scope: SCOPE, :project_name => contribution.project.name, :value => contribution.display_value),
          :type               => 'GOODS',
          :preapproval_id     => contribution.payment_token
          })
      end
  end
end
