window.onload=function(){
  //create the map
  var map = L.map('map',{minZoom:13,maxZoom:20});
  map.setView([19.90626, 83.16514],16 );

  //add the osm layer to the map
  //var layer=L.tileLayer.provider('Thunderforest.Transport').addTo(map);

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

  var geoJsonData={
    "type":"Feature",
    "properties":{
      "color":"red",
      "name" : "bhawanipatna",
      "popupContent":"Bhawanipatna"
      },
    "geometry":{
      "type":"Point",
      "coordinates":
            [ 83.16691,19.90734],


      }
  };
//alert(map.getZoom());


//L.geoJson().addTo(map);


var nstyle={
  color: "#ff00ff",
  fillColor: "#007800",
  weight: 1,
  opacity: .5,
  fillOpacity: 0.1
  }

var styleFunc=function(feature){
    //for out lines
    if (feature.properties.name=="Bhawanipatna"){
      nstyle.color="#0000ff";
      nstyle.fillColor="#ffff00";
      nstyle.weight=1;
      nstyle.opacity= .1;
      nstyle.fillOpacity=.1;
      return nstyle;
    }
    //for wood
    if (feature.properties.natural=="wood"){
      nstyle.color="#0000ff";
      nstyle.fillColor="#00ff00";
      nstyle.weight=3;
      nstyle.opacity= .1;
      nstyle.fillOpacity=.1;
      return nstyle;
    }
    //tertiary nh 201
    if (feature.properties.highway=="trunk"){
      nstyle.color="#e0e000";
      nstyle.fillColor="#00ffff";
      nstyle.weight=6;
      nstyle.opacity= .8;
      nstyle.fillOpacity=1;
      return nstyle;
    }
    //tertiary sh 16
    if (feature.properties.highway=="primary"){
      nstyle.color="#e000e0";
      nstyle.fillColor="#00ffff";
      nstyle.weight=4;
      nstyle.opacity= .8;
      nstyle.fillOpacity=1;
      return nstyle;
    }
    //college road
    if (feature.properties.highway=="secondary"){
      nstyle.color="#f05050";
      nstyle.fillColor="#00ffff";
      nstyle.weight=3;
      nstyle.opacity= .8;
      nstyle.fillOpacity=1;
      return nstyle;
    }
    //for water
    //for wood
    if (feature.properties.natural=="water" || feature.properties.waterway=="stream" ){
      nstyle.color="#0080ff";
      nstyle.fillColor="#0080ff";
      nstyle.weight=1;
      nstyle.opacity= .5;
      nstyle.fillOpacity=.5;
      return nstyle;
    }
    else {
      nstyle.color="#ffffff";
      nstyle.fillColor="#0fff60";
      nstyle.weight=2;
      nstyle.opacity= .8;
      nstyle.fillOpacity=.1;
      return nstyle;
    }

}

var geojsonMarkerOptions = {
    radius: 5,
    fillColor: "#ff7800",
    color: "#000000",
    weight: 1,
    opacity: 1,
    fillOpacity: 0.8
};
var onEachFeature=function(feature,layer){
  if(feature.properties.name)
  layer.bindPopup(feature.properties.name);
}
var PtoL=function (feature, latlng) {
    return L.circleMarker(latlng, geojsonMarkerOptions);

}

var geoLayer=L.geoJson(data, {
    style:styleFunc,
  //  pointToLayer:PtoL ,
    onEachFeature: onEachFeature

}).addTo(map);

//adding popup

var popup=L.popup();


var callback=function(e){
  popup
    .setContent(e.latlng.toString())
    .setLatLng(e.latlng)
    .openOn(map);
}
//map.on("click",callback);

//data processing
var roads=[];
var others=[];
for (var i= 0;i<data.features.length;i++){
  if (data.features[i].properties.highway == "residential"){
    roads.push(data.features[i]);
  }
  if(data.features[i].properties.highway != "residential" &&
   data.features[i].properties.highway != "tertiary" &&
   data.features[i].properties.highway !="unclassified" &&
   data.features[i].properties.highway != "residential" &&
    data.features[i].properties.power != "tower"
   ) {
    others.push(data.features[i]);
  }

}
var others_geojson={
  "type": "FeatureCollection",
  "features": others
}


//zoom
var onZoomend = function(e){
  if (map.getZoom()<15){
    geoLayer.clearLayers();
    geoLayer.addData(others_geojson);
  }

  if (map.getZoom()>=15){
    geoLayer.clearLayers();
    geoLayer.addData(data);
  }

}
map.on('zoomend', onZoomend);
//adding a canvas
var t=0;
var BigPointLayer = L.CanvasLayer.extend({

      render: function() {
        var canvas = this.getCanvas();
        var ctx = canvas.getContext('2d');
        // clear canvas
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        // get center from the map (projected)
        var point = this._map.latLngToContainerPoint(new L.LatLng(19.90626, 83.16514));
        // render
        ctx.fillStyle="#aca4a4";
        ctx.font="40px Verdana";
        ctx.fillText("Bhawanipatna",window.innerWidth*0.4	,window.innerHeight*0.1);
        ctx.fill();


      }
    });
    var layer = new BigPointLayer();
    layer.addTo(map);


}
