class SurveysController < ApplicationController
  include Fluid
  require 'json'
  
  before_action :set_survey, only: [:show, :edit, :update, :destroy]

  # GET /surveys
  # GET /surveys.json
  def index
    @surveys = Survey.all
  end

  # GET /surveys/1
  # GET /surveys/1.json
  def show
  end

  # GET /surveys/new
  def new
    @survey = Survey.new
  end

  # GET /surveys/1/edit
  def edit
  end

  # POST /surveys
  # POST /surveys.json
  def create
    @survey = Survey.new(survey_params)

    #Move contacts
    fluid = Fluid::Api.new('dean.skelton@fyidoctors.com', 'Fyidoctors2013')

    contacts Contact.where(:run => params[:survey][:run])
    
    contacts.each do |contact|    
      logger.debug("CREATING CONTACT" + @contact)
      contact = {
        "name" => contact.name,
        "email" => contact.email,
        "custom_RUN" => contact.run,
        "custom_Practice Id" => contact.practice_id,
        "custom_Practice Name" => contact.clinic.name
      }.to_json
      val = fluid.create_contact(contact)
    
      logger.debug("RAW: " + val.to_s)
    end
    #jval = JSON.parse(val.to_json)
    #logger.debug("JSON: " + jval["results"][0]["name"])

    respond_to do |format|
      if @survey.save
        format.html { redirect_to @survey, notice: 'Survey was successfully created.' }
        format.json { render action: 'show', status: :created, location: @survey }
      else
        format.html { render action: 'new' }
        format.json { render json: @survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /surveys/1
  # PATCH/PUT /surveys/1.json
  def update
    respond_to do |format|
      if @survey.update(survey_params)
        format.html { redirect_to @survey, notice: 'Survey was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /surveys/1
  # DELETE /surveys/1.json
  def destroy
    @survey.destroy
    respond_to do |format|
      format.html { redirect_to surveys_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey
      @survey = Survey.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def survey_params
      params.require(:survey).permit(:run, :count, :month, :status)
    end
end
