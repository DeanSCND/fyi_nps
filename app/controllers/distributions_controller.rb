#require 'action_mailer'
#require 'ntlm/smtp'

class DistributionsController < ApplicationController
	def new
		if params[:run_id] != nil
			run = Run.find(params[:run_id])
			email_body = "Attached is your latest Net Promoter Score reports.  If you have any questions, comments or concerns please feel free to contact your regional coach. They should be able to provide insights and answers to questions related to the surveys and results.<BR><BR>Thanks<BR><BR>The NPS Team<BR>"
			i = 0
			Distribution.all.each do |distro|
				logger.debug("DISTRO: " + distro.id.to_s)

				
				email_str = ""
				DistributionContacts.where(:distribution_id=>distro.id).each do |dcontact|
					con = FyiContact.find(dcontact.fyi_contact_id)
					email_str = email_str + con.email + ","
				end
				logger.debug(email_str)

				clinic_report_str = ""
				clinic_report_path = "/Users/Dean/Work/FYi/Net Promoter Score/reports/" + run.name + "/clinics/"
				DistributionClinic.where(:distribution_id=>distro.id).each do |clinic|
					clinic_report_str += clinic_report_path + "report_" + clinic.practice_id.to_s + ".pdf,"
					clinic_report_str += clinic_report_path + "report_" + clinic.practice_id.to_s + "_with_emails.pdf,"
				end
				logger.debug(clinic_report_str)

				group_report_path = "/Users/Dean/Work/FYi/Net Promoter Score/reports/" + run.name + "/groups/"
				DistributionPracticeGroup.where(:distribution_id=>distro.id).each do |group|
					clinic_report_str += group_report_path + "report_" + group.practice_group_id.to_s + ".pdf,"
					clinic_report_str += group_report_path + "report_" + group.practice_group_id.to_s + "_with_emails.pdf,"
				end
				logger.debug(clinic_report_str)


				script = 'osascript "/Users/Dean/Work/FYi/Net Promoter Score/Distribution Scripts/testscript.scpt" "Latest Net Promoter Score Report" "' + email_body + '" ' + email_str[0..-2] + ' "' + clinic_report_str[0..-2] + '"'
				logger.debug(script)
				system(script)

				#resp = ReportMailer.new_report_email
				#logger.debug(resp.to_s)

				#ActionMailer::Base.delivery_method = :smtp

				#ActionMailer::Base.smtp_settings = {
				#    :address => "webmail.fyidoctors.com",
				#    :port => 25,
				#    :authentication => :ntlm,
				#    :user_name => 'FYIDoctors\dskelton',
				#    :password => 'dali2662?!',
				#    :enable_starttls_auto => false
				#}

				#ActionMailer::Base.raise_delivery_errors = true
				#ActionMailer::Base.perform_deliveries = true
				#ActionMailer::Base.default :from => 'from_email@my_company.com'

				#m = ActionMailer::Base.mail :to => 'dean.skelton@fyidoctors.com', :subject => 'this is a test', :body => 'this is a test'
				#m.deliver

				#break
			end
		end
	end
end