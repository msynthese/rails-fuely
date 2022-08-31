class StationsController < ApplicationController

  #WORK IN PROGRESS

  def index_map


  #   @stations = StationsServices.find(params[:address])
  #   @markers = @stations.map do |station|
  #     {
  #       lat: station.latitude,
  #       lng: station.longitude,
  #       info_window: render_to_string(partial: "info_window", locals: {station: station})
  #     } #7.inAlainSchema.
  #   end
  end

  def show
    @station = Station.find(params[:id])
  end

end
