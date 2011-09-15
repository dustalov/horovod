# encoding: utf-8

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => 'smtp.fizteh.org',
  :port => 25,
  :user_name => 'info@fizteh.org',
  :password => "rfcj',kznm",
  :authentication => :plain,
  :enable_starttls_auto => false
}
