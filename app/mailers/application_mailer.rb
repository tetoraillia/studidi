class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_FROM_EMAIL", "Studidi App <no-reply@studidi.com>")
  layout "mailer"
end
