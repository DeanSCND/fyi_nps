class ReportsController < ApplicationController
  require 'fileutils'
  require 'mandrill'
  require 'base64'

  def index
    if params[:run_id] != nil
      run = Run.find(params[:run_id])
      

      type = params[:type]

      logger.debug("Running report for Run: " + run.name + " :" + run.id.to_s)
 
      quarter_runs = []
      qRuns = Run.where("id > ?", 13).where("quarter <> ''")
      qRuns.each do |run|
        quarter_runs << run.id
      end

      logger.debug(quarter_runs)

      #fyiResults = PracticeReport.where(:practice_id=>0, :run_id=>run.id, :stat_type=>"rolling").first
      #SurveyAnswer.where(:status=>"Complete")
      #@fyiNps1 = (((fyiResults.all(:conditions => "n1>8").count.to_f / fyiResults.all(:conditions => "n1 >= 0").count.to_f) * 100) - ((fyiResults.all(:conditions => "n1<7").count.to_f / fyiResults.all(:conditions => "n1 >= 0").count.to_f) * 100)).round(2)
      #@fyiNps2 = (((fyiResults.all(:conditions => "n2>8").count.to_f / fyiResults.all(:conditions => "n2 >= 0").count.to_f) * 100) - ((fyiResults.all(:conditions => "n2<7").count.to_f / fyiResults.all(:conditions => "n2 >= 0").count.to_f) * 100)).round(2)
      #@fyiNps3 = (((fyiResults.all(:conditions => "n3>8").count.to_f / fyiResults.all(:conditions => "n3 >= 0").count.to_f) * 100) - ((fyiResults.all(:conditions => "n3<7").count.to_f / fyiResults.all(:conditions => "n3 >= 0").count.to_f) * 100)).round(2)
      
      fyi_per_stats = PracticeReport.where(run_id: run.id, practice_id: 0, stat_type: "rolling")
      @fyiNps1 = fyi_per_stats[0].n1*100
      @fyiNps2 = fyi_per_stats[0].n2*100
      @fyiNps3 = fyi_per_stats[0].n3*100

      #@fyiNps1 = (fyiResults.n1*100).round(2)
      #@fyiNps2 = (fyiResults.n2*100).round(2)
      #@fyiNps3 = (fyiResults.n3*100).round(2)
      #@fyiNpsAvg = ((@fyiNps1 + @fyiNps2 + @fyiNps3)/3)

      if type == 'clinics' || type == 'both'
        SurveyAnswer.select("DISTINCT(practice_id)").where(:run => run).each do |result|
          clinic = Clinic.where(:practice_id=>result.practice_id).first
          logger.debug("Generating report for : " + clinic.name + " :" + clinic.id.to_s)

          #my_html = '<html><head></head><body><p>Hello</p></body></html>'
          invites = Patient.where(:run_id=>run.id, :practice_id=>clinic.practice_id).count
          @results = SurveyAnswer.where(:run_id=>run.id, :practice_id => clinic.practice_id, :status=>"Complete")
          @tot_results = SurveyAnswer.where(:practice_id => clinic.practice_id, :status=>"Complete").where("run_id > ?", 13)

          #@nps1 = (((@results.all(:conditions => "n1>8").count.to_f / @results.all(:conditions => "n1 >= 0").count.to_f) * 100) - ((@results.all(:conditions => "n1<7").count.to_f / @results.all(:conditions => "n1 >= 0").count.to_f) * 100)).round(2)
          #@nps2 = (((@results.all(:conditions => "n2>8").count.to_f / @results.all(:conditions => "n2 >= 0").count.to_f) * 100) - ((@results.all(:conditions => "n2<7").count.to_f / @results.all(:conditions => "n2 >= 0").count.to_f) * 100)).round(2)
          #@nps3 = (((@results.all(:conditions => "n3>8").count.to_f / @results.all(:conditions => "n3 >= 0").count.to_f) * 100) - ((@results.all(:conditions => "n3<7").count.to_f / @results.all(:conditions => "n3 >= 0").count.to_f) * 100)).round(2)
          
          per_stats = PracticeReport.where(run_id: run.id, practice_id: clinic.practice_id, stat_type: "period")
          @nps1 = (per_stats[0].n1 * 100).round(2)
          @nps2 = (per_stats[0].n2 * 100).round(2)
          @nps3 = (per_stats[0].n3 * 100).round(2)
            
          #@year_nps1 = (((@tot_results.all(:conditions => "n1>8").count.to_f / @tot_results.all(:conditions => "n1 >= 0").count.to_f) * 100) - ((@tot_results.all(:conditions => "n1<7").count.to_f / @tot_results.all(:conditions => "n1 >= 0").count.to_f) * 100)).round(2)
          #@year_nps2 = (((@tot_results.all(:conditions => "n2>8").count.to_f / @tot_results.all(:conditions => "n2 >= 0").count.to_f) * 100) - ((@tot_results.all(:conditions => "n2<7").count.to_f / @tot_results.all(:conditions => "n2 >= 0").count.to_f) * 100)).round(2)
          #@year_nps3 = (((@tot_results.all(:conditions => "n3>8").count.to_f / @tot_results.all(:conditions => "n3 >= 0").count.to_f) * 100) - ((@tot_results.all(:conditions => "n3<7").count.to_f / @tot_results.all(:conditions => "n3 >= 0").count.to_f) * 100)).round(2)

          roll_stats = PracticeReport.where(run_id: run.id, practice_id: clinic.practice_id, stat_type: "rolling")
          @year_nps1 = (roll_stats[0].n1 * 100).round(2)
          @year_nps2 = (roll_stats[0].n2 * 100).round(2)
          @year_nps3 = (roll_stats[0].n3 * 100).round(2)

          last_year_exit = PracticeReport.where(run_id: 13, practice_id: clinic.practice_id, stat_type: "rolling").first

          if last_year_exit == nil
            last_year_exit = PracticeReport.new
            last_year_exit.n1 = 0
            last_year_exit.n2 = 0
            last_year_exit.n3 = 0
          end
          data = render_to_string( :partial => "reports/nps", :locals => {
            :clinic => clinic, 
            :results => @results,
            :tot_results=>@tot_results,
            :invites => invites, 
            :run=>run,
            :nps1=>@nps1,
            :nps2=>@nps2,
            :nps3=>@nps3,
            :export=>true,
            :fyiNps1=>@fyiNps1,
            :fyiNps2=>@fyiNps2,
            :fyiNps3=>@fyiNps3,
            :quarter_runs => quarter_runs,
            :lastYearNps=>[(last_year_exit.n1*100).round(2),(last_year_exit.n2*100).round(2),(last_year_exit.n3*100).round(2)],
            :reportType=>"clinic",
            :anonymous=>true, :year_nps1 => @year_nps1, :year_nps2 => @year_nps2, :year_nps3 => @year_nps3
          })
          
          data_emails = render_to_string( :partial => "reports/nps", :locals => {
            :clinic => clinic, 
            :results => @results,
            :tot_results=>@tot_results,
            :invites => invites, 
            :run=>run,
            :nps1=>@nps1,
            :nps2=>@nps2,
            :nps3=>@nps3,
            :export=>true,
            :fyiNps1=>@fyiNps1,
            :fyiNps2=>@fyiNps2,
            :fyiNps3=>@fyiNps3,
            :quarter_runs => quarter_runs,            
            :lastYearNps=>[(last_year_exit.n1*100).round(2),(last_year_exit.n2*100).round(2),(last_year_exit.n3*100).round(2)],
            :reportType=>"clinic",
            :anonymous=>false, :year_nps1 => @year_nps1, :year_nps2 => @year_nps2, :year_nps3 => @year_nps3
          })

          #:action => :show,  :id => result.practice_id.to_s, :run=>run )
          
          #reportFile = "/Users/dean/Documents/work/FYI/Net Promoter Score/reports/" + run.name + "/clinics/report_" + clinic.practice_id.to_s + ".doc"
          #File.open(reportFile, "w"){|f| f << data}

          FileUtils.mkdir_p("/Users/dean/Work/FYi/Net Promoter Score/reports/" + run.name + "/clinics/")
          reportFile1 = "/Users/dean/Work/FYi/Net Promoter Score/reports/" + run.name + "/clinics/report_" + clinic.practice_id.to_s + ".pdf"
          pdf1 = WickedPdf.new.pdf_from_string(data)
          #File.open(pdf, "w"){|f| f << data}
          save_path = reportFile1
          File.open(save_path, 'wb') do |file|
            file << pdf1
          end

          reportFile2 = "/Users/dean/Work/FYi/Net Promoter Score/reports/" + run.name + "/clinics/report_" + clinic.practice_id.to_s + "_with_emails.pdf"
          pdf2 = WickedPdf.new.pdf_from_string(data_emails)
          
          #File.open(pdf, "w"){|f| f << data}
          save_path = reportFile2
          File.open(save_path, 'wb') do |file|
            file << pdf2
          end
        
        end
      end

      if type == 'groups' || type == 'both'
        PracticeGroup.all.each do |group|
          #PracticeGroup.where(:id=>19).each do |group|
          logger.debug("Generating report for : " + group.name + " :" + group.id.to_s)

          invites = group.get_invites(run.id).count
          @results = group.get_answers(run.id)
          @tot_results = group.get_all_answers

          @nps1 = (((@results.all(:conditions => "n1>8").count.to_f / @results.all(:conditions => "n1 >= 0").count.to_f) * 100) - ((@results.all(:conditions => "n1<7").count.to_f / @results.all(:conditions => "n1 >= 0").count.to_f) * 100)).round(2)
          @nps2 = (((@results.all(:conditions => "n2>8").count.to_f / @results.all(:conditions => "n2 >= 0").count.to_f) * 100) - ((@results.all(:conditions => "n2<7").count.to_f / @results.all(:conditions => "n2 >= 0").count.to_f) * 100)).round(2)
          @nps3 = (((@results.all(:conditions => "n3>8").count.to_f / @results.all(:conditions => "n3 >= 0").count.to_f) * 100) - ((@results.all(:conditions => "n3<7").count.to_f / @results.all(:conditions => "n3 >= 0").count.to_f) * 100)).round(2)
          
          @year_nps1 = (((@tot_results.all(:conditions => "n1>8").count.to_f / @tot_results.all(:conditions => "n1 >= 0").count.to_f) * 100) - ((@tot_results.all(:conditions => "n1<7").count.to_f / @tot_results.all(:conditions => "n1 >= 0").count.to_f) * 100)).round(2)
          @year_nps2 = (((@tot_results.all(:conditions => "n2>8").count.to_f / @tot_results.all(:conditions => "n2 >= 0").count.to_f) * 100) - ((@tot_results.all(:conditions => "n2<7").count.to_f / @tot_results.all(:conditions => "n2 >= 0").count.to_f) * 100)).round(2)
          @year_nps3 = (((@tot_results.all(:conditions => "n3>8").count.to_f / @tot_results.all(:conditions => "n3 >= 0").count.to_f) * 100) - ((@tot_results.all(:conditions => "n3<7").count.to_f / @tot_results.all(:conditions => "n3 >= 0").count.to_f) * 100)).round(2)

          last_year_exit = PracticeReport.where(run_id: 13, practice_group_id: group.id, stat_type: "rolling").first
          if last_year_exit == nil
            last_year_exit = PracticeReport.new
            last_year_exit.n1 = 0
            last_year_exit.n2 = 0
            last_year_exit.n3 = 0
          end

          data = render_to_string( :partial => "reports/nps", :locals => {
            :clinic => group, 
            :results => @results,
            :tot_results=>@tot_results,
            :invites => invites, 
            :run=>run,
            :nps1=>@nps1,
            :nps2=>@nps2,
            :nps3=>@nps3,
            :export=>true,
            :fyiNps1=>@fyiNps1,
            :fyiNps2=>@fyiNps2,
            :fyiNps3=>@fyiNps3,
            :quarter_runs => quarter_runs,                        
            :lastYearNps=>[(last_year_exit.n1*100).round(2),(last_year_exit.n2*100).round(2),(last_year_exit.n3*100).round(2)],
            :reportType=>"group",
            :anonymous=>true, :year_nps1 => @year_nps1, :year_nps2 => @year_nps2, :year_nps3 => @year_nps3
          })
          
          data_emails = render_to_string( :partial => "reports/nps", :locals => {
            :clinic => group, 
            :results => @results,
            :tot_results=>@tot_results,
            :invites => invites, 
            :run=>run,
            :nps1=>@nps1,
            :nps2=>@nps2,
            :nps3=>@nps3,
            :export=>true,
            :fyiNps1=>@fyiNps1,
            :fyiNps2=>@fyiNps2,
            :fyiNps3=>@fyiNps3,
            :quarter_runs => quarter_runs,                        
            :lastYearNps=>[(last_year_exit.n1*100).round(2),(last_year_exit.n2*100).round(2),(last_year_exit.n3*100).round(2)],
            :reportType=>"group",
            :anonymous=>false, :year_nps1 => @year_nps1, :year_nps2 => @year_nps2, :year_nps3 => @year_nps3
         })

          #:action => :show,  :id => result.practice_id.to_s, :run=>run )
          
          FileUtils.mkdir_p("/Users/dean/Work/FYi/Net Promoter Score/reports/" + run.name + "/groups/")
          reportFile1 = "/Users/dean/Work/FYi/Net Promoter Score/reports/" + run.name + "/groups/report_" + group.id.to_s + ".pdf"
          pdf = WickedPdf.new.pdf_from_string(data)
          #File.open(pdf, "w"){|f| f << data}
          save_path = reportFile1
          File.open(save_path, 'wb') do |file|
            file << pdf
          end

          reportFile2 = "/Users/dean/Work/FYi/Net Promoter Score/reports/" + run.name + "/groups/report_" + group.id.to_s + "_with_emails.pdf"
          pdf = WickedPdf.new.pdf_from_string(data_emails)
          #File.open(pdf, "w"){|f| f << data}
          save_path = reportFile2
          File.open(save_path, 'wb') do |file|
            file << pdf
          end

        end
      end
    end
  end
  
  def show
    @run = Run.where(:id => params[:run_id]).first
    logger.debug("RUN: " + @run.id.to_s)
		logger.debug("FORMAT: " + request.format)
    reportType = ""

    fyiResults = SurveyAnswer.where(:status=>"Complete")
    @fyiNps1 = (((fyiResults.all(:conditions => "n1>8").count.to_f / fyiResults.count.to_f) * 100) - ((fyiResults.all(:conditions => "n1<7").count.to_f / fyiResults.count.to_f) * 100)).round(2)
    @fyiNps2 = (((fyiResults.all(:conditions => "n2>8").count.to_f / fyiResults.count.to_f) * 100) - ((fyiResults.all(:conditions => "n2<7").count.to_f / fyiResults.count.to_f) * 100)).round(2)
    @fyiNps3 = (((fyiResults.all(:conditions => "n3>8").count.to_f / fyiResults.count.to_f) * 100) - ((fyiResults.all(:conditions => "n3<7").count.to_f / fyiResults.count.to_f) * 100)).round(2)
    @fyiNpsAvg = ((@fyiNps1 + @fyiNps2 + @fyiNps3)/3)
    
    if params[:type] == "group"
      @reportType = "group"
      group = params[:id]
      logger.debug("GROUP: " + group)        
      @clinic = PracticeGroup.where(:id=>group).first

      @invites = @clinic.get_invites(@run.id)
      @results = @clinic.get_answers(@run.id)
      @tot_results = @clinic.get_all_answers
    else
      @reportType = "clinic"
      clinic = params[:id]
      logger.debug("CLINIC: " + clinic)        
      @clinic = Clinic.where(:id=>clinic).first

      @invites = Patient.where(:run_id=>@run.id, :practice_id=>@clinic.practice_id)
      @results = SurveyAnswer.where(:run_id=>@run.id, :practice_id => @clinic.practice_id, :status=>"Complete")      
      @tot_results = SurveyAnswer.where(:practice_id => @clinic.practice_id, :status=>"Complete")      
    end
    
    @nps1 = (((@results.all(:conditions => "n1>8").count.to_f / @results.count.to_f) * 100) - ((@results.all(:conditions => "n1<7").count.to_f / @results.count.to_f) * 100)).round(2)
		@nps2 = (((@results.all(:conditions => "n2>8").count.to_f / @results.count.to_f) * 100) - ((@results.all(:conditions => "n2<7").count.to_f / @results.count.to_f) * 100)).round(2)
		@nps3 = (((@results.all(:conditions => "n3>8").count.to_f / @results.count.to_f) * 100) - ((@results.all(:conditions => "n3<7").count.to_f / @results.count.to_f) * 100)).round(2)

    @year_nps1 = (((@tot_results.all(:conditions => "n1>8").count.to_f / @tot_results.count.to_f) * 100) - ((@tot_results.all(:conditions => "n1<7").count.to_f / @tot_results.count.to_f) * 100)).round(2)
    @year_nps2 = (((@tot_results.all(:conditions => "n2>8").count.to_f / @tot_results.count.to_f) * 100) - ((@tot_results.all(:conditions => "n2<7").count.to_f / @tot_results.count.to_f) * 100)).round(2)
    @year_nps3 = (((@tot_results.all(:conditions => "n3>8").count.to_f / @tot_results.count.to_f) * 100) - ((@tot_results.all(:conditions => "n3<7").count.to_f / @tot_results.count.to_f) * 100)).round(2)
				
    logger.debug("FOUND: " + @results.count.to_s)
    
    #data = render_to_string( :partial => "reports/nps.html.haml", :locals => {
    #      :clinic => @clinic, 
    #      :results => @results,
    #      :invites => @invites.count, 
    #      :run=>@run
    #    })
    
    
    
    respond_to do |format|
      format.html
      format.doc { 
        send_data data, :filename => "my_file.doc"  }
      format.pdf {
        render :pdf => "myfile.doc"
      }
    end

  end  
end