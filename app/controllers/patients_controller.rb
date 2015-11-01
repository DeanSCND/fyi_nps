class PatientsController < ApplicationController
  
  require 'csv'
  require 'json'
  require 'roo'

  before_action :set_patient, only: [:show, :edit, :update, :destroy]

  # GET /patients
  # GET /patients.json
  def index
    run_id = params[:run]
    @run = Run.where(:id => run_id).first

    @files = export_for_survey(@run)

    puts "FILES: " + @files.to_s

    respond_to do |format|
      format.html
      #format.csv { send_data @patients.to_csv }

    end    
  end

  # GET /patients/1
  # GET /patients/1.json
  def show
  end

  # GET /patients/new
  def new
    @run = Run.find(params["run"])
    @patient_count = Patient.count(:conditions => "run_id = #{params[:run].to_s}")

    @patient = Patient.new
    @runs = Run.all    
  end

  # GET /patients/1/edit
  def edit
  end

  # POST /patients
  # POST /patients.json
  def create    
    fluid = Fluid::Api.new('dean.skelton@fyidoctors.com', 'Fyidoctors2014?!')
    
    #if params[:fluid] != nil
    #  respStr = fluid.create_list(params[:patient][:run]).to_json
    #  val = JSON.parse(respStr)
    #  list_id = val["id"]
    #
    #  logger.debug("RAW: " + val.to_s)
    #  logger.debug("RAW: " + val["id"].to_s)
    #end    

    run = Run.where(:id => params[:patient][:run]).first
    if run == nil
      logger.debug("NO RUN CREATED")
      return
    end

    puts "PARMS: " + params[:patient][:file].to_s

    name = params[:patient][:file].original_filename
    directory = 'tmp'
    path = File.join(directory, "TEMP_PATIENTS.xlsx")
    csv_path = File.join(directory, "TEMP_PATIENTS.csv")
    puts "PATH: " + path
    File.open(path, "wb") { |f| f.write(params[:patient][:file].read) }


    parsed_file = Roo::Excelx.new(path) 

    puts parsed_file.sheet(0).to_csv(csv_path)

    csv_file = File.read(csv_path)
    
    CSV.parse(csv_file, headers: true) do |row|
      if row[3] != "Full Name"
        rawEmail = row[6];
        cleanEmail = rawEmail.delete(' ').gsub(',','.')
        pExists = Patient.where(:email => cleanEmail).first

        if(rawEmail != cleanEmail) 
          log = Log.new
          log.type = "PATIENT"
          log.message = "Patient with email " + rawEmail + " was cleaned to " + cleanEmail + " for clinic " + row[0].to_s
          log.save
        end
        if(pExists != nil) 
          log = Log.new
          log.type = "PATIENT"
          log.message = "Patient with email " + cleanEmail + " already exists with id=" + pExists.id.to_s + ". Skipping."
          log.save
        end
    
        @patient = Patient.new
        @patient.name = row[2].to_s + " " + row[1].to_s
        @patient.email = cleanEmail.downcase
        @patient.practice_id = row[0]
        @patient.visitDate = row[7]
        #@patient.run = params[:patient][:run]
        @patient.run_id = run.id
        clinic = Clinic.where(:practice_id => @patient.practice_id).first
              
        @patient.save
      else
        logger.debug("Skipping " + row[3])
      end
      
      # TODO - ADD UNIQUNESS CHECK AND UPDATE RECORD INSTEAD
    end    
       
    #@patient = Patient.new(patient_params)

    respond_to do |format|
      format.html { redirect_to runs_path, notice: 'Patient was successfully created.' }
      format.json { render action: 'show', status: :created, location: @patient }
    end
  end

  # PATCH/PUT /patients/1
  # PATCH/PUT /patients/1.json
  def update
    respond_to do |format|
      if @patient.update(patient_params)
        format.html { redirect_to @patient, notice: 'Patient was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patients/1
  # DELETE /patients/1.json
  def destroy
    @patient.destroy
    respond_to do |format|
      format.html { redirect_to patients_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_patient
      @patient = Patient.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def patient_params
      params.require(:patient).permit(:name, :email, :practice_id, :practice_name, :visitDate, :run)
    end

    def export_for_survey(run)
      _BATCH_SIZE_ = 4999

      files = []

      fluid = Fluid::Api.new('dean.skelton@fyidoctors.com', 'Fyidoctors2014?!')
      puts "FOR RUN: " + run.name
      collector_created = fluid.create_collector(859623, "COLLECTOR_" + run.name)
      puts "collector_created: " + collector_created.to_s

      fluid.clear_lists()

      if(params[:date] != nil) 
        date = Date.parse(params[:date])
        logger.debug("RUNING FOR DATE: " + params[:date])
        @patients = Patient.select('DISTINCT patients.name, email, clinics.practice_id as "Practice Id", clinics.name as "Practice Name", replace(to_char("visitDate", \'Month dd, YYYY\'), \'  \', \' \') as "Visit Date", runs.name as "RUN"').where(:run_id => run.id).where("patients.created_at > ?", date).joins(:clinic).joins(:run)
      else
        count = Patient.where(:run_id => run.id).count()
        batches = (count.to_f/_BATCH_SIZE_.to_f).ceil
        logger.debug("COUNT: " + count.to_s + "  :  " + batches.to_s)

        last = 0
        for i in 1..batches
          logger.debug("LOOP " + i.to_s)
          list_id = fluid.create_list(run.name + "_" + i.to_s)

          @patients = Patient.select('DISTINCT patients.id as id, patients.name, email, clinics.practice_id as "Practice Id", clinics.name as "Practice Name", replace(to_char("visitDate", \'Month dd, YYYY\'), \'  \', \' \') as "Visit Date", runs.name || \'_' + i.to_s + '\' as "RUN"').where(:run_id => run.id).where("patients.id > ?", last.to_s).joins(:clinic).joins(:run).limit(_BATCH_SIZE_).order("id ASC")
          #@patients = Patient.where("run_id = ?", run.id.to_s).where("id > ?", last.to_s).limit(_BATCH_SIZE_).order("id ASC")
          logger.debug("FETCHED: " + @patients.count.to_s)
          last = @patients.last.id
          logger.debug("LAST: " + last.to_s)
          FileUtils.mkdir_p("#{Rails.configuration.path}patients/" + run.name)
          importFile = "#{Rails.configuration.path}patients/" + run.name + "/fluid-import_" + i.to_s + ".csv"
          File.open(importFile, "w"){|f| f << @patients.to_csv}
          file = {
            "file" => importFile,
            "contact_list" => run.name + "_" + i.to_s
          }

          files.push(file)

          #@patients.each do |patient|
          #  puts "PAT: " + patient.to_s
          #  practice = Clinic.where(:practice_id => patient.practice_id).first
          #  fluid.create_contact_in_list(patient, practice.name, run.name, list_id)
          #end        
        end
        #@patients = Patient.select('patients.name, email, clinics.practice_id as "Practice Id", clinics.name as "Practice Name", replace(to_char("visitDate", \'Month dd, YYYY\'), \'  \', \' \') as "Visit Date", runs.name as "RUN"').where(:run_id => run.id).joins(:clinic).joins(:run)       

        return files

      end
    end
end
