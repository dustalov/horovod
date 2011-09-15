# encoding: utf-8

if Rails.env.production?
  Horovod::Application.config.middleware.use ExceptionNotifier,
    :email_prefix => '[Horovod] ',
    :sender_address => %{"Exception Notifier" <info@fizteh.org>},
    :exception_recipients => %w{}
end
