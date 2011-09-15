# encoding: utf-8

source 'http://rubygems.org'

gem 'rails', '~> 3.0.0'

gem 'capistrano'

gem 'devise'

gem 'rails-i18n'
gem 'right-rails'
gem 'paperclip'
gem 'will_paginate', :git => 'git://github.com/mislav/will_paginate.git',
  :branch => 'rails3'
gem 'dynamic_form'
gem 'cells'

gem 'json'
gem 'ohembedr'

gem 'exception_notification', :require => 'exception_notifier',
  :git => 'git://github.com/rails/exception_notification.git'

group :development do
  gem 'sqlite3'
end

group :production do
  gem 'unicorn'
  gem 'pg'
  gem 'memcache-client', :require => 'memcache'
end
