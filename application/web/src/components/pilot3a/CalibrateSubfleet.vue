<template>
	<v-card>
		<v-toolbar color="var(--primarycolor)">
			<v-toolbar-title class="white--text">{{ $t('pilot3a.rightPanel.calibrateSubfleet') }}</v-toolbar-title>
		</v-toolbar>
		<v-card-text>
			<v-form ref="form" v-model="valid" lazy-validation>
				<v-container>
					<v-row align="center">
						<v-col md="6" cols="12">
							<v-select
								:items="models"
								v-model="modelSelected"
								item-text="model"
								item-value="model"
								:label="$t('pilot3a.uploadCalibration.model')"
								@change="getVersions(modelSelected)"
								required
								clearable
							></v-select>
						</v-col>
						<v-col md="6" cols="12">
							<v-select
								v-if="modelSelected"
								:items="versions"
								v-model="versionSelected"
								item-text="version"
								item-value="version"
								:label="$t('pilot3a.uploadCalibration.getVersion')"
								required
								clearable
							></v-select>
						</v-col>
					</v-row>
				</v-container>
			</v-form>	
		</v-card-text>
		<v-card-actions>
			<v-spacer></v-spacer>
			<v-btn color="blue-darken-1" variant="text" @click="closeDialog()">
				Close
			</v-btn>
			<v-btn color="blue-darken-1" variant="text"
				@click="
					calibrate()
					closeDialog()
					">
				Calibrate
			</v-btn>
		</v-card-actions>
	</v-card>
</template>


<script>
import puiEventsBus from '../../bus';
import backendCall from '../../services/backendCalls';

export default {
	name: 'CalibrateSubfleet',

	data: () => ({
		dialog: false,
		versions: [],
		modelSelected: "",
		versionSelected: "",
		models:[],
		valid: true
	}),

	methods: {
		async calibrate() {
			try {
				await backendCall.calibrateSubfleet(this.$store.state.pilot3a.subfleet,this.modelSelected,this.versionSelected);
			}
			catch (e){
				this.$puiNotify.error(e.response.data.message, this.$t('error'));
			}
		},
		closeDialog(){
			puiEventsBus.$emit("hideDialog");
		},
		async getModels() {
			try {
				let models = await backendCall.getModels();
				models.data.forEach(model => {
					this.models.push(model.model)
				});
			}
			catch (e){
				this.$puiNotify.error(this.$t('car.notifications.error.car'), this.$t('error'));
			}
		},
		async getVersions() {
			try {
				this.versions = []
				if (this.modelSelected == undefined){
					this.versions = []
				}else{
					let response = await backendCall.getVersions(this.modelSelected);
					response.forEach(version =>
					this.versions.push(version.version)
				)
				}
			}
			catch (e){
				this.$puiNotify.error(e.response.data.message, this.$t('error'));
			}
		},

	},
	mounted() {
		this.getModels()
	}

}

</script>

<style scoped></style>


