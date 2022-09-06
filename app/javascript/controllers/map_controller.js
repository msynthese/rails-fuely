import { Controller } from "@hotwired/stimulus"
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"
const options = {
    enableHighAccuracy: true,
    timeout: 5000,
    maximumAge: 0
  };
let latitude = 47.3667
let longitude = 8.5500
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
    longitude = crd.longitude
    latitude = crd.latitude
    // Center the map
    // https://docs.mapbox.com/mapbox-gl-js/api/#map#setcenter
    this.map.setCenter(center);
    const location = {latitude,longitude}
    console.log(location)
    var jsonLocation = JSON.stringify(location)
    console.log(jsonLocation)
    new mapboxgl.Marker({"color":"#FF0000" })
        .setLngLat([ longitude,latitude ])
        //.setPopup(popup) // Add this
        .setPopup(new mapboxgl.Popup().setHTML(`<form action='locations' method='post'><button class='btn btn-outline-warning' type='submit' name='location' value='${jsonLocation}'><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-star" viewBox="0 0 16 16">
        <path d="M2.866 14.85c-.078.444.36.791.746.593l4.39-2.256 4.389 2.256c.386.198.824-.149.746-.592l-.83-4.73 3.522-3.356c.33-.314.16-.888-.282-.95l-4.898-.696L8.465.792a.513.513 0 0 0-.927 0L5.354 5.12l-4.898.696c-.441.062-.612.636-.283.95l3.523 3.356-.83 4.73zm4.905-2.767-3.686 1.894.694-3.957a.565.565 0 0 0-.163-.505L1.71 6.745l4.052-.576a.525.525 0 0 0 .393-.288L8 2.223l1.847 3.658a.525.525 0 0 0 .393.288l4.052.575-2.906 2.77a.565.565 0 0 0-.163.506l.694 3.957-3.686-1.894a.503.503 0 0 0-.461 0z" style="color: yellow"></path>
      </svg></button></form>`))
        .addTo(this.map)
    this.#stationApi(latitude,longitude)
  }

  #error(err) {
    console.warn(`ERROR(${err.code}): ${err.message}`);
  }
}
