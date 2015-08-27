class PatientsController < ApplicationController
  
  require 'csv'
  require 'json'
  require 'roo'

  before_action :set_patient, only: [:show, :edit, :update, :destroy]

  # GET /patients
  # GET /patients.json
  def index
    @run = params[:run]
    run = Run.where(:id => @run).first

    fluid = Fluid::Api.new('dean.skelton@fyidoctors.com', 'Fyidoctors2014?!')
    fluid.create_collector(537808, "COLLECTOR_" + run.name)
    if(params[:date] != nil) 
      date = Date.parse(params[:date])
      logger.debug("RUNING FOR DATE: " + params[:date])
      @patients = Patient.select('DISTINCT patients.name, email, clinics.practice_id as "Practice Id", clinics.name as "Practice Name", replace(to_char("visitDate", \'Month dd, YYYY\'), \'  \', \' \') as "Visit Date", runs.name as "RUN"').where(:run_id => run.id).where("patients.created_at > ?", date).joins(:clinic).joins(:run)
    else
      count = Patient.where(:run_id => run.id).count()
      batches = (count.to_f/4999.to_f).ceil
      logger.debug("COUNT: " + count.to_s + "  :  " + batches.to_s)

      last = 0
      for i in 1..batches
        logger.debug("LOOP " + i.to_s)
        list_id = fluid.create_list(run.name + "_" + i.to_s)

        @patients = Patient.select('DISTINCT patients.id as id, patients.name, email, clinics.practice_id as "Practice Id", clinics.name as "Practice Name", replace(to_char("visitDate", \'Month dd, YYYY\'), \'  \', \' \') as "Visit Date", runs.name || \'_' + i.to_s + '\' as "RUN"').where(:run_id => run.id).where("patients.id > ?", last.to_s).joins(:clinic).joins(:run).limit(4999).order("id ASC")
        #@patients = Patient.where("run_id = ?", run.id.to_s).where("id > ?", last.to_s).limit(4999).order("id ASC")
        logger.debug("FETCHED: " + @patients.count.to_s)
        last = @patients.last.id
        logger.debug("LAST: " + last.to_s)
        FileUtils.mkdir_p("/Users/dean/Work/FYi/Net Promoter Score/patients/" + run.name)
        importFile = "/Users/dean/Work/FYi/Net Promoter Score/patients/" + run.name + "/fluid-import_" + i.to_s + ".csv"
        File.open(importFile, "w"){|f| f << @patients.to_csv}

        #patient = @patients.first
        #clinic = Clinic.where(:practice_id => patient.practice_id).first
        

        #{}"custom_Practice Id" => clinic.id,
        #{}"custom_Practice Name" => clinic.name

        #contact2 = {
        #  "id" => patient.id,
        #  "name" => patient.name,
        #  "email" => patient.email,
        #  "custom_RUN" => run.name + "_" + i.to_s
        #}.to_json

        #if params[:fluid] != nil
        #listStr = fluid.create_contact_in_list(contact2,list_id)
        #logger.debug("RAW: " + listStr.to_s)
        #listJson = JSON.parse(listStr)
        #end


      end
     #@patients = Patient.select('patients.name, email, clinics.practice_id as "Practice Id", clinics.name as "Practice Name", replace(to_char("visitDate", \'Month dd, YYYY\'), \'  \', \' \') as "Visit Date", runs.name as "RUN"').where(:run_id => run.id).joins(:clinic).joins(:run)       

    end

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
    @patient = Patient.new
    @runs = Run.all    
  end

  # GET /patients/1/edit
  def edit
  end

  # POST /patients
  # POST /patients.json
  def create    
    fluid = Fluid::Api.new('dean.skelton@fyidoctors.com', 'Fyidoctors2013')
    
    #if params[:fluid] != nil
    #  respStr = fluid.create_list(params[:patient][:run]).to_json
    #  val = JSON.parse(respStr)
    #  list_id = val["id"]
    #
    #  logger.debug("RAW: " + val.to_s)
    #  logger.debug("RAW: " + val["id"].to_s)
    #end    

    run = Run.where(:id => params[:patient][:run]).first
    #if run == nil
    #  logger.debug("NO RUN CREATED")
    #  return
    #end

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
      
        logger.debug("CREATING CONTACT" + @patient.name)
      
        contact = {
          "name" => @patient.name,
          "email" => @patient.email,
          "custom_RUN" => run.name,
          "custom_Practice Id" => @patient.practice_id,
          "custom_Practice Name" => clinic.name,
          "custom_Visit Date" => @patient.visitDate.strftime("%B %e,  %Y")
        }.to_json
        logger.debug("POSTING: " + contact.to_s)
      
        if params[:fluid] != nil
          contactStr = fluid.create_contact(contact).body
          logger.debug("CONTACT RETURN: " + contactStr.to_s)
          contactJson = JSON.parse(contactStr)
          logger.debug("CONTACT ID : " + contactJson["id"].to_s)
          @patient.fid = contactJson["id"]
          logger.debug("RAW: " + contactStr.to_s)
        end
        
        #contact2 = {
        #  "id" => @patient.fid,
        #  "name" => @patient.name,
        #  "email" => @patient.email,
        #  "custom_RUN" => @patient.run,
        #  "custom_Practice Id" => @patient.practice_id,
        #  "custom_Practice Name" => clinic.name
        #}.to_json

        #if params[:fluid] != nil
        #  listStr = fluid.create_contact_in_list(contact2,list_id).body
        #  logger.debug("RAW: " + listStr)
        #  listJson = JSON.parse(listStr)
        #end
        
        @patient.save
      else
        logger.debug("Skipping " + row[3])
      end
      
      # TODO - ADD UNIQUNESS CHECK AND UPDATE RECORD INSTEAD
    end    
       
    #@patient = Patient.new(patient_params)

    respond_to do |format|
      format.html { redirect_to @patient, notice: 'Patient was successfully created.' }
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
end
