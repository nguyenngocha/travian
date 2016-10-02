class LandsController < ApplicationController
  before_action :load_land, only: [:destroy, :edit, :update]
  before_action :find_village

  def index
    @lands = current_user.lands
  end

  def new
    @land = current_user.lands.new
  end

  def create
    @land = current_user.lands.new land_params
    if @land.save
      flash[:success] = "Add land success!"
      redirect_to lands_path
    else
      render :new
    end
  end

  def update
    if @land.update_attributes land_params
      flash[:success] = "Edit land success!"
      redirect_to lands_path
    else
      load_land
      render :edit
    end
  end

  def destroy
    if @land.destroy
      flash[:success] = "Delete land success"
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

  def land_params
    params.require(:land).permit :coordinate_x, :coordinate_y, :army1,
      :army2, :army3, :army4, :army5, :army6, :army7, :army8, :army9, :army10,
      :army11, :my_village_id
  end

  def find_village
    @my_villages = current_user.my_villages
  end
end
