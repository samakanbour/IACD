$(document).ready(function () {
	init();
	setTimeout(function () {
		$('.odometer').html(327012);
	}, 1000);
});

function init() {
	Tabletop.init({
		key: "0AhtG6Yl2-hiRdFF1d21nVnVmQmp5X25ha0hzbTV1OFE",
		callback: initData
	});
}

function initData(result) {
	var pieData = [{
		key: "Food",
		y: .25 * 1535.25
	}, {
		key: "Housing",
		y: .04 * 1535.25
	}, {
		key: "Clothes",
		y: .48 * 1535.25
	}, {
		key: "Health",
		y: .07 * 1535.25
	}, {
		key: "Beauty",
		y: .10 * 1535.25
	}, {
		key: "Education",
		y: .01 * 1535.25
	}, {
		key: "Fun",
		y: .05 * 1535.25
	}];
	createPie(pieData);
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
			center: new google.maps.LatLng(40.4717, -79.9700)
		}
		var map = new google.maps.Map($('#map')[0], mapOptions);
		map.mapTypes.set('map_style', styledMap);
		map.setMapTypeId('map_style');
		addMarkers(result.map.elements, map, true);
	}
	var chartData = [{
		key: 'Steps',
		values: [],
		type: 'bar',
		yAxis: 2
	}, {
		key: 'Spendings',
		values: [],
		type: 'line',
		yAxis: 1
	}];
	result.steps.elements.forEach(function (row) {
		chartData[0].values.push({
			x: parseInt(row.id),
			y: parseInt(row.steps)
		});
		chartData[1].values.push({
			x: parseInt(row.id),
			y: parseInt(row.spendings)
		});
	});
	nv.addGraph(function () {
		var chart = nv.models.multiChart()
			.margin({
				top: 20,
				right: 30,
				bottom: 3,
				left: 30
			})
			.color(["rgba(0, 255, 230, .4)", "rgba(180, 219, 216, 1)"]);
		d3.select('#chart')
			.datum(chartData)
			.transition().duration(500).call(chart);
		return chart;
	});
}

function addMarkers(data, map, cluster) {
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
			position: new google.maps.LatLng(row.latitude, row.longitude),
			title: row.title
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

function zoom(n, position, map) {
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

function createPie(data) {
	nv.addGraph(function () {
		var width = 320,
			height = 350;
		var chart = nv.models.pieChart()
			.x(function (d) {
				return d.key
			})
			.color(["rgba(0, 255, 230, .2)", "rgba(0, 255, 230, .3)", "rgba(0, 255, 230, .4)", "rgba(0, 255, 230, .5)", "rgba(0, 255, 230, .6)", "rgba(0, 255, 230, .7)", "rgba(0, 255, 230, .8)"])
			.width(width)
			.height(height)
			.donut(true);
		chart.pie
			.startAngle(function (d) {
				return d.startAngle / 2 - Math.PI / 2
			})
			.endAngle(function (d) {
				return d.endAngle / 2 - Math.PI / 2
			});
		d3.select("#pie")
			.datum(data)
			.transition().duration(1200)
			.attr('width', width)
			.attr('height', height)
			.call(chart);
		return chart;
	});
}