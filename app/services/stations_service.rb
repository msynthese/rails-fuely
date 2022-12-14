require "json"
require "open-uri"

class StationsService

    # DECOMPO URL:
    # base_url = "https://public.opendatasoft.com/api/records/1.0/search/?dataset=prix_des_carburants_j_7&q=&lang=fr&facet=cp&facet=pop&facet=city&facet=automate_24_24&facet=fuel&facet=shortage&facet=update&facet=services&facet=brand&geofilter.distance="
    # lat = 45.76271976325411%2C
    # lon = +4.83238153948626%2C
    # radius = 3000
    # url = "#{base_url}#{lat}+#{lon}#{radius}"

    # station_serialized = URI.open(url).read
    # station = JSON.parse(station_serialized)

  def self.find(lat, lon)

    # fetch api
    # url = "https://public.opendatasoft.com/api/records/1.0/search/?dataset=prix_des_carburants_j_7&q=&lang=fr&facet=cp&facet=pop&facet=city&facet=automate_24_24&facet=fuel&facet=shortage&facet=update&facet=services&facet=brand&geofilter.distance=#{lat.to_f}%2C+#{lon.to_f}%2C3000"
    # url = "https://data.economie.gouv.fr/api/records/1.0/search/?dataset=prix-carburants-fichier-quotidien-test-ods&q=&facet=prix_maj&facet=prix_nom&facet=com_arm_name&facet=epci_name&facet=dep_name&facet=reg_name&facet=services_service&facet=rupture_nom&facet=rupture_debut&facet=horaires_automate_24_24&geofilter.distance=#{lat.to_f}%2C#{lon.to_f}%2C3000"
    url = "https://public.opendatasoft.com/api/records/1.0/search/?dataset=prix_des_carburants_j_7&q=&lang=fr&facet=cp&facet=pop&facet=city&facet=automate_24_24&facet=fuel&facet=shortage&facet=update&facet=services&facet=brand&facet=ville&facet=adresse&geofilter.distance=#{lat.to_f}%2C+#{lon.to_f}%2C15000"
    stations_serialized = URI.open(url).read

    # parse json
    stations = JSON.parse(stations_serialized)
    # 6.inAlainSchema. return stations [{name: "Nom", latitude: 2.3, longitude: 43.432}, ....]
    return stations["records"]
  end

end
