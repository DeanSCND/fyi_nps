class SurveyResultsController < ApplicationController
  before_action :set_survey_result, only: [:show, :edit, :update, :destroy]
  require 'csv'
  require 'roo'

  # GET /survey_results
  # GET /survey_results.json
  def index
    if params[:run_id] 
      run_id = params[:run_id].to_i
    logger.debug("run: " + run_id.to_s)
    if run_id > 4
        @survey_results = SurveyAnswer.where(:run_id=>run_id, :status=>"Complete")
      else
        @survey_results = SurveyResult.where(:run_id=>run_id, :status=>"Complete")
      end
    else
      @survey_results = SurveyAnswer.all
    end
    logger.debug("COUNT: " + @survey_results.length.to_s)
    respond_to do |format|
      format.json { render :json => @survey_results.to_json(:include=>:patient) }
    end
  end

  # GET /survey_results/1
  # GET /survey_results/1.json
  def show
  end

  # GET /survey_results/new
  def new
    result_count = SurveyAnswer.count(:conditions => "run_id = #{params[:run_id].to_s}")
    for_run = Run.find(params[:run_id])
    puts "FOR RUN: " + for_run.id.to_s

    if result_count ==  0

      i = 0
      run_id = 0

      #puts "PARMS: " + params[:survey_result][:file].to_s
      #name = params[:survey_result][:file].original_filename
      directory = 'tmp'
      path = File.join(directory, "TEMP_RESULTS.csv")
      csv_path = File.join(directory, "TEMP_RESULTS2.csv")
      puts "PATH: " + path

      fluid = Fluid::Api.new('dean.skelton@fyidoctors.com', 'Fyidoctors2014?!')

      start_date = DateTime.parse(for_run.start_date).strftime("%F")
      end_date = DateTime.parse(for_run.end_date).strftime("%F")
      puts "DATES: " + start_date + " : " + end_date

      responses = fluid.get_results(start_date)
      File.open(path, "wb") { |f| f.write(responses.encode('UTF-8', :invalid => :replace, :undef => :replace)) }
      #File.open(path, "wb") { |f| f.write(params[:survey_result][:file].read) }

      parsed_file = Roo::CSV.new(path) 

      puts parsed_file.sheet(0).to_csv(csv_path)

      csv_file = File.read(csv_path)

      CSV.parse(csv_file, {:headers => true}) do |row|
        start_of_results = 20
        @result = SurveyAnswer.new
        email = row[start_of_results-6]
        @patient = Patient.where(:email => email).first
        if @patient != nil
          existing = SurveyAnswer.where(:patient_id => @patient.id).first
          
          @result.patient_id = @patient.id
          @result.practice_id = @patient.practice_id
          logger.debug("PT: " + @patient.id.to_s  )
          @result.status = row[0]
          @result.fid = row[1].to_i
          @result.ip = row[5]
          @result.location = row[6]

          @result.run_id = @patient.run.id
          run_id = @result.run_id
          @result.collector = row[start_of_results]

          @result.n1 = calculate_score row[start_of_results+14]
          @result.n2 = calculate_score row[start_of_results+15]
          @result.n3 = calculate_score row[start_of_results+16]
          @result.c9 = clean_comment row[start_of_results+17]

          @result.a1 = calculate_score row[start_of_results+1]
          @result.c1 = clean_comment row[start_of_results+2]
          @result.a2 = calculate_score row[start_of_results+3]
          @result.a3 = calculate_score row[start_of_results+4]
          @result.a3o = row[start_of_results+5]
          @result.a4 = calculate_score row[start_of_results+6]
          @result.a4o = row[start_of_results+7]
          @result.a5 = calculate_score row[start_of_results+8]
          @result.a5o = row[start_of_results+9]
          @result.a6 = calculate_score row[start_of_results+10]
          @result.a6o = row[start_of_results+11]

          @result.a7 = calculate_score row[start_of_results+12]
          @result.a7o = row[start_of_results+13]

          if for_run.id == run_id
            @result.save
          end
        end
        i = i + 1
      end

      Statistics::Utils.generate_stats_for_run(run_id)
    
    end

    respond_to do |format|
      format.html { redirect_to runs_path(run_id) }
      format.json { render action: 'show', status: :created, location: @survey_result }
    end
  end

  # GET /survey_results/1/edit
  def edit
  end

  # POST /survey_results
  # POST /survey_results.json
  def create_new
    fluid = Fluid::Api.new('dean.skelton@fyidoctors.com', 'Fyidoctors2014?!')

    count = 1
    responses = fluid.get_results(date: '2015-08-15', page: count)
    
    directory = 'tmp'
    path = File.join(directory, "RES.json")
    File.open(path, "wb") { |f| f.write(JSON.pretty_generate(responses)) }

    puts "GETTING: #{count.to_s}" 
    while responses["next"] != nil
      count = count+1
      responses["results"].each do |r|
        @result = SurveyAnswer.new
        email = r["_invite_email"]
        @patient = Patient.where(:email => email).first

        @patient = Patient.where(:email => email).first
        if @patient != nil
          existing = SurveyAnswer.where(:patient_id => @patient.id).first
          puts r.to_json.to_s
          @result.patient_id = @patient.id
          @result.practice_id = @patient.practice_id
          @result.status = r["_completed"]==1 ? "COMPLETE" : "INCOMPLETE"
          @result.fid = r["_id"]
          #@result.created = 
          @result.ip = r["_ip_address"]

          @result.run_id = @patient.run.id
          run_id = @result.run_id
          @result.collector = r["_collector_id"]

          @result.a1 = r["3m9uzuklnq"]
          @result.c1 = clean_comment r["Mg2f0afloz"]
          @result.a2 = r["Vdfalzxewc"]
          @result.b2 = r["R7whigtrwx"]
          puts "b2:" + r["Vfnkuvxw1m"].to_s
          @result.a3 = r["Vfnkuvxw1m"][0]
          @result.a3o = clean_comment r["Vfnkuvxw1m"][1]
          @result.c3 = clean_comment r["81htq30gsg"]
          @result.a4 = r["Yoy6nwsgtd"][0]
          @result.a4o = clean_comment r["Yoy6nwsgtd"][1]
          @result.c4 = r["Uyvctv6eyi"]
          @result.a5 = r["7gsdso3asd"][0]
          @result.a5o = clean_comment r["7gsdso3asd"][1]
          @result.c5 = clean_comment r["Uyvctv6eyi"]
          @result.a6 = r["Qvw62xswtx"][0]
          @result.a6o = clean_comment r["Qvw62xswtx"][1]
          @result.c6 = clean_comment r["Ucldeseaci"]
          @result.a7 = r["Tygvpk57io"][0]
          @result.a7o = clean_comment r["Tygvpk57io"][1]
          @result.c7 = clean_comment r["Ty5hmptect"]
          @result.a8 = r["8a5zrfgnt7"][0]
          @result.a8o = clean_comment r["8a5zrfgnt7"][0]
          @result.c8 = clean_comment r["Fgmernmdoa"]

          @result.n1 = r["Dahs7lmu5q"][0]
          @result.n1o = clean_comment r["Dahs7lmu5q"][1]
          @result.n2 = r["Edrsatbzsa"][0]
          @result.n2o = clean_comment r["Edrsatbzsa"][1]
          @result.n3 = r["4dd2lseqmp"]

          @result.c9 = clean_comment r["Qtwlreqrik"]
        end        
      end
      responses = fluid.get_results(date: '2015-08-01', page: count)

      puts "GETTING: #{count.to_s}"
    end

    render :json => JSON.pretty_generate(responses)

  end


  # POST /survey_results
  # POST /survey_results.json
  def create

  end

  # PATCH/PUT /survey_results/1
  # PATCH/PUT /survey_results/1.json
  def update
    respond_to do |format|
      if @survey_result.update(survey_result_params)
        format.html { redirect_to @survey_result, notice: 'Survey result was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @survey_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /survey_results/1
  # DELETE /survey_results/1.json
  def destroy
    @survey_result.destroy
    respond_to do |format|
      format.html { redirect_to survey_results_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey_result
      @survey_result = SurveyResult.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def survey_result_params
      params.require(:survey_result).permit(:patient_id, :status, :fid, :created, :ip, :location, :nps, :run, :collector, :a1, :a2, :a3, :a4, :a5, :a6comment, :posfeedback, :b1, :b2, :b3, :b4, :b5, :b6comment, :contact, :negfeedback)
    end
    
    def calculate_score(answer)
      
      if answer == nil
        return nil
      elsif answer.include? '10'
        return 10
      elsif answer.include? '5'
        return 5
      elsif answer.start_with?('0')
        return 0
      else
        if answer =~ /\A[-+]?[0-9]*\.?[0-9]+\Z/
          return answer.to_i
        else
          return nil
        end
      end
    end
    
    def clean_comment(answer)
      if answer != nil
        return answer.encode('UTF-8', :invalid => :replace, :undef => :replace)
      else
        return answer
      end
    end
end
