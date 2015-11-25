module Statistics
  class Utils
    def self.generate_stats_for_run(run_id)
      puts "Generating Statistics for #{run_id.to_s}"

      puts("RUN: " + run_id.to_s)
      run = Run.find(run_id)

      PracticeReport.where(:run_id => run.id).delete_all

      SurveyAnswer.select("DISTINCT(practice_id)").each do |result|
        clinic = Clinic.where(:practice_id=>result.practice_id).first
        puts("Generating stats for : " + clinic.name + " :" + clinic.practice_id.to_s)

        #my_html = '<html><head></head><body><p>Hello</p></body></html>'
        invites = Patient.where(:run_id=>run.id, :practice_id=>clinic.practice_id).count
        @results = SurveyAnswer.where(:run_id=>run.id, :practice_id => clinic.practice_id, :status=>"Complete")
        invites_roll = Patient.where("run_id <= ?", run.id).where("run_id >= 14").where(:practice_id=>clinic.practice_id).count
        @results_roll = SurveyAnswer.where("run_id <= ?", run.id).where("run_id >= 14").where(:practice_id => clinic.practice_id, :status=>"Complete")
        @tot_results = SurveyAnswer.where(:practice_id => clinic.practice_id, :status=>"Complete").where("run_id >= 14")      

        @nps1 = (((@results.all(:conditions => "n1>8").count.to_f / @results.all(:conditions => "n1 >= 0").count.to_f) ) - ((@results.all(:conditions => "n1<7").count.to_f / @results.all(:conditions => "n1 >= 0").count.to_f))).round(4)
        @nps2 = (((@results.all(:conditions => "n2>8").count.to_f / @results.all(:conditions => "n2 >= 0").count.to_f) ) - ((@results.all(:conditions => "n2<7").count.to_f / @results.all(:conditions => "n2 >= 0").count.to_f))).round(4)
        @nps3 = (((@results.all(:conditions => "n3>8").count.to_f / @results.all(:conditions => "n3 >= 0").count.to_f) ) - ((@results.all(:conditions => "n3<7").count.to_f / @results.all(:conditions => "n3 >= 0").count.to_f))).round(4)

        save_practice_statistics('period', run.id, clinic.practice_id, invites.to_f, @results.count, @nps1, @nps2, @nps3 )
        
        @nps1 = (((@results_roll.all(:conditions => "n1>8").count.to_f / @results_roll.all(:conditions => "n1 >= 0").count.to_f) ) - ((@results_roll.all(:conditions => "n1<7").count.to_f / @results_roll.all(:conditions => "n1 >= 0").count.to_f))).round(4)
        @nps2 = (((@results_roll.all(:conditions => "n2>8").count.to_f / @results_roll.all(:conditions => "n2 >= 0").count.to_f) ) - ((@results_roll.all(:conditions => "n2<7").count.to_f / @results_roll.all(:conditions => "n2 >= 0").count.to_f))).round(4)
        @nps3 = (((@results_roll.all(:conditions => "n3>8").count.to_f / @results_roll.all(:conditions => "n3 >= 0").count.to_f) ) - ((@results_roll.all(:conditions => "n3<7").count.to_f / @results_roll.all(:conditions => "n3 >= 0").count.to_f))).round(4)

        self.save_practice_statistics('rolling', run.id, clinic.practice_id, invites_roll.to_f, @results_roll.count, @nps1, @nps2, @nps3 )
      end

      PracticeGroup.all.each do |group|
        puts("Generating stats for : " + group.name + " :" + group.id.to_s)

        invites = group.get_invites(run.id).count
        @results = group.get_answers(run.id)
        invites_roll = group.get_rolling_invites(14)
        @results_roll = group.get_rolling_answers(14)
        @tot_results = group.get_all_answers

        @nps1 = (((@results.all(:conditions => "n1>8").count.to_f / @results.all(:conditions => "n1 >= 0").count.to_f)) - ((@results.all(:conditions => "n1<7").count.to_f / @results.all(:conditions => "n1 >= 0").count.to_f) )).round(4)
        @nps2 = (((@results.all(:conditions => "n2>8").count.to_f / @results.all(:conditions => "n2 >= 0").count.to_f)) - ((@results.all(:conditions => "n2<7").count.to_f / @results.all(:conditions => "n2 >= 0").count.to_f) )).round(4)
        @nps3 = (((@results.all(:conditions => "n3>8").count.to_f / @results.all(:conditions => "n3 >= 0").count.to_f)) - ((@results.all(:conditions => "n3<7").count.to_f / @results.all(:conditions => "n3 >= 0").count.to_f) )).round(4)

        save_group_statistics('period', run.id, group.id, invites.to_f, @results.count, @nps1, @nps2, @nps3 )

        @nps1 = (((@results_roll.all(:conditions => "n1>8").count.to_f / @results_roll.all(:conditions => "n1 >= 0").count.to_f) ) - ((@results_roll.all(:conditions => "n1<7").count.to_f / @results_roll.all(:conditions => "n1 >= 0").count.to_f))).round(4)
        @nps2 = (((@results_roll.all(:conditions => "n2>8").count.to_f / @results_roll.all(:conditions => "n2 >= 0").count.to_f) ) - ((@results_roll.all(:conditions => "n2<7").count.to_f / @results_roll.all(:conditions => "n2 >= 0").count.to_f))).round(4)
        @nps3 = (((@results_roll.all(:conditions => "n3>8").count.to_f / @results_roll.all(:conditions => "n3 >= 0").count.to_f) ) - ((@results_roll.all(:conditions => "n3<7").count.to_f / @results_roll.all(:conditions => "n3 >= 0").count.to_f))).round(4)

        self.save_group_statistics('rolling', run.id, group.id, invites_roll.count.to_f, @results_roll.count, @nps1, @nps2, @nps3 )
      end

      puts("RUNNING FOR FYI")

      run = Run.find(run_id)

      PracticeReport.where(:practice_id => 0, :run_id=>run.id).delete_all

      #my_html = '<html><head></head><body><p>Hello</p></body></html>'
      invites = Patient.where(:run_id=>run.id).count
      @results = SurveyAnswer.where(:run_id=>run.id, :status=>"Complete")
      invites_roll = Patient.where("run_id <= ?", run.id).where("run_id >= 14").count
      @results_roll = SurveyAnswer.where("run_id <= ?", run.id).where("run_id >= 14").where(:status=>"Complete")
      @tot_results = SurveyAnswer.where(:status=>"Complete")

      @nps1 = (((@results.all(:conditions => "n1>8").count.to_f / @results.all(:conditions => "n1 >= 0").count.to_f) ) - ((@results.all(:conditions => "n1<7").count.to_f / @results.all(:conditions => "n1 >= 0").count.to_f))).round(4)
      @nps2 = (((@results.all(:conditions => "n2>8").count.to_f / @results.all(:conditions => "n2 >= 0").count.to_f) ) - ((@results.all(:conditions => "n2<7").count.to_f / @results.all(:conditions => "n2 >= 0").count.to_f))).round(4)
      @nps3 = (((@results.all(:conditions => "n3>8").count.to_f / @results.all(:conditions => "n3 >= 0").count.to_f) ) - ((@results.all(:conditions => "n3<7").count.to_f / @results.all(:conditions => "n3 >= 0").count.to_f))).round(4)

      save_practice_statistics('period', run.id, 0, invites.to_f, @results.count, @nps1, @nps2, @nps3 )
      
      @nps1 = (((@results_roll.all(:conditions => "n1>8").count.to_f / @results_roll.all(:conditions => "n1 >= 0").count.to_f) ) - ((@results_roll.all(:conditions => "n1<7").count.to_f / @results_roll.all(:conditions => "n1 >= 0").count.to_f))).round(4)
      @nps2 = (((@results_roll.all(:conditions => "n2>8").count.to_f / @results_roll.all(:conditions => "n2 >= 0").count.to_f) ) - ((@results_roll.all(:conditions => "n2<7").count.to_f / @results_roll.all(:conditions => "n2 >= 0").count.to_f))).round(4)
      @nps3 = (((@results_roll.all(:conditions => "n3>8").count.to_f / @results_roll.all(:conditions => "n3 >= 0").count.to_f) ) - ((@results_roll.all(:conditions => "n3<7").count.to_f / @results_roll.all(:conditions => "n3 >= 0").count.to_f))).round(4)

      save_practice_statistics('rolling', run.id, 0, invites_roll.to_f, @results_roll.count, @nps1, @nps2, @nps3 )
    end

    def self.save_practice_statistics(type, run_id, practice_id, invites, response_count, n1, n2, n3)
      pr = PracticeReport.new
      pr.n1 = n1
      pr.n2 = n2
      pr.n3 = n3
      pr.run_id = run_id
      pr.practice_id = practice_id
      pr.responses = response_count

      puts("Invites: " + invites.to_s + " : " + response_count.to_s)
      if(invites > 0)
        pr.response_rate = (response_count.to_f/invites.to_f).round(4).to_f
      else
        pr.response_rate = 0
      end

      pr.stat_type = type
      pr.save
    end

    def self.save_group_statistics(type, run_id, group_id, invites, response_count, n1, n2, n3)
      pr = PracticeReport.new
      pr.n1 = n1
      pr.n2 = n2
      pr.n3 = n3
      pr.run_id = run_id
      pr.practice_group_id = group_id
      pr.responses = response_count
      
      puts("Invites: " + invites.to_s + " : " + @results.count.to_s)
      if(invites > 0)
        pr.response_rate = (response_count.to_f/invites.to_f).round(4).to_f
      else
        pr.response_rate = 0
      end

      pr.stat_type = type
      pr.save
    end
  end
end
