require "erb"

class StationsController < ApplicationController
  include ERB::Util

  def index
    lat_origin = params["lat"]
    lon_origin = params["lon"]
    @stations = StationsService.find(lat_origin, lon_origin)

    @markers = []
    # The `geocoded` scope filters only flats with coordinates
    @markers = @stations.map do |station|
    #   station_attr = {
    #     coordinates: {
    #       lat: 'XXX',
    #       lng: 'XXX',
    #     },
    #     name: 'XXX',
    #     brand: 'XXX',
    #     address: 'XXX',
    #     fuels: {
    #       sp98: 'XXX',
    #       sp95: 'XXX',
    #     }
    #   }

    #   user_preferred_fuel_price =
    #     case current_user_attr[:fuel_preference]
    #     when "Gazole"
    #         station["fields"]["price_gazole"]

    #     when "SP98"
    #         station["fields"]["price_sp98"]

    #     when "SP95"
    #       station["fields"]["price_sp95"]

    #     when "E10"
    #       station["fields"]["price_e10"]

    #     when "E85"
    #       station["fields"]["price_e85"]

    #     when "GPLc"
    #       station["fields"]["gplc"]

    #     else
    #         puts "Wrong action"
    # end

    #   else
    #     nil
    #   end
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
        sp95: station["fields"]["price_sp95"],
        e10: station["fields"]["price_e10"],
        e85: station["fields"]["price_e85"], #did not find in API results yet
        gplc: station["fields"]["gplc"],
        fuel: station["fields"]["fuel"],
        shortage: station["fields"]["shortage"],
        last_update: station["fields"]["update"],
        dist: station["fields"]["dist"],
        services: station["fields"]["services"],
        automate_24_24: station["fields"]["automate_24_24"],
        api_station_id: station["fields"]["id"],
        info_window: render_to_string(partial: "info_window", locals: { station:, lat_origin:, lon_origin: }, formats: [:html])
        # image_url: helpers.asset_url("REPLACE_THIS_WITH_YOUR_IMAGE_IN_ASSETS")
        # STORE PREFERRED FUEL TYPE OF CURRENT USER
        preferred_fuel: station["fields"]["price_gazole"]
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
