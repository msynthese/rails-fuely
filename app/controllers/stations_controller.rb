class StationsController < ApplicationController

  # WORK IN PROGRESS
  def index
    @stations = Station.all
    # The `geocoded` scope filters only flats with coordinates
    @markers = @stations.geocoded.map do |station|
      {
        lat: station.latitude,
        lng: station.longitude,
        info_window: render_to_string(partial: "info_window", locals: { station: station }),
        # image_url: helpers.asset_url("REPLACE_THIS_WITH_YOUR_IMAGE_IN_ASSETS")
      }
    end
  end
end
