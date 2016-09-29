class LandsController < ApplicationController
  before_action :check_login
  before_action :load_land, only: [:destroy, :edit, :update]
  before_action :load_village, only: [:destroy, :edit, :update, :new]

  def index
    @lands = current_user.lands
  end

  def new
    @land = Land.new
  end
  
  def create
    @land = Land.new land_params
    if @land.save
      flash[:success] = "Add land success!"
      redirect_to lands_path
    else
      load_village      
      render :new
    end
  end

  def update
    if @land.update_attributes land_params
      flash[:success] = "Edit land success!"
      redirect_to lands_path
    else
      load_land
      load_village
      render :edit
    end 
  end

  def destroy
    if @land.destroy
      flass[:success] = "delete land success"
      redirect_to lands_path
    end
  end

  private
  def load_land
    @land = Land.find_by_id params[:id]
    if @land.nil?
      flash[:danger] = "land not found"
      redirect_to lands_path
    end
  end
  def load_village
    @my_villages = current_user.my_villages.map{|vl| [vl.name, vl.id]} 
  end

  def land_params
    params.require(:land).permit :coordinate_x, :coordinate_y, :user_id,
      :army1, :army2, :army3, :army4, :army5, :army6, :army7, :army8, :army9, 
      :army10, :army11
  end

  def check_login
    redirect_to login_path unless current_user
  end
end
