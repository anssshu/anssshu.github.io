window.onload=function(){
/* Notes
  //create a tileLayer
  L.tileLayer('http://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',{
    attribution:'&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>, Tiles courtesy of <a href="http://hot.openstreetmap.org/" target="_blank">Humanitarian OpenStreetMap Team</a>',
    maxZoom:18,
    minZoom:12,

  }).addTo(map);

*/

  //create a map and set its view
  var bpt=[19.90626, 83.16514];
  var options={maxZoom:18,minZoom:10};

  var map=L.map("map",options);
  map.setView(bpt,15);


  //add a openstreet map layer
  var  osmLayer= L.tileLayer.provider('OpenStreetMap.HOT').addTo(map);

  //add a marker
  var somnath = L.icon({
      iconUrl: 'resturant.png',
      shadowUrl: '',

      iconSize:     [32, 43], // size of the icon
      shadowSize:   [0, 0], // size of the shadow
      iconAnchor:   [15, 44], // point of the icon which will correspond to marker's location
      shadowAnchor: [4, 62],  // the same for the shadow
      popupAnchor:  [2, -36] // point from which the popup should open relative to the iconAnchor
  })
var marker = L.marker([19.90626, 83.16514],{icon:somnath}).bindPopup("Hotel Somnath").addTo(map);
marker.openPopup();
  //add a pop up
 

  
 

  

}
