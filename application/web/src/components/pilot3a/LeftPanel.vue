<template>
	<v-col class="justify-center limits" cols="6">
		<v-row>
			<h2 class="font-weight-bold text-center mb-6">
				Monitored region
			</h2>
		</v-row>
		<v-row justify="left">
			<v-radio-group v-model="radios" class="ml-3">
				<v-row class="fleetrow">
					<v-radio value="fleet" @change="changeView('all')">
						<template v-slot:label>
							<h4>{{ $t('pilot3a.letfPanel.entireFleet')}}</h4>
						</template>
					</v-radio>
				</v-row>
				<v-row class="subfleetrow">
					<v-radio value="subfleet" @change="changeView('subfleet')">
						<template v-slot:label>
							<h4>{{ $t('pilot3a.letfPanel.subFleet')}}</h4>
						</template>
					</v-radio>
					<v-select class="subfleet ml-4" v-if="this.radios == 'subfleet'" :items=subfleetList 
						:no-data-text="$t('car.group.noData')"
						item-text="subfleet" item-value="subfleet" v-model="subfleet" @change="changeView('subfleet')"
						density="compact" width="40px">
					</v-select>
				</v-row>
			</v-radio-group>
		</v-row>

		<v-row justify="center">
			<TestMap />
		</v-row>

		<v-row justify="space-between">
			<div>
				<v-btn v-for="(car, i) in cars" :key="car.type" @click="selectCars(i)" color="black--text"
					class="subheading mr-3 mt-1 mb-6" :class="[compliantOrOutlierMap == i ? 'carSelected' : '']"
					target="_blank">
					{{ car.text }}
				</v-btn>
			</div>
			<div>
				<v-btn v-for="(item, i) in represented" :key="item.as" @click="selectRepresentation(i)" color="black--text"
					class="subheading ml-3 mt-1 mb-6" :class="[numberOrPercentageMap == i ? 'carSelected' : '']"
					target="_blank">
					{{ item.text }}
				</v-btn>
			</div>
		</v-row>
	</v-col>
</template>

<script>
import TestMap from "./TestMap.vue";
import puiEventsBus from '../../bus';
import backendCall from '../../services/backendCalls';
import europeGeoJSONData from "../../assets/europe.geo.json";
// const carsIndex = (process.env.CAR_INDEX) ? process.env.CAR_INDEX : 'new_cars';

export default {
	name: "LeftPanel",
	components: {
		TestMap,
	},

	data: () => ({
		radios: "fleet",
		subfleet: "001",
		subfleetList: [],
		compliantOrOutlierMap: 0,
		numberOrPercentageMap: 0,
		compliants: {},
		outliers: {},
		compliantsPer: {},
		outliersPer: {},
		cars: [
			{
				type: "compliant",
				text: "Compliant",
			},
			{
				type: "outliers",
				text: "Outliers",
			},
		],
		represented: [
			{
				as: "number",
				text: "N",
			},
			{
				as: "percentage",
				text: "%",
			},
		]
	}),

	mounted() {
		this.LTSEData();
		this.getList();
	},

	methods: {
		changeView: function (scope) {
			this.$store.commit('changeView', scope == 'all' ? 'all' : this.subfleet);
			puiEventsBus.$emit("changeFleet");
			this.LTSEData();
		},

		async getList(){
			this.$puiRequests.getRequest(
				'/car/group',
				null,
				(response) => {
					console.log(response)
					for(let group of response.data) {
						let groupArray = group.id.split(":")
						let groupName = groupArray[groupArray.length - 1]
						this.subfleetList.push(groupName)
						} 
					this.progress = false;
				},
				() => {
					this.progress = false;
				}
			);
		},
		async LTSEData() {
			let countries_list = ["France", "Estonia", "Ukraine", "Latvia", "Belarus", "Norway", "Lithuania", "Russia", "Czech Republic", "Germany", "Sweden", "Denmark", "Finland", "Luxembourg", "Belgium", "North Macedonia", "Albania", "Kosovo", "ES", "Romania", "Hungary", "Italy", "Slovakia", "Poland", "Ireland", "United Kingdom", "Greece", "Austria", "Netherlands", "Switzerland", "Serbia", "Montenegro", "Croatia", "Slovenia", "Bulgaria", "Moldova", "Bosnia and Herzegovina", "Portugal", "Iceland"]
			var compliants = {
				"type": "CarsInEurope",
				"features": new Array(39)
			};
			var outliers = {
				"type": "CarsInEurope",
				"features": new Array(39)
			};
			var compliantsPer = {
				"type": "CarsInEurope",
				"features": new Array(39)
			};
			var outliersPer = {
				"type": "CarsInEurope",
				"features": new Array(39)
			};

			let response = await backendCall.getLTSEData("data_per_country", this.$store.state.pilot3a.subfleet);
			let country_keys = Object.keys(response.values);
			for (let i = 0; i < countries_list.length; i++) {
				let country = countries_list[i];
				let index = country_keys.indexOf(country);
				if (index == -1) {
					compliants.features[i] = {
						"region": countries_list[i],
						"value": 0
					}
					outliers.features[i] = {
						"region": countries_list[i],
						"value": 0
					}
					compliantsPer.features[i] = {
						"region": countries_list[i],
						"value": 100
					}
					outliersPer.features[i] = {
						"region": countries_list[i],
						"value": 0
					}
				} else {
					let compliantCars = response.values[country].total - response.values[country].outliers;
					compliants.features[i] = {
						"region": country,
						"value": compliantCars
					}
					outliers.features[i] = {
						"region": country,
						"value": response.values[country].outliers
					}
					compliantsPer.features[i] = {
						"region": country,
						"value": 100 * compliantCars / response.values[country].total
					}
					outliersPer.features[i] = {
						"region": country,
						"value": 100 * response.values[country].outliers / response.values[country].total
					}
				}
			}
			this.compliants = compliants;
			this.outliers = outliers;
			this.compliantsPer = compliantsPer;
			this.outliersPer = outliersPer;
			this.changeGeoData();
		},

		changeGeoData: function () {
			puiEventsBus.$emit("updateChart", {
				geoData: europeGeoJSONData,
				geoValues: this.compliantOrOutlierMap == 0 ?
					this.numberOrPercentageMap == 0 ? this.compliants : this.compliantsPer
					: this.numberOrPercentageMap == 0 ? this.outliers : this.outliersPer,
				numberOrPercentageMap: this.numberOrPercentageMap,
				compliantOrOutlierMap: this.compliantOrOutlierMap
			});
		},
		selectCars: function (i) {
			this.compliantOrOutlierMap = i;
			this.changeGeoData();

		},
		selectRepresentation: function (i) {
			this.numberOrPercentageMap = i;
			this.changeGeoData();
		}
	}

};
</script>

<style scoped>
.limits {
	margin: 20px !important;
}

.scope {
	min-width: 400%;
}

.subfleetrow {
	height: 54px;
	min-height: 54px;
}

.subfleet {
	width: 100px;
	max-width: 100px;
	padding-top: 0 !important;
	margin-top: 0 !important;
	z-index: 10000;
}

.v-messages {
	max-height: 0 !important;
	height: 0 !important;
}

.optionSelected {
	background-color: #863659 !important;
	color: white !important;
}

.carSelected {
	background-color: #628692 !important;
	color: white !important;
}

.vue2leaflet-map {
	z-index: 5 !important;
}
</style>
