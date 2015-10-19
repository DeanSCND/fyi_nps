class EmailsController < ApplicationController
  require 'fileutils'
  require 'mandrill'
  require 'base64'

  def index
      run = Run.find(params[:run_id])

      SurveyAnswer.select("DISTINCT(practice_id)").where(:run => run).each do |result|
        clinic = Clinic.where(:practice_id=>result.practice_id).first
        logger.debug("Sending report for : " + clinic.name + " :" + clinic.id.to_s)

      	reportFile1 = File.read("/Users/adrian/Documents/work/FYI/Net Promoter Score/reports/" + run.name + "/clinics/report_" + clinic.practice_id.to_s + ".pdf")
        reportFile2 = File.read("/Users/adrian/Documents/work/FYI/Net Promoter Score/reports/" + run.name + "/clinics/report_" + clinic.practice_id.to_s + "_with_emails.pdf")

  		m = Mandrill::API.new # All official Mandrill API clients will automatically pull your API key from the environment

		recipients = Array.new
		recipients[0] = {"email"=> "Dean.Skelton@fyidoctors.com", "type"=>"to"}
    #recipients[1] = {"email"=> "dean.skelton@gmail.com", "type"=>"cc"}
		
		message = {"html"=>"Test Email",
             "text"=>"NPS Report Attached\n\n",
             "subject"=>"Your New NPS Report",
             "from_email"=>"dean.skelton@fyidoctors.com",
             "from_name"=>"Dean Skelton",
             "to"=> recipients,
             "attachments"=> [{
             	"content"=> Base64.encode64(reportFile1),
             	"type"=>"application/pdf",
             	"name"=>"report_" + clinic.practice_id.to_s + ".pdf"
             },
             {
             	"content"=> Base64.encode64(reportFile2),
             	"type"=>"application/pdf",
             	"name"=>"report_" + clinic.practice_id.to_s + "_with_emails.pdf"
             }],
             "metadata"=>{"website"=>"www.fyidoctors.com"}}

            async = false
            ip_pool = "Main Pool"
            send_at = nil
            logger.debug(message.to_s)
        result = m.messages.send message, async, ip_pool, send_at
      	
      	break;
      end


  end

end