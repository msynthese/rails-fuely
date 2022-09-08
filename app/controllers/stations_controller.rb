require "erb"

class StationsController < ApplicationController
  include ERB::Util

  def index
    lat_origin = params["lat"]
    lon_origin = params["lon"]
    @stations = StationsService.find(lat_origin, lon_origin)

    # FILTER MARKERS ON FUEL TYPE
    @stations = @stations.select do |station|
      (current_user.brand_preference == station["fields"]["brand"] || current_user.brand_preference == "All") && station["fields"]["price_#{current_user.fuel_preference.downcase}"].present?
    end

    puts "*******@STATIONS CHECK AFTER FILTER ON FUEL TYPE********"
    puts @stations

    # AVERAGE PREFERRED FUEL PRICE
    puts "********CHECK @stations before MAP preferred_fuel_prices***********"
    puts @stations

    preferred_fuel_prices = @stations.map do |s|
      # puts s.inspect
      if s["fields"]["price_#{current_user.fuel_preference.downcase}"].to_f < 0.01
        s["fields"]["price_#{current_user.fuel_preference.downcase}"].to_f * 1000
      else
        s["fields"]["price_#{current_user.fuel_preference.downcase}"].to_f
      end
    end

    average = (preferred_fuel_prices.sum / @stations.count).round(3) if @stations.any?
    best_price = preferred_fuel_prices.min

    puts "****CHECK ARRAY preferred_fuel_prices******"
    puts preferred_fuel_prices

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

      # User preference DATA --------------------------------
      user_preference = {
        fuel_name: current_user.fuel_preference,
        fuel_price: fuels[current_user.fuel_preference.to_sym],
        capacity: current_user.capacity,
        preferred_fuel_average: average,
        preferred_fuel_best_price: best_price
      }

      # Calcuation DATA
      fillup_calc = (current_user.capacity * (average - user_preference[:fuel_price])).round(3)
      calcul = {
        per_fillup: fillup_calc,
        per_fillup_text:
          if fillup_calc.positive?
            "Saving"
          else
            "Loss"
          end,
      }

      user_preference[:error_message] = if current_user.fuel_preference.nil?
                                          'set your fuel'
                                        elsif user_preference[:fuel_price].nil?
                                          "shortage"
                                        end

      # Marker constructor --------------------------------
      marker = basic_station_data.merge(fuels:, user_preference:, calcul:)
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
