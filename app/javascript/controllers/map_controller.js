import { Controller } from "@hotwired/stimulus"
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"
const options = {
    enableHighAccuracy: true,
    timeout: 5000,
    maximumAge: 0
  };
let lat = 47.3667
let lon = 8.5500
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  initialize() {
    mapboxgl.accessToken = this.apiKeyValue
    navigator.geolocation.getCurrentPosition((pos) => this.#success(pos,this), this.#error, options)
  }
  connect() {

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10",
      center: [lon, lat],
      zoom: 12
    })
    // this.#fitMapToMarkers()
    this.geocoder = new MapboxGeocoder({ accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl })

    this.geocoder.on('result', (e) => {
      const coord = e.result.geometry.coordinates
      const lat = coord[1]
      const lon = coord[0]
      this.#stationApi(lat,lon)
    })

    // this.#addMarkersToMap(this.markersValue)
    this.map.addControl(this.geocoder)
  }
  #stationApi(lat,lon) {
    fetch(`/stations.json?lat=${lat}&lon=${lon}`,{ headers: {
        'Content-Type': 'application/json'
      }})
      .then(data => data.json())
      .then(data => {
        this.#addMarkersToMap(data.markers)
        document.getElementById("station-list").innerHTML = data.list
       } )
  }
  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }

  }

  #addMarkersToMap(markers) {
    markers.forEach((marker) => {
     const popup = new mapboxgl.Popup().setHTML(marker.info_window) // Add this

          // Create a HTML element for your custom marker
      // const customMarker = document.createElement("div")
      // customMarker.className = "marker"
      // customMarker.style.backgroundImage = `url('${marker.image_url}')`
      // customMarker.style.backgroundSize = "contain"
      // customMarker.style.width = "25px"
      // customMarker.style.height = "25px"

       // Pass the element as an argument to the new marker
      new mapboxgl.Marker()
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup) // Add this
        .addTo(this.map)
    });
  }

  #success(pos) {
    const crd = pos.coords;

    const center = new mapboxgl.LngLat(crd.longitude, crd.latitude);
    lon = crd.longitude
    lat = crd.latitude
    console.log({lon})
    console.log({lat})
    // Center the map
    // https://docs.mapbox.com/mapbox-gl-js/api/#map#setcenter
    this.map.setCenter(center);
    new mapboxgl.Marker({"color":"#FF0000" })
        .setLngLat([ lon,lat ])
        //.setPopup(popup) // Add this
        .addTo(this.map)
    this.#stationApi(lat,lon)
  }

  #error(err) {
    console.warn(`ERROR(${err.code}): ${err.message}`);
  }
}
