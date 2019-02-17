class TroopSchedulesController < ApplicationController
  before_action :load_village
  before_action :load_troop_schedule, only: :destroy

  def new
    @troop_creator = @village.troop_schedules.build
  end

  def create
    @troop_creator = @village.troop_schedules.new troop_creator_params
    
    if @troop_creator.save
      flash[:success] = "troop schedule add success"
      redirect_to my_villages_path
    else
      flash[:fail] = "troop schedule add fail"
      render :new
    end
  end

  def destroy
    @troop_creator.destroy
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

  def troop_creator_params
    params.require(:troop_schedule).permit :troop_id, :troop_number, :my_village_id, :build_id
  end
  
    def load_troop_schedule
    @troop_creator = @village.troop_schedules.find_by id: params[:id]
    if @troop_creator.nil?
      flash[:dangder] = "không tìm thấy troop chedule"
      redirect_to my_villages_path
    end
  end
end
