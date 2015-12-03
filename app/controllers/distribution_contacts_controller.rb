class DistributionContactsController < ApplicationController

  # GET /clinics
  # GET /clinics.json
  def index
    @clinic = Clinic.find(params[:clinic_id])
    distribution_clinics = DistributionClinic.where(practice_id: @clinic.practice_id)
    
    print "COUNT: " + distribution_clinics.count.to_s
    if distribution_clinics.count == 0
      print "Create the record"
      @distribution = Distribution.create()
      @distribution.save
      @distribution_clinic = DistributionClinic.create(distribution_id: @distribution.id, practice_id: @clinic.practice_id)
      @distribution_clinic.save
    else
      @distribution_clinic = distribution_clinics.first
    end  

    @contacts = DistributionContacts.where(distribution_id: @distribution_clinic.distribution_id)
  end

  def show
    @clinic = params[:clinic_id]
  end

  def new 
    @distribution_contact = Clinic.new
    @fyi_contact = FyiContact.new
    @clinic = Clinic.find(params[:clinic_id])

  end

  def destroy
    @clinic = Clinic.find(params[:clinic_id])    
    @distribution_contact = DistributionContacts.find(params[:id])

    @distribution_contact.destroy
    respond_to do |format|
      format.html { redirect_to clinic_distribution_contacts_path }
      format.json { head :no_content }
    end
  end
end