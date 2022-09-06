class LocationsController < ApplicationController
  # before_action :set_location, only: %i[show edit update destroy]
  def new
    @location = Location.new
  end

  def create
    location = params[:location]
    location = eval(location)
    params[:location] = location
    @location = Location.new(location_params)
    @location.user = current_user
    @location.address = Geocoder.search([@location.latitude, @location.longitude]).first.address
    if @location.save
      flash[:notice] = "Location Created!"
      redirect_to stations_path
    else
      flash[:alert] = "Location Not Created..."
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
