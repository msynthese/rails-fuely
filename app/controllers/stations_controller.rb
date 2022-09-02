class StationsController < ApplicationController

  def index
    lat = params["lat"]
    lon = params["lon"]
    @stations = StationsService.find(lat, lon)
    puts(@stations.count)
    @markers = []
    # The `geocoded` scope filters only flats with coordinates
    @markers = @stations.map do |station|
      {
        lat: station["geometry"]["coordinates"][1],
        lng: station["geometry"]["coordinates"][0],
        # info_window: render_to_string(partial: "info_window", locals: { station: station }),
        # image_url: helpers.asset_url("REPLACE_THIS_WITH_YOUR_IMAGE_IN_ASSETS")
      }
    end
    respond_to do |format|
      format.html
      format.json { render json: @markers.to_json }
    end
  end
end
