class PracticeGroupsController < ApplicationController
  before_action :set_practice_group, only: [:show, :edit, :update, :destroy]

  # GET /practice_groups
  # GET /practice_groups.json
  def index
    @practice_groups = PracticeGroup.all
  end

  # GET /practice_groups/1
  # GET /practice_groups/1.json
  def show
  end

  # GET /practice_groups/new
  def new
    @practice_group = PracticeGroup.new
  end

  # GET /practice_groups/1/edit
  def edit
  end

  # POST /practice_groups
  # POST /practice_groups.json
  def create
    @practice_group = PracticeGroup.new(practice_group_params)

    respond_to do |format|
      if @practice_group.save
        format.html { redirect_to @practice_group, notice: 'Practice group was successfully created.' }
        format.json { render action: 'show', status: :created, location: @practice_group }
      else
        format.html { render action: 'new' }
        format.json { render json: @practice_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /practice_groups/1
  # PATCH/PUT /practice_groups/1.json
  def update
    respond_to do |format|
      if @practice_group.update(practice_group_params)
        format.html { redirect_to @practice_group, notice: 'Practice group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @practice_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /practice_groups/1
  # DELETE /practice_groups/1.json
  def destroy
    @practice_group.destroy
    respond_to do |format|
      format.html { redirect_to practice_groups_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_practice_group
      @practice_group = PracticeGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def practice_group_params
      params.require(:practice_group).permit(:name)
    end
end
