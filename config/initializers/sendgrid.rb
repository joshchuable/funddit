begin
    ActionMailer::Base.smtp_settings = {
      address: 'smtp.sendgrid.net',
      port: '587',
      authentication: :plain,
      user_name: CatarseSettings.get_without_cache(:sendgrid_user_name),
      password: CatarseSettings.get_without_cache(:sendgrid),
      domain: 'funddit.me'
    }
    ActionMailer::Base.delivery_method = :smtp
  end
rescue
  nil
end
