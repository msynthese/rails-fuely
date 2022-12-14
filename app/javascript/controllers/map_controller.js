import { Controller } from "@hotwired/stimulus"
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"
const options = {
    enableHighAccuracy: true,
    timeout: 5000,
    maximumAge: 0
  };
let latitude = 46.53226792003686
let longitude = 6.592254569225835
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
      center: [longitude, latitude],
      zoom: 12
    })
    // this.#fitMapToMarkers()
    this.geocoder = new MapboxGeocoder({ accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl })

    this.geocoder.on('result', (e) => {
      const coord = e.result.geometry.coordinates
      const latitude = coord[1]
      const longitude = coord[0]
      this.#stationApi(latitude,longitude)
    })

    // this.#addMarkersToMap(this.markersValue)
    this.map.addControl(this.geocoder)
  }
  #stationApi(latitude,longitude) {
    fetch(`/stations.json?lat=${latitude}&lon=${longitude}`,{ headers: {
        'Content-Type': 'application/json'
      }})
      .then(data => data.json())
      .then(data => {
        this.#addMarkersToMap(data.markers)
        const stationList = document.getElementById("station-list")
        if (stationList) {
          stationList.innerHTML = data.list
        }
      } )
  }
  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }



  #addMarkersToMap(markers) {
    markers.forEach((marker) => {
      console.log("marker")
      const popup = new mapboxgl.Popup().setHTML(marker.info_window) // Add this

          // Create a HTML element for your custom marker
      // const customMarker = document.createElement("div")
      // customMarker.className = "marker"
      // customMarker.style.backgroundColor =
      // customMarker.style.backgroundSize = "contain"
      // customMarker.style.width = "25px"
      // customMarker.style.height = "25px"

       // Pass the element as an argument to the new marker
      if (marker.user_preference.fuel_price > marker.user_preference.preferred_fuel_average){
        console.log(marker.user_preference)
        new mapboxgl.Marker({color: "#F96849"})
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup) // Add this
        .addTo(this.map)
      } else {
        if (marker.user_preference.fuel_price == marker.user_preference.preferred_fuel_best_price){
          new mapboxgl.Marker({color: "#1BFC04"})
          .setLngLat([ marker.lng, marker.lat ])
          .setPopup(popup) // Add this
          .addTo(this.map)
        } else {
          new mapboxgl.Marker({color: "#04FCDB"})
          .setLngLat([ marker.lng, marker.lat ])
          .setPopup(popup) // Add this
          .addTo(this.map)
        };
      };
    });
  }

  #success(pos) {
    const crd = pos.coords;
    const center = new mapboxgl.LngLat(crd.longitude, crd.latitude);
    longitude = crd.longitude
    latitude = crd.latitude
    // Center the map
    // https://docs.mapbox.com/mapbox-gl-js/api/#map#setcenter
    this.map.setCenter(center);
    const location = {latitude,longitude}
    var jsonLocation = JSON.stringify(location)
    new mapboxgl.Marker({"color":"#FF0000" })
        .setLngLat([ longitude,latitude ])
        //.setPopup(popup) // Add this
        .setPopup(new mapboxgl.Popup().setHTML(`<form action='locations' method='post'><button class='favorite' type='submit' name='location' value='${jsonLocation}'></button></form>`))
        .addTo(this.map)
    this.#stationApi(latitude,longitude)
  }

  #error(err) {
    console.warn(`ERROR(${err.code}): ${err.message}`);
  }
}
