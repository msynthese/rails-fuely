class StationsService

    # DECOMPO URL:
    # base_url = "https://public.opendatasoft.com/api/records/1.0/search/?dataset=prix_des_carburants_j_7&q=&lang=fr&facet=cp&facet=pop&facet=city&facet=automate_24_24&facet=fuel&facet=shortage&facet=update&facet=services&facet=brand&geofilter.distance="
    # lat = 45.76271976325411%2C
    # lon = +4.83238153948626%2C
    # radius = 3000
    # url = "#{base_url}#{lat}+#{lon}#{radius}"

    # station_serialized = URI.open(url).read
    # station = JSON.parse(station_serialized)

  def self.find(address)
    lat = Geocoder.search(address).first.data['lat']
    lon = Geocoder.search(address).first.data['lon']

    # fetch api
    # parse json
    # 6.inAlainSchema. return stations [{name: "Nom", latitude: 2.3, longitude: 43.432}, ....]
  end

end
