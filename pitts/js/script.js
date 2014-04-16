$(document).ready(function () {
	init();
});

var map;

function init() {
	Tabletop.init({
		key: "0AhtG6Yl2-hiRdHBHRkVTRTRjX1RmRzQ0OFlMMGE4a1E",
		callback: initData
	});
}

function initData(result) {
	google.maps.event.addDomListener(window, 'load', initMap);
	function initMap() {
		var styles = [{
			stylers: [{
				hue: "#00ffe6"
			}, {
				saturation: -20
			}]
		}, {
			featureType: "road",
			elementType: "geometry",
			stylers: [{
				lightness: 100
			}, {
				visibility: "simplified"
			}]
		}, {
			featureType: "road",
			elementType: "labels",
			stylers: [{
				visibility: "off"
			}]
		}, {
			featureType: "administrative",
			elementType: "labels",
			stylers: [{
				visibility: "off"
			}]
		}];
		var styledMap = new google.maps.StyledMapType(styles, {
			name: "Styled Map"
		});
		var mapOptions = {
			zoom: 11,
			disableDefaultUI: true,
			center: new google.maps.LatLng(40.4857, -79.9700)
		}
		map = new google.maps.Map($('#map')[0], mapOptions);
		map.mapTypes.set('map_style', styledMap);
		map.setMapTypeId('map_style');
		addMarkers(result.map.elements, true);
	}
}

function addMarkers(data, cluster) {
	markers = [];
	var icon = {
		url: 'img/marker.png',
		size: new google.maps.Size(15, 21),
		origin: new google.maps.Point(0, 0),
		anchor: new google.maps.Point(7, 10)
	};
	data.forEach(function (row) {
		var marker = new google.maps.Marker({
			map: map,
			icon: icon,
			position: new google.maps.LatLng(row.location.split(',')[0], row.location.split(',')[1]),
			title: row.name
		});
		google.maps.event.addListener(marker, 'click', function () {
			zoom(20, this.getPosition(), map);
		});
		markers.push(marker);
	});
	if (cluster) {
		var markerCluster = new MarkerClusterer(map, markers, {
			styles: [{
				url: 'img/circle.png',
				height: 42,
				width: 42
			}]
		});
	}
}

function zoom(n, position) {
	var z = map.getZoom();
	if (z < n) {
		z += 1;
		map.setZoom(z);
		setTimeout(function () {
			zoom(n, position)
		}, 50);
		map.setCenter(position);
	} else if (z > n) {
		z -= 1;
		map.setZoom(z);
		setTimeout(function () {
			zoom(n, position)
		}, 50);
		map.setCenter(position);
	} else {
		map.setCenter(position);
	}
}