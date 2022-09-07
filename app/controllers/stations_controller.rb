require "erb"

class StationsController < ApplicationController
  include ERB::Util
  @var_test = "*****TEST DISPLAY VAR****"
  def index
    lat_origin = params["lat"]
    lon_origin = params["lon"]
    @stations = StationsService.find(lat_origin, lon_origin)

    @preferred_fuel_prices = []
    # The `geocoded` scope filters only flats with coordinates
    @markers = @stations.map do |station|
      # Basic DATA --------------------------------
      basic_station_data = {
        lat: station["geometry"]["coordinates"][1],
        lng: station["geometry"]["coordinates"][0],
        name: station["fields"]["name"],
        brand: station["fields"]["brand"],
        address: station["fields"]["address"],
        city: station["fields"]["city"],
        cp: station["fields"]["cp"],
        fuel: station["fields"]["fuel"],
        shortage: station["fields"]["shortage"],
        last_update: station["fields"]["update"].to_datetime,
        last_update_calc: (DateTime.now - station["fields"]["update"].to_datetime).to_i,
        dist: (station["fields"]["dist"].to_f.round / 1000).round(2),
        services: station["fields"]["services"],
        automate_24_24: station["fields"]["automate_24_24"],
        api_station_id: station["fields"]["id"]
      }

      # Fuels DATA --------------------------------
      fuels = {
        SP98:
          if station["fields"]["price_sp98"].to_f < 0.01
            station["fields"]["price_sp98"].to_f * 1000
          else
            station["fields"]["price_sp98"].to_f
          end,
        SP95:
          if station["fields"]["price_sp95"].to_f < 0.01
            station["fields"]["price_sp95"].to_f * 1000
          else
            station["fields"]["price_sp95"].to_f
          end,
        E10:
          if station["fields"]["price_e10"].to_f < 0.01
            station["fields"]["price_e10"].to_f * 1000
          else
            station["fields"]["price_e10"].to_f
          end,
        E85:
          if station["fields"]["price_e85"].to_f < 0.01
            station["fields"]["price_e85"].to_f * 1000
          else
            station["fields"]["price_e85"].to_f
          end,
        GPLc:
          if station["fields"]["price_gplc"].to_f < 0.01
            station["fields"]["price_gplc"].to_f * 1000
          else
            station["fields"]["price_gplc"].to_f
          end,
        Gazole:
          if station["fields"]["price_gazole"].to_f < 0.01
            station["fields"]["price_gazole"].to_f * 1000
          else
            station["fields"]["price_gazole"].to_f
          end
      }

      # fuels = {
      #   SP98: station["fields"]["price_sp98"].to_f,
      #   SP95: station["fields"]["price_sp95"].to_f,
      #   E10: station["fields"]["price_e10"].to_f,
      #   E85: station["fields"]["price_e85"].to_f,
      #   GPLc: station["fields"]["price_gplc"].to_f,
      #   Gazole: station["fields"]["price_gazole"].to_f
      # }

      # User preference DATA --------------------------------
      user_preference = {
        fuel_name: current_user.fuel_preference,
        fuel_price: fuels[current_user.fuel_preference.to_sym],
        capacity: current_user.capacity
      }
      user_preference[:error_message] = if current_user.fuel_preference.nil?
                                          'set you preferred fuel in your settings'
                                        elsif user_preference[:fuel_price].nil?
                                          "shortage"
                                        end

      # if user_preference[:fuel_price]
      #   average_preferred_fuel(user_preference[:fuel_price].to_f.round(2))
      # end


      # Marker constructor --------------------------------
      marker = basic_station_data.merge(fuels:, user_preference:)
      marker[:info_window] = render_to_string(partial: "info_window", locals: { marker:, lat_origin:, lon_origin: }, formats: [:html])

      marker
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
