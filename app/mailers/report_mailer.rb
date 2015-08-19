class ReportMailer < ActionMailer::Base
  default from: "dean.skelton@fyidoctors.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.report_mailer.new_report_email.subject
  #
  def new_report_email
    @greeting = "Hi"

    mail to: "dean.skelton@gmail.com", subject: "Test Message"
  end
end
