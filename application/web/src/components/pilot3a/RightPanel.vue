<template>
	<v-col class="justify-center limits" cols="5">
		<v-row>
			<h2 class="font-weight-bold text-center mb-6">
				{{ $t('pilot3a.rightPanel.emissionHistogram')}}
			</h2>
		</v-row>
		<v-row>
			<v-col cols="2">
				<v-btn color="black--text" width="fit-content" class="subheading mb-6" target="_blank"
					@click="filterModal()">
					{{ $t('pilot3a.rightPanel.filter') }}
				</v-btn>
			</v-col>
			<v-col cols="5">
				<v-select class="subfleet ml-4 mt-0 pt-0" v-if="this.$store.state.pilot3a.activeFilter != null" :items=this.$store.state.pilot3a.filters
					item-text="entry" item-value="entry" v-model="selectedFilter" @change="changeHistogram()"
					density="compact" width="60px">
				</v-select>
			</v-col>
		</v-row>
		<v-row justify="center" align="center">
			<v-col class="" cols="12">
				<HistogramFigure key="histogram" :iseHistogram="iseHistogram" :xLabel="property"/>
			</v-col>

		</v-row>

		<br>
		<div>
			<div class="text-m-center">
				<v-dialog v-model="filterDialog" transition="dialog-bottom-transition" width="auto" class="form">
					<FilterComponent :countryList="countryList"/>
				</v-dialog>
				<v-dialog v-model="uploadCalibrationDialog" transition="dialog-bottom-transition"  max-width="750" class="form">
					<UploadCalibration />
				</v-dialog>
				<v-dialog v-model="calibrateSubfleetDialog" transition="dialog-bottom-transition" max-width="750"  class="form">
					<CalibrateSubfleet />
				</v-dialog>
			</div>
			<v-row justify="center" align="center" v-if="this.$store.state.pilot3a.subfleet == 'all'">
				<v-col class="" cols="4" justify="center" align="center">
					<v-btn color="black--text" width="fit-content" class="subheading mt-6 mb-6" target="_blank"
						@click=carsList()>
						{{ $t('pilot3a.rightPanel.listOfCars') }}
					</v-btn>
				</v-col>
				<v-col class="" cols="4" justify="center" align="center">
					<v-btn color="black--text" width="fit-content" class="subheading mt-6 mb-6" target="_blank"
						@click="uploadCalModal()">
						{{ $t('pilot3a.uploadCalibration.uploadCalibration') }}					
					</v-btn>
				</v-col>
			</v-row>
			<v-row v-else justify="start" align="center">
				<v-col class="" cols="4" justify="center" align="center">
					<v-btn color="black--text" width="fit-content" class="subheading mt-6 mb-6" target="_blank"
						@click=carsList()>
						{{ $t('pilot3a.rightPanel.listOfCars') }}
					</v-btn>
				</v-col>
				<v-col class="" cols="4" justify="center" align="center">
					<v-btn color="black--text" width="fit-content" class="subheading mt-6 mb-6" target="_blank"
						@click="uploadCalModal()">
						{{ $t('pilot3a.uploadCalibration.uploadCalibration') }}
					</v-btn>
				</v-col>
				<v-col class="" cols="4" justify="center" align="center">
					<v-btn color="black--text" width="fit-content" class="subheading mt-6 mb-6" target="_blank"
						@click="calSubfleetModal()">
						{{ $t('pilot3a.rightPanel.calibrateSubfleet') }}
					</v-btn>
				</v-col>
			</v-row>
		</div>
	</v-col>
</template>

<script>
import HistogramFigure from './HistogramFigure.vue'
import FilterComponent from './FilterComponent.vue'
import UploadCalibration from './UploadCalibration.vue'
import CalibrateSubfleet from './CalibrateSubfleet.vue'
import puiEventsBus from '../../bus';
import backendCall from '../../services/backendCalls';
const carsIndex = (process.env.CAR_INDEX) ? process.env.CAR_INDEX : 'obm';

export default {
	name: 'RightPanel',
	components: {
		HistogramFigure,
		UploadCalibration,
		CalibrateSubfleet,
		FilterComponent
	},

	data: () => ({
		uploadCalibrationDialog: false,
		calibrateSubfleetDialog: false,
		filterDialog: false,
		activeOption: 0,
		selected: null,
		firmwareList: [],
		yearList: [],
		countryList: [],
		iseHistogram: [],
		selectedFilter: null,
		property: "NOx_mg_km_isc"
	}),

	methods: {
		async overallHistogram(){
			let allCars = {}
			let property = "NOx_mg_km_isc"
			let histogram_query = `{"size": 0,"aggs": {"emissions": {"histogram": {"field": "${property}","interval": 0.1,"extended_bounds": {"min": 0.1,"max": 1.5},"offset": 0}}}}`
			let histogram = await backendCall.getIndexQuery(carsIndex, histogram_query);
			let histogramFormatted = histogram.map(bucket => {
				return {
					from: bucket.key,
					to: bucket.key + 5,
					count: bucket.doc_count
				};
			});
			allCars.entry = "All fleet";
			allCars.histogram = histogramFormatted
			allCars.unit = property

			this.$store.commit('addFilter', allCars);
			this.$store.commit('activeFilter', allCars.entry);
			this.selectedFilter = allCars.entry;
			this.changeHistogram()
		},
		async postNamespace() {
			await backendCall.postNamespace("firmware");
		},

		async carsList() {
			let subfleetQuery = `"query": { "bool": { "must": { "term": { "subfleet": "${this.$store.state.pilot3a.subfleet}"}}}},`
			let query = `{
                "size": 0,
				${this.$store.state.pilot3a.subfleet == 'all' ? "" : subfleetQuery}
                "aggs": {
                    "cars": {
                        "terms": {
                            "field": "car_id",
                            "size": 120000
                        },
                        "aggs": {
                            "threshold_check": {
                                "sum": {
                                    "script": {
										"source": "if (doc['NOx_mg_km_isc'].size()!=0){ doc['NOx_mg_km_isc'].value > params.threshold}",
                                        "params": {
                                            "threshold": 60
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }`
			let listOfCars = await backendCall.getCarsList(carsIndex, query)
			const blob = new Blob([listOfCars], {type: 'text/csv'})
			const url = URL.createObjectURL(blob)
			const link = document.createElement('a')
			link.href = url
			link.setAttribute('download', 'vehicles.csv')
			link.click()
		},

		changeHistogram(){
			let entry = this.$store.state.pilot3a.filters.find(filter => filter.entry === this.selectedFilter);
			this.iseHistogram = entry ? entry.histogram : null;
			this.property = entry ? entry.property : "NOx_mg_km_isc"
		},

		filterModal() {
			this.filterDialog = true;
		},

		uploadCalModal() {
			this.uploadCalibrationDialog = true;
		},

		calSubfleetModal() {
			this.calibrateSubfleetDialog = true;
		}

	},

	mounted() {
		puiEventsBus.$on('hideDialog', () => {
			this.calibrateSubfleetDialog = false;
			this.uploadCalibrationDialog = false;
			this.filterDialog = false;
		})
		puiEventsBus.$on('changeHistogram', (title) => {
			this.selectedFilter = title;
			this.changeHistogram();
		})
		this.postNamespace()
		this.overallHistogram()
	}
}

</script>

<style scoped>
.limits {
	margin: 20px !important;
}

.optionSelected {
	background-color: #863659 !important;
	color: white !important;
	margin: 0 !important;
}

.selector {
	min-width: 120px;
	max-width: 120px;
	padding-top: 0 !important;
	margin-bottom: 0 !important;
}

.v-text-field__details {
	min-height: 0 !important;
}

.form {
	z-index: 10000 !important;
}
</style>


