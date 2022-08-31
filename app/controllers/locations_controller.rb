class LocationsController < ApplicationController
  # before_action :set_location, only: %i[show edit update destroy]

  def create
    @location = Location.new(location_params)
    if @location.save
      flash[:notice] = "Location Created!"
      redirect_to locations_path
    else
      flash[:notice] = "Location Not Created..."
      puts location.errors.messages
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @locations = current_user.locations
  end

  private

  def location_params
    params.require(:location).permit(:name, :adress, :latitude, :longitude)
  end

  # method useful for show edit update and destroy
  # def set_location
  #   @location = Location.find(params[:id])
  # end
end
