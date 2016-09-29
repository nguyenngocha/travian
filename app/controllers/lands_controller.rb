class LandsController < ApplicationController
  before_action :load_land, only: [:destroy, :edit, :update]

  def index
    @lands = Land.all
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

  def land_params
    params.require(:land).permit :type_id, :coordinate_x, :coordinate_y
  end
end
