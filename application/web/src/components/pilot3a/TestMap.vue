<!-- eslint-disable no-mixed-spaces-and-tabs -->

<template>
	<div class = "parent">
		<div id="mapContainer" class="map"></div>
	</div>
</template>

<script>
import L from 'leaflet';
import "leaflet/dist/leaflet.css";

import puiEventsBus from '../../bus'

export default {
	name: 'TestMap',
	props: {
		geoData: Object,
		geoValue: Object
	},
	data() {
		return {
			map: {},
			geoJson: {},
			geoLayerGroup: new L.LayerGroup(),
			info: L.control(),
			center: [51.9, 19.14],
			style: {},
			numberOrPercentageMap: 0,
			compliantOrOutlierMap: 0
		}
	},
	methods: {
		setupUeMap: function () {
			this.map = L.map("mapContainer").setView(this.center, 3);
			L.tileLayer("https://a.tile.openstreetmap.org/{z}/{x}/{y}.png", {
				attribution: 'Map data (c) <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors',
				maxZoom: 19,
			}).addTo(this.map);
		},

		getColor: function (d) {
			if (this.numberOrPercentageMap == 0 && this.compliantOrOutlierMap == 0){ //Compliant in numbers
				const letters = '0123456789ABCDEF';
				let color = '#';
				for (let i = 0; i < 6; i++) {
					color += letters[Math.floor(Math.random() * 16)];
				}
				return color
			}
			else if (this.numberOrPercentageMap == 0 && this.compliantOrOutlierMap == 1){
				return d > 4000 ? '#E91C1C' :
						d > 1000 ? '#E8691D' :
							d > 400 ? '#E8971D' :
								d > 100 ? '#E8bA1D' :
									d > 50 ? '#E8d91D' :
										d > 20 ? '#44f8EA' :
											d > 10 ? '#44B4F8' :
												d >= 1 ? '#44B4F8' :
													'#008000'
			}
			else if (this.numberOrPercentageMap == 1 && this.compliantOrOutlierMap == 0){ //Compliant in percentage
				return d == 100 ? '#008000' :
						d > 99 ? '#35E416' :
								d > 97 ? '#D0F456' :
									d > 95 ? '#C5CA15' :
										d > 90 ? '#F8F844' :
											d > 80 ? '#E8971D' :
												d > 60 ? '#D97149' : '#E91C1C'
			}
			else{ // Outlier in percentage
				return d == 0 ? '#008000' :
					d < 1 ? '#35E416' :
							d < 3 ? '#D0F456' :
								d < 5 ? '#C5CA15' :
									d < 10 ? '#F8F844' :
										d < 20 ? '#E8971D' :
											d < 40 ? '#D97149' : '#E91C1C'
			}
		},

		onEachFeature: function (feature, layer) {
			layer.on({
				mouseover: this.highlightFeature,
				mouseout: this.resetHighlight,
				click: this.zoomToFeature
			});
		},

		highlightFeature: function (e) {
			var layer = e.target;

			layer.setStyle({
				weight: 5,
				color: '#666',
				dashArray: '',
				fillOpacity: 0.7
			});

			if (!L.Browser.ie && !L.Browser.opera && !L.Browser.edge) {
				layer.bringToFront();
			}
			this.info.update(layer.feature.properties, this.numberOrPercentageMap);
		},

		resetHighlight: function (e) {
			this.geoJson.resetStyle(e.target);
			this.info.update();
		},

		zoomToFeature: function (e) {
			this.map.fitBounds(e.target.getBounds());
		},

		customControl: function (map) {
			this.info.onAdd = function () {
				this._div = L.DomUtil.create('div', 'info'); // create a div with a class "info"
				this.update();
				return this._div;
			};

			// method that we will use to update the control based on feature properties passed
			this.info.update = function (props, numberOrPercentageMap) {
				let suffix = numberOrPercentageMap == 0 ? '' : '%'
				this._div.innerHTML = '<h4>Vehicles</h4>' + (props ?
					'<b>' + props.name + '</b><br />' + props.value + suffix + ' </sup>'
					: 'Hover over a state');
			};
			this.info.addTo(map);
		},

		updateGeoData: function (geoData, geoValues) {
			geoData.features.forEach((element, index) => {
				element.properties.value = geoValues.features[index].value
			})
			return geoData
		},

		styleFunction: function (feature) {
			return {
				fillColor: this.getColor(feature.properties.value),
				weight: 2,
				opacity: 1,
				color: 'white',
				dashArray: '3',
				fillOpacity: 0.7
			};
		},

		updateChart: function (geoData, geoValues, numberOrPercentageMap, compliantOrOutlierMap) {
			this.numberOrPercentageMap = numberOrPercentageMap
			this.compliantOrOutlierMap = compliantOrOutlierMap
			geoData = this.updateGeoData(geoData, geoValues)
			this.map.removeLayer(this.geoJson)
			this.geoJson = L.geoJSON(geoData, { style: this.styleFunction, onEachFeature: this.onEachFeature }).addTo(this.map)
			this.geoLayerGroup.addLayer(this.geoJson)
		}
	},

	mounted() {
		puiEventsBus.$on('updateChart', (data) => {
			this.updateChart(data.geoData, data.geoValues, data.numberOrPercentageMap, data.compliantOrOutlierMap)
		})
		//this.style = {fillColor: this.getColor(Math.random()*1200),
		this.style = {
			fillColor: this.getColor(Math.random() * 1200),
			weight: 2,
			opacity: 1,
			color: 'white',
			dashArray: '3',
			fillOpacity: 0.7
		}
		this.setupUeMap();
		this.geoLayerGroup.addTo(this.map)
		this.geoJson = L.geoJSON(this.geoData, { style: this.style, onEachFeature: this.onEachFeature }).addTo(this.map)
		this.geoLayerGroup.addLayer(this.geoJson)
		this.customControl(this.map);
	},
	beforeDestroy() {
		puiEventsBus.$off('updateChart')
	}
};
</script>

<style>
.parent {
position: relative;
   width: 100%;
   height: 100%;
}

#mapContainer {
	width: 100%;
	height: 45vh;
	/* position: absolute;
    height: 450px;
	width: 450px; */
}

.info {
	padding: 6px 8px;
	font: 14px/16px Arial, Helvetica, sans-serif;
	color: black;
	background-color: rgb(98, 134, 146);
	box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
	border-radius: 5px;
}

.info h4 {
	margin: 0 0 5px;
	color: white
}

.leaflet-layer {
	position: relative;
	left: 0;
	top: 0;
}

</style>
