class UpgrateSchedulesController < ApplicationController
  before_action :load_village
  before_action :load_upgrate_building, only: :destroy

  def new
    @upgrate_building = @village.upgrate_schedules.build
  end

  def create
    @upgrate_building = @village.upgrate_schedules.new upgrate_building_params
    
    if @upgrate_building.save
      flash[:success] = "add success"
      redirect_to my_villages_path
    else
      flash[:fail] = "add fail"
      render :new
    end
  end

  def destroy
    @upgrate_building.destroy
    redirect_to my_villages_path
  end

  private
  def load_village
    @village = current_user.my_villages.find_by id: params[:my_village_id]
    if @village.nil?
      flash[:dangder] = "không tìm thấy village"
      redirect_to my_villages_path
    end
  end

  def upgrate_building_params
    params.require(:upgrate_schedule).permit :upgrate_id, :my_village_id
  end

  def load_upgrate_building
    @upgrate_building = @village.upgrate_schedules.find_by id: params[:id]
    if @upgrate_building.nil?
      flash[:dangder] = "không tìm thấy upgrate building"
      redirect_to my_villages_path
    end
  end
end