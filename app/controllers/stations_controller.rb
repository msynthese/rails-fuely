class StationsController < ApplicationController

  def index
    lat = params["lat"]
    lon = params["lon"]
    @stations = StationsService.find(lat, lon)

    @markers = []
    # The `geocoded` scope filters only flats with coordinates

    @markers = @stations.map do |station|
      {
        lat: station["geometry"]["coordinates"][1],
        lng: station["geometry"]["coordinates"][0],
        name: station["fields"]["name"],
        brand: station["fields"]["brand"],
        address: station["fields"]["address"],
        city: station["fields"]["city"],
        cp: station["fields"]["cp"],
        gazole: station["fields"]["price_gazole"],
        sp98: station["fields"]["price_sp98"],
        e10: station["fields"]["price_e10"],
        fuel: station["fields"]["fuel"],
        shortage: station["fields"]["shortage"],
        last_update: station["fields"]["update"],
        dist: station["fields"]["dist"],
        automate_24_24: station["fields"]["automate_24_24"],
        api_station_id: station["fields"]["id"]
        # info_window: render_to_string(partial: "info_window", locals: { station: station }),
        # image_url: helpers.asset_url("REPLACE_THIS_WITH_YOUR_IMAGE_IN_ASSETS")
      }

    end

    list_string = render_to_string partial: 'list_stations', locals: { markers: @markers }, formats: [:html]
    respond_to do |format|
      format.html
      format.json { render json: {
        markers: @markers,
        list: list_string
      }}
    end

  end
end
