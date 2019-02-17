class SendResourceSchedulesController < ApplicationController
  before_action :load_village
  before_action :load_send_resource_schedule, only: :destroy
    
  def new
    @send_resource_schedule = @village.send_resource_schedules.build
  end
  
  def create
    @send_resource_schedule = @village.send_resource_schedules.new send_resource_schedule_params
    
    if @send_resource_schedule.save
      flash[:success] = "troop schedule add success"
      redirect_to my_villages_path
    else
      flash[:fail] = "troop schedule add fail"
      render :new
    end
  end

  def destroy
    @send_resource_schedule.destroy
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

  def send_resource_schedule_params
    params.require(:send_resource_schedule).permit :target_x, :target_y, :wood, :clay, :iron, :paddy, :my_village_id, :market_id
  end

  def load_send_resource_schedule
    @send_resource_schedule = @village.send_resource_schedules.find_by id: params[:id]
    if @send_resource_schedule.nil?
      flash[:dangder] = "không tìm thấy troop chedule"
      redirect_to my_villages_path
    end
  end
end