<template>

	<!-- Add a new calibration -->
	<v-card>
		<v-toolbar color="var(--primarycolor)">
			<v-toolbar-title class="white--text">{{ $t('pilot3a.uploadCalibration.uploadCalibration') }}</v-toolbar-title>
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
								required
								clearable
							></v-select>
						</v-col>
						<v-col md="6" cols="12" class="text-center" >
							<v-btn
								large
								dark
								color="var(--main-25)"
								@click="
									addModelDialog = true;
								"
							>
								<v-icon dark left>add_circle</v-icon>
								{{ $t('pilot3a.uploadCalibration.addModel') }}
							</v-btn>
						</v-col>
					</v-row>
				</v-container>
			</v-form>	
		<v-container>
			<v-row>
				<v-text-field label="Version*" required v-model="version"></v-text-field>
			</v-row>
			<v-row>
				<v-file-input type="file" label="Cal file" accept=".txt,.yml,.cal" truncate-length="30" show-size
					v-model="calFile" />
			</v-row>
		</v-container>
		</v-card-text>
		<v-card-actions>
			<v-spacer></v-spacer>
			<v-btn color="blue-darken-1" variant="text" @click="closeDialog()">
				Close
			</v-btn>
			<v-btn :disabled='calFile == null || version == "" ? true : false' color="blue-darken-1" variant="text"
				@click="uploadCal()">
				{{ $t('pilot3a.uploadCalibration.uploadCalibration') }}
			</v-btn>
		</v-card-actions>

		<!-- Add a new model -->
		<v-dialog v-model="addModelDialog" transition="dialog-bottom-transition"  width="auto" class="form">
			<v-card>
				<v-toolbar color="var(--primarycolor)">
					<v-toolbar-title class="white--text">{{ $t('pilot3a.uploadCalibration.addModel') }}</v-toolbar-title>
				</v-toolbar>
				<v-card-text>
					<v-form ref="form" v-model="valid" lazy-validation>
						<v-container>
							<v-row align="center">
								<v-col  cols="12">
									<v-text-field
										filled
										:label="$t('forms.name')"
										color="var(--primarycolor)"
										v-model="postModelName"
										outline
										required
										:rules="[(v) => !!v || $t('forms.name') + ' ' + $t('forms.required')]"
									></v-text-field>
								</v-col>
							</v-row>
						</v-container>
					</v-form>	
				</v-card-text>
				<v-card-actions>
					<v-spacer></v-spacer>
					<v-btn color="blue-darken-1" variant="text"
						@click="
							postModel(postModelName)
							addModelDialog = false
							">
						{{ $t('pilot3a.uploadCalibration.uploadCalibration') }}
					</v-btn>
				</v-card-actions>
			</v-card>
		</v-dialog>
	</v-card>
	
	
</template>

<script>
import backendCall from '../../services/backendCalls';
import puiEventsBus from '../../bus';
export default {
	name: 'UploadCalibration',

	data: () => ({
		dialog: false,
		calFile: null,
		version: "",
		addModelDialog: false,
		models: [],
		modelSelected: "",
		postModelName: "",
		valid: true
	}),

	methods: {
		async uploadCal() {
			try {
				if (this.$store.state.pilot3a.calVersions.some(obj => obj.version == this.version) == false) {
					await backendCall.registerVersion(this.modelSelected, this.version);
				}
				await backendCall.uploadCalibration(this.calFile, this.modelSelected, this.version);
				this.closeDialog();
			}
			catch (e){
				this.$puiNotify.error(e.response.data.message, this.$t('error'));
				this.closeDialog();
			}
		},
		async getModels() {
			try {
				let models = await backendCall.getModels();
				models.data.forEach(model => {
					this.models.push(model.model)
				});
			}catch (e){
				this.$puiNotify.error(e.response.data.message, this.$t('error'));
			}
		},
		async postModel(postModelName) {
			try {
				await backendCall.postModel(postModelName);
				this.models.push(postModelName)
			}
			catch (e){
				this.$puiNotify.error(e.response.data.message, this.$t('error'));
			}
		},

		closeDialog() {
			this.calFile = null;
			this.version = "";
			puiEventsBus.$emit("hideDialog");
		}

	},
	mounted() {
		this.getModels()
	}
}

</script>

<style scoped></style>


