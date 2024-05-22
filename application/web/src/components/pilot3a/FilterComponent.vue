<template>
	<v-card>
		<v-card-title>
			<span class="text-h5">{{$t('pilot3a.filter.histogramFilter')}}</span>
		</v-card-title>
		<v-card-text>
			<v-container class="filterComponent">
				<v-text-field :label="$t('pilot3a.filter.filterName')" required v-model="title"></v-text-field>
				<v-row>
					<v-col cols="2">
						<v-select label="Firmware" required :key="firmware" :items=firmwareList item-text="entry"
							item-value="entry" v-model="firmware" variant="outlined" density="compact" />
					</v-col>
					<v-col cols="2">
						<v-select :label="$t('pilot3a.filter.country')" :key="country" :items=countryList item-text="entry" item-value="entry"
							v-model="country" variant="outlined" density="compact" />
					</v-col>
					<v-col cols="2">
						<v-select :label="$t('pilot3a.filter.rideType')" :key="ride" :items=rideList item-text="entry" item-value="entry"
							v-model="ride" variant="outlined" density="compact" />
					</v-col>
					<v-col cols="2">
						<v-select :label="$t('pilot3a.filter.sensorType')" :key="sensor" :items=sensorList item-text="entry" item-value="entry"
							v-model="sensor" variant="outlined" density="compact" />
					</v-col>
					<v-col cols="2">
						<v-select :label="$t('pilot3a.filter.sensorProcessed')" :key="processed" :items=processedList item-text="entry"
							item-value="entry" v-model="processed" variant="outlined" density="compact" />
					</v-col>
				</v-row>
				<v-row>
					<v-col cols="2">
						<v-select :label="$t('pilot3a.filter.minDistance')" :items=distanceList item-text="entry" item-value="entry"
							v-model="distanceMin" variant="outlined" density="compact" width="120px" />
					</v-col>
					<v-col cols="2">
						<v-select :label="$t('pilot3a.filter.maxDistance')" :items=distanceList item-text="entry" item-value="entry"
							v-model="distanceMax" variant="outlined" density="compact" width="120px" />
					</v-col>
				</v-row>
				<v-row>
					<v-col cols="2">
						<v-select :label="$t('pilot3a.filter.minSpeed')" :items=speedList item-text="entry" item-value="entry" v-model="speedMin"
							variant="outlined" density="compact" width="120px" />
					</v-col>
					<v-col cols="2">
						<v-select :label="$t('pilot3a.filter.maxSpeed')" :items=speedList item-text="entry" item-value="entry" v-model="speedMax"
							variant="outlined" density="compact" width="120px" />
					</v-col>
				</v-row>
			</v-container>
		</v-card-text>
		<v-card-actions>
			<v-spacer></v-spacer>
			<v-btn color="blue-darken-1" variant="text" @click="closeDialog()">
				Close
			</v-btn>
			<v-btn :disabled="title == ''" color="blue-darken-1" variant="text" @click="apply()">
				Apply
			</v-btn>
		</v-card-actions>
	</v-card>
</template>

<script>

import puiEventsBus from '../../bus';
import backendCall from '../../services/backendCalls';

export default {
	name: 'FilterComponent',
	data: () => ({
		dialog: false,
		title: "",
		firmwareList: [{ entry: "All" }, { entry: "001" }],
		firmware: "All",
		countryList: [{ entry: "Europe" }, { entry: "france" }, { entry: "estonia" }, { entry: "ukraine" }, { entry: "latvia" }, { entry: "belarus" }, { entry: "norway" }, { entry: "lithuania" }, { entry: "russia" }, { entry: "czech republic" }, { entry: "germany" }, { entry: "sweden" }, { entry: "denmark" }, { entry: "finland" }, { entry: "luxembourg" }, { entry: "belgium" }, { entry: "north macedonia" }, { entry: "albania" }, { entry: "kosovo" }, { entry: "ES" }, { entry: "romania" }, { entry: "hungary" }, { entry: "italy" }, { entry: "slovakia" }, { entry: "poland" }, { entry: "ireland" }, { entry: "united kingdom" }, { entry: "greece" }, { entry: "austria" }, { entry: "netherlands" }, { entry: "switzerland" }, { entry: "serbia" }, { entry: "montenegro" }, { entry: "croatia" }, { entry: "slovenia" }, { entry: "bulgaria" }, { entry: "moldova" }, { entry: "bosnia and herzegovina" }, { entry: "portugal" }, { entry: "iceland" }],
		country: "Europe",
		rideList: [{ entry: "Urban" }, { entry: "Motorway" }, { entry: "Rural" }, { entry: "All" }],
		ride: "All",
		sensorList: [{ entry: "NOx (g)" }],//, { entry: "NOx (g/km)" }],
		sensor: 'NOx (g)',
		processedList: [{ entry: true }, { entry: false }],
		processed: false,
		distanceList: [{ entry: "Indifferent" }, { entry: 1 }, { entry: 2 }, { entry: 5 }, { entry: 10 }, { entry: 20 }, { entry: 50 }, { entry: 100 }, { entry: 150 }, { entry: 200 }, { entry: 250 }, { entry: 500 }],
		speedList: [{ entry: "Indifferent" }, { entry: 10 }, { entry: 20 }, { entry: 30 }, { entry: 40 }, { entry: 50 }, { entry: 60 }, { entry: 70 }, { entry: 80 }, { entry: 90 }, { entry: 100 }, { entry: 120 }, { entry: 150 }],
		distanceMin: "Indifferent",
		distanceMax: "Indifferent",
		speedMin: "Indifferent",
		speedMax: "Indifferent"
	}),

	methods: {

		async apply() {
			let newFilter = {};
			let distance = "";
			let speed = "";
			if (this.distanceMin != "Indifferent" || this.distanceMax != "Indifferent") {
				distance = `{"range": {"total_distance_trip": {
					${this.distanceMin != "Indifferent" ? `"gte": ${this.distanceMin}` : ""}
					${(this.distanceMin != "Indifferent" && this.distanceMax != "Indifferent") ? "," : ""}
					${this.distanceMax != "Indifferent" ? `"lte": ${this.distanceMax}` : ""}
				}}},`
			}
			if (this.speedMin != "Indifferent" || this.speedMax != "Indifferent") {
				speed = `{"range": {"mean_v_trip": {
					${this.speedMin != "Indifferent" ? `"gte": ${this.speedMin}` : ""}
					${(this.speedMin != "Indifferent" && this.speedMax != "Indifferent") ? "," : ""}
					${this.speedMax != "Indifferent" ? `"lte": ${this.speedMax}` : ""}
				}}},`
			}

			let must = (this.distanceMin == "Indifferent" && this.distanceMax == "Indifferent" && this.speedMin == "Indifferent" && this.speedMax == "Indifferent" && this.firmware == "All" && this.$store.state.pilot3a.subfleet == 'all' && this.country == "Europe") ? ""
			: `,"query":{"bool": {"must": [
							${this.firmware != "All" ? `{"term": {"sw_ver": "${this.firmware}"}},` : ""}
							${this.$store.state.pilot3a.subfleet != 'all' ? `{"term": {"subfleet": "${this.$store.state.pilot3a.subfleet}"}},` : ""}
							${this.country != "Europe" ? `{"term": {"country": "${this.country[0].toUpperCase() + this.country.slice(1).toLowerCase()}"}},` : ""}
							${distance}
							${speed}`
			must = must.length == 0 ? "" : must = must.replace(/\s/g, '').slice(0, -1) + "]}}";
			let property = this.processed == true ? "nox_g_km_processed" : "nox_g_km"
			let aggregation = `,"aggs": {"emissions": {"histogram": {"field": "${property}","interval": 0.1,"extended_bounds": {"min": 0.1,"max": 1.5},"offset": 0}}}`

			let histogram_query = `{"size": 0${must.length == 2 ? "" : must}${aggregation}}`
			console.log(histogram_query)
			let histogram = await backendCall.getIndexQuery("obm", histogram_query);
			let histogramFormatted = histogram.map(bucket => {
				return {
					from: bucket.key,
					to: bucket.key + 5,
					count: bucket.doc_count
				};
			});
			newFilter.entry = `${this.title} ${this.$store.state.pilot3a.subfleet != 'all' ? `(Subfleet: ${this.$store.state.pilot3a.subfleet})`: ""}`;
			newFilter.histogram = histogramFormatted
			newFilter.unit = property

			this.$store.commit('addFilter', newFilter);
			this.$store.commit('activeFilter', newFilter.entry);
			puiEventsBus.$emit("changeHistogram", newFilter.entry);
			this.closeDialog();
		},

		closeDialog() {
			puiEventsBus.$emit("hideDialog");
			this.title = ""
			this.firmware = "All"
			this.country = "Europe",
				this.ride = "All",
				this.sensor = 'NOx (g)',
				this.processed = false,
				this.distanceMin = "Indifferent",
				this.distanceMax = "Indifferent",
				this.speedMin = "Indifferent",
				this.speedMax = "Indifferent"
		}
	}
}

</script>

<style scoped>
.filterComponent {
	width: 1080px;
	max-width: 1080px;
}

.highlighted {
	border-color: blue
}
