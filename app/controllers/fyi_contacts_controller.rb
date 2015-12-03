class FyiContactsController < ApplicationController
  before_action :set_fyi_contact, only: [:show, :edit, :update, :destroy]
  def new
  end

  def create
    @clinic = Clinic.find(params[:clinic_id])
    email = params['fyi_contact']['email'].strip
    @fyi_contacts = FyiContact.where(email: email)
    fyi_contact = nil

    if @fyi_contacts.count > 0 
      print "FOUND"
      fyi_contact = @fyi_contacts.first
    else
      print "NOT FOUND"
      fyi_contact = FyiContact.create(email: email)
      fyi_contact.save
    end

    DistributionContacts.find_by_sql "select setval('distribution_contacts_id_seq', (select max(id) from distribution_contacts) + 1)"

    @distribution_contact = DistributionContacts.new
    distribution_clinic = DistributionClinic.where(practice_id: @clinic.practice_id).first
    @distribution_contact.distribution_id = distribution_clinic.distribution_id
    @distribution_contact.fyi_contact_id = fyi_contact.id

    respond_to do |format|
      if @distribution_contact.save
        format.html { redirect_to clinic_distribution_contacts_path, notice: 'Clinic was successfully created.' }
        format.json { render action: 'show', status: :created, location: @clinic }
      else
        format.html { render action: 'new' }
        format.json { render json: @clinic.errors, status: :unprocessable_entity }
      end
    end


  end

  def edit
  end

  def show
  end

  def update
    respond_to do |format|
      if @fyi_contact.update(fyi_contact_params)
        format.html { redirect_to clinic_distribution_contacts_path(@clinic.id), notice: 'Contact was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @fyi_contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    DistributionContacts.where(fyi_contact_id: @fyi_contact.id).delete_all
    @fyi_contact.destroy
    respond_to do |format|
      format.html { redirect_to clinic_distribution_contacts_path }
      format.json { head :no_content }
    end
end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fyi_contact
      @clinic = Clinic.find(params[:clinic_id])
      @fyi_contact = FyiContact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fyi_contact_params
      params.require(:fyi_contact).permit(:email)
    end
end
