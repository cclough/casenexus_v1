# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

var markerArray = [];

var customIcons = {
  Beginner: {
    icon: '../images/markers/mark_beginner.png'
  },
  Novice: {
    icon: '../images/markers/mark_novice.png'
  },
  Intermediate: {
    icon: '../images/markers/mark_intermediate.png'
  },
  Advanced: {
    icon: '../images/markers/mark_advanced.png'
  },
  God: {
    icon: '../images/markers/mark_god.png'
  },
  'Victor Cheng-like': {
    icon: '../images/markers/mark_victorchenglike.png'
  }
};

function load_map() {

	//build lat-lng start position!!!
	//if(urlidpre != null) {
	    //var lat_start = ""; 
	       //var lng_start = "";
	//} else {
	    lat_start = 51.501128232665856;
	    lng_start = -0.14241188764572144;
	//}

  	var mapOptions = {
   		center: new google.maps.LatLng(lat_start, lng_start),
	    zoom: 14,
	    mapTypeId: 'roadmap',
		streetViewControl: false,
		mapTypeControl: false,
	    panControlOptions: {
	        //style: google.maps.MapTypeControlStyle.HORIZONTAL_BAR,
	        position: google.maps.ControlPosition.LEFT_CENTER
	    },
	    zoomControlOptions: {
	        //style: google.maps.MapTypeControlStyle.HORIZONTAL_BAR,
	        position: google.maps.ControlPosition.LEFT_CENTER
	    }
	};


	var map = new google.maps.Map(document.getElementById("map"), mapOptions);

	var shadow = new google.maps.MarkerImage('http://www.casenexus.com/images/markers/mark_shadow.png',
	    new google.maps.Size(62.0, 62.0),
	    new google.maps.Point(0, 0),
	    new google.maps.Point(15.0, 62.0)
	    );


	$.getJSON("<%= @json_map %>", function(json) {
	    for (var i = 0; i < json.markers.length; i++) {

      		var point = new google.maps.LatLng(
          		parseFloat(json.markers[i].lat),
          		parseFloat(json.markers[i].lng));          

		    var icon = customIcons[json.markers[i].level] || {};
		    var marker = new google.maps.Marker({
		        map: map,
		        position: point,
		        icon: icon.icon,
		        shadow: shadow,
		        animation: google.maps.Animation.DROP
		    });

      		bindInfo(marker, map, json.markers[i].uid);
      		markerArray[json.markers[i].uid] = marker;

    	}

		//var mcOptions = {gridSize: 50, maxZoom: 15};
		//var markerCluster = new MarkerClusterer(map, markerArray);
  
	});

}

function bindInfo(marker, map, uid) {
  google.maps.event.addListener(marker, 'click', function() {
    showInSidePanel(uid);

    newlatlng = marker.getPosition();
    map.panTo(newlatlng);

    marker.setAnimation(google.maps.Animation.BOUNCE);
    setTimeout(function(){ marker.setAnimation(null); }, 700);

});
  google.maps.event.addListener(marker, 'mouseover', function() {
    //showInSmallPanel(uid);
  });
}

function showInSidePanel(jsonid) {

  	$("#sidepanel").fadeOut('fast', function() {

        $('#sidepanel').load('../map.php?do=user&id=' + jsonid, function() {
             $("#sidepanel").fadeIn('fast');
        });

  	});

}
