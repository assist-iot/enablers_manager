
<template>
	
	<v-container>
		<!-- Menu Buttons -->
		<v-col cols="12" sm="12" class="text-right" style="min-height: 125px">
			<v-btn 
				large 
				dark 
				color="var(--main-25)" 
				@click="
					addCarDialog = true
					getGroupsOfCars()
				">
				<v-icon dark left>add_circle</v-icon>
				{{ $t('car.new') }}
			</v-btn>
		</v-col>
		
		<v-row justify="space-around" style="max-height: 85vmin">
		<v-toolbar
				dense
				floating
				class="rounded-card"
				style="margin-bottom: 16px;"
			>
			<v-text-field
				hide-details
				prepend-icon="mdi-magnify"
				single-line
				v-model="carName"
			></v-text-field>
			<v-btn
				text
				@click="
					updateCar(carName);
					addCarDialog = false;
				"
				>
				<v-icon>search</v-icon>
			</v-btn	>
			
		</v-toolbar>
			
			<!-- Car table -->
			<v-col cols="12" class="rounded-card">
				<v-data-table :headers="tableHeaders" :items="car" :no-data-text="$t('car.noData')" class="rounded-table">
					<template v-slot:item.actions="{ item }">
						<v-tooltip bottom>
							<template v-slot:activator="{ on }">
								<v-btn
									icon
									v-on="on"
									@click="
										deleteCarDialog = true;
										device = item;
									"
								>
									<v-icon>cancel</v-icon>
								</v-btn>
							</template>
							<span>{{ $t('car.delete') }}</span>
						</v-tooltip>
						<v-tooltip bottom>
							<template v-slot:activator="{ on }">

								<v-btn
									icon
									v-on="on"
									@click="
										getEnablersInCar = true;
										car = item;
										updateEnablersInCarList(car.id)
									"
								>
									<v-icon>search</v-icon>
								</v-btn>
							</template>
							<span>{{ $t('car.getEnablersInCar') }}</span>
						</v-tooltip>
					</template>
				</v-data-table>
			</v-col>

			<!-- Delete car dialog -->
			<div class="text-center">
				<v-dialog v-model="deleteCarDialog" max-width="750">
					<v-card>
						<v-card-title class="headline">{{ $t('car.delete') }}</v-card-title>
						<v-divider></v-divider>
						<v-card-text
							><p class="font-weight-regular mt-5">
								{{ $t('car.deleteConfirmation') }} <strong>{{ device.id }}</strong> ?
							</p></v-card-text
						>
						<v-card-actions>
							<v-spacer></v-spacer>
							<v-btn 
								color="green darken-1" 
								text 
								@click="
									deleteCar(device.id)
									deleteCarDialog = false
								">{{ $t('delete') }}</v-btn>
							<v-btn 
								color="red darken-1" 
								text 
								@click="
									deleteCarDialog = false
								">{{ $t('cancel') }}</v-btn>
						</v-card-actions>
					</v-card>
				</v-dialog>
			</div>

			<!-- Add car dialog -->
			<div class="text-m-center">
				<v-dialog v-model="addCarDialog" max-width="750">
					<v-card>
						<v-toolbar color="var(--main-85)">
							<v-btn icon light @click="addCarDialog = false">
								<v-icon>close</v-icon>
							</v-btn>
							<v-toolbar-title light >{{ $t('car.new') }}</v-toolbar-title>
							<v-spacer></v-spacer>
						</v-toolbar>
						<v-form ref="form" v-model="valid" lazy-validation>
							<v-container>
								<v-row align="center">
									<v-col md="6" cols="12">
										<v-text-field
											filled
											:label="$t('forms.name')"
											color="var(--primarycolor)"
											v-model="newcar.name"
											outline
											required
											:rules="[(v) => !!v || $t('forms.name') + ' ' + $t('forms.required')]"
										></v-text-field>
									</v-col>
									<v-col md="6" cols="12">
										<v-text-field
											filled
											:label="$t('forms.description')"
											color="var(--primarycolor)"
											v-model="newcar.description"
											outline
											required
											:rules="[(v) => !!v || $t('forms.description') + ' ' + $t('forms.required')]"
										></v-text-field>
									</v-col>
									<v-col md="6" cols="12">
										<v-select
											:items="groups"
											:no-data-text="$t('car.group.noData')"
											item-text="group"
											item-value="group"
											v-model="newcar.group"
											:label="$t('forms.group')"
											required
											:rules="[(v) => !!v || $t('forms.group') + ' ' + $t('forms.required')]"
										></v-select>
									</v-col>
								</v-row>
							</v-container>
						</v-form>
						<v-card-actions>
							<v-spacer></v-spacer>
							<v-btn color="green darken-1" text @click="addCar()">{{ $t('save') }}</v-btn>
							<v-btn
								color="red darken-1"
								text
								@click="
									clearForm();
									addCarDialog = false;
								"
								>{{ $t('cancel') }}</v-btn
							>
						</v-card-actions>
					</v-card>
				</v-dialog>
			</div>

			<!-- Enablers in group table -->
			<div class="text-center">
				<v-dialog v-model="getEnablersInCar">
					<v-card>
						<v-card-title class="headline">{{ $t('enablersincars.data') }}</v-card-title>
						<v-divider></v-divider>
						<v-col cols="12">
						<v-data-table :headers="tableHeadersEnablers" :items="enablersingroup" :no-data-text="$t('enablersincars.noData')">
							<template v-slot:item.actions="{ item }">
								<v-tooltip bottom>
									<template v-slot:activator="{ on }">
										<v-btn
											icon
											v-on="on"
											@click="
												deleteEnablerInCarDialog = true;
												device = item;
											"
										>
											<v-icon>cancel</v-icon>
										</v-btn>
									</template>
									<span>{{ $t('enablersincars.delete') }}</span>
								</v-tooltip>
							</template>
						</v-data-table>
					</v-col>
					<v-col cols="12" sm="12" class="text-center" style="min-height: 125px">
						<v-btn 
							large 
							dark 
							color="var(--main-25)" 
							@click="
								addEnablerInCarDialog = true;
								getRepositories();
							">
							<v-icon dark left>add_circle</v-icon>
							{{ $t('enablersincars.new') }}
						</v-btn>
					</v-col>
					</v-card>

				</v-dialog>

			</div>

			<!-- Add Enablers in group -->
			<div class="text-m-center">
				<v-dialog v-model="addEnablerInCarDialog" max-width="750">
					<v-card>
						<v-toolbar color="var(--main-85)">
							<v-btn icon light @click="addEnablerInCarDialog = false">
								<v-icon>close</v-icon>
							</v-btn>
							<v-toolbar-title light>{{ $t('enabler.new') }}</v-toolbar-title>
						</v-toolbar>
						<v-form ref="form" v-model="valid" lazy-validation>
							<v-container>
								<v-row align="center">
									<v-col cols="12">
										<h3>General info</h3>
									</v-col>
									<v-col md="6" cols="12">
										<v-text-field
											filled
											:label="$t('forms.name')"
											color="var(--primarycolor)"
											v-model="enabler.name"
											outline
											required
											:rules="[(v) => !!v || $t('forms.name') + ' ' + $t('forms.required')]"
										></v-text-field>
									</v-col>
									<v-col cols="12">
										<v-divider></v-divider>
									</v-col>
									<v-col cols="12">
										<h3>Enabler selection</h3>
									</v-col>
									<v-col md="6" cols="12">
										<v-select
											:items="repositories"
											item-text="name"
											item-value="name"
											v-model="enabler.helmChart"
											:label="$t('enabler.form.repository')"
											@change="getRepoCharts(enabler.helmChart)"
											required
											:rules="[(v) => !!v || $t('enabler.form.repository') + ' ' + $t('forms.required')]"
										></v-select>
									</v-col>
									<v-col md="6" cols="12">
										<v-select
											v-if="enabler.helmChart"
											:items="repoCharts"
											item-text="Name"
											item-value="name"
											v-model="enabler.enabler"
											label="Enabler"
											@change="getChartVersions(enabler.enabler)"
											required
											:rules="[(v) => !!v || 'Enabler ' + $t('forms.required')]"
										></v-select>
									</v-col>
									<v-col md="6" cols="12">
										<v-select
											v-show="enabler.enabler"
											:items="chartVersions"
											item-text="name"
											item-value="name"
											v-model="enabler.enablerVersion"
											:label="$t('enabler.form.versions')"
											clearable
										></v-select>
									</v-col>
									<v-col md="6" cols="12"></v-col>
									<v-col cols="12">
										<v-divider></v-divider>
									</v-col>
									<v-col cols="12">
										<v-textarea
											filled
											:label="$t('enabler.form.values')"
											color="var(--primarycolor)"
											v-model="enabler.values"
											auto-grow
											outline
											required
											:rules="[
												(v) =>
													v == null ||
													v == '' ||
													isJson(v) ||
													$t('enabler.form.values') + ' ' + $t('forms.validJson')
											]"
										></v-textarea>
									</v-col>
								</v-row>
							</v-container>
						</v-form>
						<v-card-actions>
							<v-spacer></v-spacer>
							<v-btn color="green darken-1" text @click="addEnablerInCar()">{{ $t('save') }}</v-btn>
							<v-btn
								color="red darken-1"
								text
								@click="
									clearForm();
									addEnablerInCarDialog = false;
								"
								>{{ $t('cancel') }}</v-btn
							>
						</v-card-actions>
					</v-card>
				</v-dialog>
			</div>
			
			<!-- Delete enabler in car dialog -->
			<div class="text-center">
				<v-dialog v-model="deleteEnablerInCarDialog" max-width="750">
					<v-card>
						<v-card-title class="headline">{{ $t('enablersincars.delete') }}</v-card-title>
						<v-divider></v-divider>
						<v-card-text
							><p class="font-weight-regular mt-5">
								{{ $t('enablersincars.deleteConfirmation') }} <strong>{{ device.id }}</strong> ?
							</p></v-card-text
						>
						<v-card-actions>
							<v-spacer></v-spacer>
							<v-btn 
								color="green darken-1" 
								text 
								@click="
									deleteEnablerInCar(car.refGroup.value, device.id)
									deleteEnablerInCarDialog = false
								">{{ $t('delete') }}</v-btn>
							<v-btn 
								color="red darken-1" 
								text 
								@click="
									deleteEnablerInCarDialog = false
								">{{ $t('cancel') }}</v-btn>
						</v-card-actions>
					</v-card>
				</v-dialog>
			</div>

			<!-- Progress -->
			<div class="text-center">
				<v-dialog v-model="progress" persistent max-width="500">
					<v-card color="white">
						<v-card-title class="subtitle-1">{{ progressInfo }}</v-card-title>
						<v-card-text>
							<v-progress-linear color="var(--main-200)" indeterminate rounded height="6"></v-progress-linear>
						</v-card-text>
					</v-card>
				</v-dialog>
			</div>
		</v-row>
	</v-container>
</template>

<script>
export default {
	name: 'cars',
	data() {
		return {
			car: [],
			enablersingroup: [],
			repositories: [],
			repoCharts: [],
			chartVersions: [],
			groups: [],
			device: {},
			enabler: {},
			newcar: {},
			carName: "",
			addCarDialog: false,
			addEnablerInCarDialog: false,
			deleteEnablerInCarDialog: false,
			deleteCarDialog: false,
			deleteCarInGroupDialog: false,
			getEnablersInCar: false,
			fileform: false,
			form: false,
			interval: null,
			progress: false,
			progressInfo: '',
			tableHeaders: [
				{ text: 'ID', value: 'id' },
				{ text: this.$t('tables.description'), value: 'description.value' },
				{ text: this.$t('tables.refGroup'), value: 'refGroup.value' },
				{ text: this.$t('tables.timestamp'), value: 'timestamp.value' },
				{ text: this.$t('tables.actions'), value: 'actions' }
			],
			tableHeadersEnablers: [
				{ text: 'ID', value: 'id' },
				{ text: this.$t('tables.status'), value: 'status.value' },
				{ text: this.$t('tables.info'), value: 'info.value' },
				{ text: this.$t('tables.timestamp'), value: 'timestamp.value' },
				{ text: this.$t('tables.actions'), value: 'actions' }
			],
			valid: true

		};
	},
	created() {
	},
	beforeDestroy() {
		clearInterval(this.interval);
	},
	methods: {
		resetFormValidation() {
			this.$refs.form.resetValidation();
		},
		convertDate(inputFormat) {
			var d = new Date(inputFormat);
			return d.toLocaleString().replace(',', '');
		},
		isJson(str) {
			try {
				let json = JSON.parse(str);
				if (Array.isArray(json)) return false;
				else return true;
			} catch (e) {
				return false;
			}
		},
		updateCar(carId) {
			this.$puiRequests.getRequest(
				`/car/cluster/${carId}`,
				null,
				(response) => {
					let fecha = new Date(Number(response.data.timestamp.value));
					response.data.timestamp.value = fecha.toLocaleString()
					this.car = [response.data];
					
				},
				() => {
					clearInterval(this.interval);
					this.progress = false;
					// pui9 notification
					this.car=[]

					// this.$puiNotify.error(this.$t('car.notifications.error.car'), this.$t('error'));
					// this.showDialog = true;
				}
			);
		},
		addCar() {
			if (this.$refs.form.validate()) {
				this.showProgress(this.$t('car.progress.add'));
				this.$puiRequests.postRequest(
					'/car/cluster',
					this.newcar,
					() => {
						this.progress = false;
					},
					() => {
						this.progress = false;
						// pui9 notification
						this.$puiNotify.error(this.$t('k8scluster.notifications.error.add'), this.$t('error'));
						this.showDialog = true;
					}
				);

				this.addCarDialog = false;
				this.clearForm();
			}
		},
		addEnablerInCar(){
			let groupArray = this.car.refGroup.value.split(":")
			let groupName = groupArray[groupArray.length - 1]

			let carIdArray = this.car.id.split(":")
			let carName = carIdArray[carIdArray.length - 1]
			if (this.$refs.form.validate()) {
				this.showProgress(this.$t('enabler.progress.add'));
				// create additional parameters object
				let values = this.enabler.values ? JSON.parse(this.enabler.values) : {};

				let body = {
					enablerName: this.enabler.name,
					helmChart: this.enabler.helmChart + '/' + this.enabler.enabler,
					version: this.enabler.enablerVersion,
					values: values
				};
				this.$puiRequests.postRequest(
					`/car/enabler/${groupName}/${carName}`,
					body,
					(response) => {
						this.updateListResponse = response.data.uid
						this.interval = setInterval(() => {
							this.updateEnablersInCarList(this.car.id, body.enablerName);
						}, 2 * 1000);
					},
					(error) => {
						if (error.response.data.message.includes('500 Internal Server Error: [no body]')){
							this.interval = setInterval(() => {
								this.updateEnablersInCarList(this.car.id);
							}, 2 * 1000);
						}else{
							if (error.response.data.message.includes('The enabler already exists'))
							this.$puiNotify.error(this.$t('enabler.notifications.error.exist'), this.$t('error'));
							else this.$puiNotify.error(this.$t('enabler.notifications.error.deploy'), this.$t('error'));
							this.showDialog = true;
							this.progress = false;						
						}
						// pui9 notification
					}
				);

				this.addEnablerInCarDialog = false;
				this.clearForm();
			}
		},
		clearForm() {
			this.$refs.form.resetValidation();
			this.$refs.form.reset();

			this.group = {};
		},
		deleteCar(carId) {
			this.showProgress(this.$t('car.progress.delete'));
			let carArray = carId.split(":")
			let carName = carArray[carArray.length - 1]
			this.$puiRequests.deleteRequest(
				`/car/cluster/${carName}`,
				null,
				() => {
					this.interval = setInterval(() => {
						this.updateCar(carId);
					}, 2 * 1000);
				},
				(error) => {
					this.progress = false;
					if (error.response.data.message.includes('409 Conflict'))
						this.$puiNotify.error(this.$t('car.notifications.error.enabler'), this.$t('error'));
					else this.$puiNotify.error(this.$t('car.notifications.error.delete'), this.$t('error'));
					this.showDialog = true;
				}
			);
			this.deleteCarDialog = false;
		},
		showProgress(info) {
			this.progressInfo = info;
			this.progress = true;
		},
		updateEnablersInCarList(carId, enablerId) {
			let carArray = carId.split(":")
			let carName = carArray[carArray.length - 1]
			this.$puiRequests.getRequest(
				`/car/enabler/${carName}`,
				null,
				(response) => {
					this.enablersingroup = response.data;
					for(let enablers of this.enablersingroup){
						let fecha = new Date(Number(enablers.timestamp.value));
						enablers.timestamp.value = fecha.toLocaleString()
					}
					this.enablersingroup = this.enablersingroup.filter(item => item.status.value !== 'Deleting')
					console.log(this.enablersingroup)
					if (enablerId) {
						clearInterval(this.interval);
						this.progress = false;
						
					} else {
						this.progress = false;
					}
				},
				() => {
					clearInterval(this.interval);
					this.progress = false;
					// pui9 notification
					this.$puiNotify.error(this.$t('car.notifications.error.clusters'), this.$t('error'));
					this.showDialog = true;
				}
			);
		},
		deleteEnablerInCar(groupId, enablerId) {
			this.showProgress(this.$t('enablersincars.progress.delete'));
			let groupArray = groupId.split(":")
			let groupName = groupArray[groupArray.length - 1]

			let carIdArray = enablerId.split(":")
			let carName = carIdArray[carIdArray.length - 1]
			let enablerName = carIdArray[3]

			this.$puiRequests.deleteRequest(
				`/car/enabler/car/${groupName}/${carName}/${enablerName}`,
				null,
				() => {
					this.interval = setInterval(() => {
						this.updateEnablersInCarList(this.car.id,enablerId);
					}, 2 * 1000);
				},
				(error) => {
					this.progress = false;

					if (error.response.data.message.includes('409 Conflict'))
						this.$puiNotify.error(this.$t('enablersincars.notifications.error.enabler'), this.$t('error'));
					else this.$puiNotify.error(this.$t('enablersincars.notifications.error.delete'), this.$t('error'));
					this.showDialog = true;
				}
			);
			this.deleteCarDialog = false;
		},
		async getRepositories() {
			this.showProgress(this.$t('enabler.progress.repositories'));
			this.$puiRequests.getRequest(
				'/helmrepository/list',
				null,
				(response) => {
					this.repositories = response.data;
					this.progress = false;
				},
				() => {
					this.progress = false;
				}
			);
		},
		getRepoCharts(repo) {
			this.showProgress(this.$t('enabler.progress.enablers'));
			this.enabler.enabler = null;
			this.enabler.enablerVersion = null;
			this.$puiRequests.getRequest(
				'/helmrepository/charts',
				{ repoId: this.getRepoUrl(repo) },
				(response) => {
					this.repoCharts = response.data;
					this.progress = false;
				},
				() => {
					this.progress = false;
					this.$puiNotify.error(this.$t('enabler.notifications.error.charts'), this.$t('error'));
					this.showDialog = true;
				}
			);
		},
		getRepoUrl(repo) {
			return this.repositories.find((i) => i.name == repo).uid;
		},
		getChartVersions(chart) {
			this.showProgress(this.$t('enabler.progress.versions'));
			setTimeout(() => {
				this.chartVersions = this.repoCharts.find((i) => i.Name == chart).versions;
				this.progress = false;
			}, 1000);
		},
		async getGroupsOfCars(){
			this.showProgress(this.$t('enabler.progress.repositories'));
			this.$puiRequests.getRequest(
				'/car/group',
				null,
				(response) => {
					for(let group of response.data) {
						let groupArray = group.id.split(":")
						let groupName = groupArray[groupArray.length - 1]
						this.groups.push(groupName)
						} 
					this.progress = false;
				},
				() => {
					this.progress = false;
				}
			);
		}
	}
};
</script>

<style scoped>
.v-data-table >>> .v-data-table-header {
	background-color: #f8f9fa !important;
}

.v-data-table >>> .v-data-table-header th > span {
	color: #5a616d !important;
}

.v-data-table >>> a {
	text-decoration: none !important;
	color: var(--primarycolor) !important;
}

.rounded-card {
  border-radius: 15px; /* Adjust the value based on your preference */
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* Adjust the shadow as needed */
  overflow: hidden; /* Ensure the shadow is not clipped */
}

.rounded-table {
  border-radius: 15px; /* Adjust the value based on your preference */
  overflow: hidden; /* Ensure the rounded corners are applied */
}

div >>> .v-input--selection-controls__input {
	color: var(--primarycolor) !important;
}
</style>
