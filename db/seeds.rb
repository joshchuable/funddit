# coding: utf-8

puts 'Seeding the database...'

[
  { en: 'Art' },
  { en: 'Business' },
  { en: 'Community' },
  { en: 'Education' },
  { en: 'Events' },
  { en: 'Fundraiser' },
  { en: 'Independent Research' },
  { en: 'Music' },
  { en: 'Organizations' },
  { en: 'Party' },
  { en: 'Other' },




].each do |name|
   category = Category.find_or_initialize_by(name_pt: name[:pt])
   category.update_attributes({
     name_en: name[:en]
   })
 end

{
  company_name: 'Funddit',
  company_logo: '',
  host: 'funddit.me',
  base_url: "http://funddit.me",
  email_contact: 'info@funddit.me',
  email_payments: 'info@funddit.me',
  email_projects: 'info@funddit.me',
  email_system: 'info@funddit.me',
  email_no_reply: 'info@funddit.me',
  facebook_url: "http://facebook.com/funddit.me",
  facebook_app_id: '302938209911869',
  twitter_url: 'http://twitter.com/funddit',
  twitter_username: "funddit",
  mailchimp_url: "http://eepurl.com/54tWP",
  mailchimp_url_popup: "http://eepurl.com/bakOYb",
  catarse_fee: '0.04',
  support_forum: 'http://support.funddit.me/',
  base_domain: 'http://funddit.me',
  uservoice_secret_gadget: 'change_this',
  uservoice_key: 'uservoice_key',
  sendgrid_user_name: 'funddit',
  sendgrid: 'Entre2014',
  faq_url: 'http://support.funddit.me/',
  feedback_url: 'MAILTO:info@funddit.me',
  terms_url: '',
  privacy_url: '',
  about_channel_url: '',
  instagram_url: '',
  blog_url: "",
  github_url: '',
  contato_url: ''
}.each do |name, value|
   conf = CatarseSettings.find_or_initialize_by(name: name)
   conf.update_attributes({
     value: value
   }) if conf.new_record?
end


Channel.find_or_create_by!(name: "Channel name") do |c|
  c.permalink = "sample-permalink"
  c.description = "Lorem Ipsum"
end

Project.find_or_create_by!(name: "Test") do |p|
    p.name = 'Test'
    p.user_id = 1
    p.category_id = 1
    p.about = 'test'
    p.headline = 'test'
    p.goal = 100
    p.online_days = 14
    p.permalink = 'test'
end


OauthProvider.find_or_create_by!(name: 'facebook') do |o|
  o.key = 302938209911869
  o.secret = ca01ab4e160f9e3f38f822dc1ed33f91
  o.path = 'facebook'
end

puts
puts '============================================='
puts ' Showing all Authentication Providers'
puts '---------------------------------------------'

OauthProvider.all.each do |conf|
  a = conf.attributes
  puts "  name #{a['name']}"
  puts "     key: #{a['key']}"
  puts "     secret: #{a['secret']}"
  puts "     path: #{a['path']}"
  puts
end


puts
puts '============================================='
puts ' Showing all entries in Configuration Table...'
puts '---------------------------------------------'

CatarseSettings.all.each do |conf|
  a = conf.attributes
  puts "  #{a['name']}: #{a['value']}"
end

Rails.cache.clear

puts '---------------------------------------------'
puts 'Done!'
