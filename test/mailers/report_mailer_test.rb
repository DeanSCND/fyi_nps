require 'test_helper'

class ReportMailerTest < ActionMailer::TestCase
  test "new_report_email" do
    mail = ReportMailer.new_report_email
    assert_equal "New report email", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
