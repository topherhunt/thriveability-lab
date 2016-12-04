class ApplicationMailer < ActionMailer::Base
  helper :application
  default(from: ENV.fetch('SUPPORT_EMAIL'))
end
