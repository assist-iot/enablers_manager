<template>
	<v-container>
		<v-row justify="space-around" style="max-height: 85vmin">
			<!-- Menu Buttons -->
			<v-col cols="12" sm="12" class="text-right" style="min-height: 125px">
				<v-btn large dark color="var(--main-25)" @click="addGroupDialog = true">
					<v-icon dark left>add_circle</v-icon>
					{{ $t('groupofcars.new') }}
				</v-btn>
			</v-col>
			<!-- Group of cars table -->
			<v-col cols="12" class="rounded-card">
				<v-data-table :headers="tableHeaders" :items="groupofcars" :no-data-text="$t('groupofcars.noData')" class="rounded-table">
					<template v-slot:item.actions="{ item }">
						<v-tooltip bottom>
							<template v-slot:activator="{ on }">
								<v-btn
									icon
									v-on="on"
									@click="
										deleteGroupDialog = true;
										device = item;
									"
								>
									<v-icon>cancel</v-icon>
								</v-btn>
							</template>
							<span>{{ $t('groupofcars.delete') }}</span>
						</v-tooltip>
						<v-tooltip bottom>
							<template v-slot:activator="{ on }">

								<v-btn
									icon
									v-on="on"
									@click="
										getEnablersInGroup = true;
										group = item;
										updateEnablersInGroupList(group.id)
									"
								>
									<v-icon>search</v-icon>
								</v-btn>
							</template>
							<span>{{ $t('groupofcars.getEnablersInGroup') }}</span>
						</v-tooltip>
						<v-tooltip bottom>
							<template v-slot:activator="{ on }">

								<v-btn
									icon
									v-on="on"
									@click="
										group = item;
										downloadVehiclesCsv(group.id)
									"
								>
									<v-icon>fa-file-csv</v-icon>
								</v-btn>
							</template>
							<span>{{ $t('groupofcars.donwloadVehiclesInGroup') }}</span>
						</v-tooltip>
					</template>
				</v-data-table>
			</v-col>

			<!-- Delete group dialog -->
			<div class="text-center">
				<v-dialog v-model="deleteGroupDialog" max-width="750">
					<v-card>
						<v-card-title class="headline">{{ $t('groupofcars.delete') }}</v-card-title>
						<v-divider></v-divider>
						<v-card-text
							><p class="font-weight-regular mt-5">
								{{ $t('groupofcars.deleteConfirmation') }} <strong>{{ device.id }}</strong> ?
							</p></v-card-text
						>
						<v-card-actions>
							<v-spacer></v-spacer>
							<v-btn 
								color="green darken-1" 
								text 
								@click="
									deleteGroup(device.id)
									deleteGroupDialog = false
								">{{ $t('delete') }}</v-btn>
							<v-btn 
								color="red darken-1" 
								text 
								@click="
									deleteGroupDialog = false
								">{{ $t('cancel') }}</v-btn>
						</v-card-actions>
					</v-card>
				</v-dialog>
			</div>

			<!-- Add group dialog -->
			<div class="text-m-center">
				<v-dialog v-model="addGroupDialog" max-width="750">
					<v-card>
						<v-toolbar color="var(--main-85)">
							<v-btn icon light @click="addGroupDialog = false">
								<v-icon>close</v-icon>
							</v-btn>
							<v-toolbar-title light>{{ $t('groupofcars.new') }}</v-toolbar-title>
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
											v-model="newgroup.name"
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
											v-model="newgroup.description"
											outline
											required
											:rules="[(v) => !!v || $t('forms.description') + ' ' + $t('forms.required')]"
										></v-text-field>
									</v-col>
								</v-row>
							</v-container>
						</v-form>
						<v-card-actions>
							<v-spacer></v-spacer>
							<v-btn color="green darken-1" text @click="addGroup()">{{ $t('save') }}</v-btn>
							<v-btn
								color="red darken-1"
								text
								@click="
									clearForm();
									addGroupDialog = false;
								"
								>{{ $t('cancel') }}</v-btn
							>
						</v-card-actions>
					</v-card>
				</v-dialog>
			</div>

			<!-- Enablers in group table -->
			<div class="text-center">
				<v-dialog v-model="getEnablersInGroup">
					<v-card>
						<v-card-title class="headline">{{ $t('enablersingroupofcars.data') }}</v-card-title>
						<v-divider></v-divider>
						<v-col cols="12">
						<v-data-table :headers="tableHeadersEnablers" :items="enablersingroup" :no-data-text="$t('enablersingroupofcars.noData')">
							<template v-slot:item.actions="{ item }">
								<v-tooltip bottom>
									<template v-slot:activator="{ on }">
										<v-btn
											icon
											v-on="on"
											@click="
												deleteEnablerInGroupDialog = true;
												device = item;
											"
										>
											<v-icon>cancel</v-icon>
										</v-btn>
									</template>
									<span>{{ $t('enablersingroupofcars.delete') }}</span>
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
								addEnablerInGroupDialog = true;
								getRepositories();
							">
							<v-icon dark left>add_circle</v-icon>
							{{ $t('enablersingroupofcars.new') }}
						</v-btn>
					</v-col>
					</v-card>

				</v-dialog>

			</div>

			<!-- Add Enablers in group -->
			<div class="text-m-center">
				<v-dialog v-model="addEnablerInGroupDialog" max-width="750">
					<v-card>
						<v-toolbar color="var(--main-85)">
							<v-btn icon light @click="addEnablerInGroupDialog = false">
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
									<v-col md="6" cols="12">
										<v-checkbox v-model="enabler.fullnameOverride" :label="$t('enabler.form.fullnameOverride')">
											<template v-slot:label>
												<v-tooltip bottom>
													<template v-slot:activator="{ on }">
														<span v-on="on">{{ $t('enabler.form.fullnameOverride') }}</span>
													</template>
													{{ $t('enabler.form.fullnameOverrideTooltip') }}
												</v-tooltip>
											</template>
										</v-checkbox>
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
							<v-btn color="green darken-1" text @click="addEnablerInGroup(group.id)">{{ $t('save') }}</v-btn>
							<v-btn
								color="red darken-1"
								text
								@click="
									clearForm();
									addEnablerInGroupDialog = false;
								"
								>{{ $t('cancel') }}</v-btn
							>
						</v-card-actions>
					</v-card>
				</v-dialog>
			</div>
			
			<!-- Delete enabler in group dialog -->
			<div class="text-center">
				<v-dialog v-model="deleteEnablerInGroupDialog" max-width="750">
					<v-card>
						<v-card-title class="headline">{{ $t('enablersingroupofcars.delete') }}</v-card-title>
						<v-divider></v-divider>
						<v-card-text
							><p class="font-weight-regular mt-5">
								{{ $t('enablersingroupofcars.deleteConfirmation') }} <strong>{{ device.id }}</strong> ?
							</p></v-card-text
						>
						<v-card-actions>
							<v-spacer></v-spacer>
							<v-btn 
								color="green darken-1" 
								text 
								@click="
									deleteEnablerInGroup(group.id, device.id)
									deleteEnablerInGroupDialog = false
								">{{ $t('delete') }}</v-btn>
							<v-btn 
								color="red darken-1" 
								text 
								@click="
									deleteEnablerInGroupDialog = false
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
	name: 'groupofcars',
	data() {
		return {
			groupofcars: [],
			enablersingroup: [],
			repositories: [],
			repoCharts: [],
			chartVersions: [],
			device: {},
			group: {},
			newgroup: {},
			enabler: {},
			addGroupDialog: false,
			addEnablerInGroupDialog: false,
			deleteGroupDialog: false,
			deleteEnablerInGroupDialog: false,
			getEnablersInGroup: false,
			fileform: false,
			form: false,
			interval: null,
			progress: false,
			progressInfo: '',
			tableHeaders: [
				{ text: 'ID', value: 'id' },
				{ text: this.$t('tables.description'), value: 'description.value' },
				{ text: this.$t('tables.countVehicles'), value: 'countCars' },
				{ text: this.$t('tables.timestamp'), value: 'timestamp.value' },
				{ text: this.$t('tables.actions'), value: 'actions' }
			],
			tableHeadersEnablers: [
				{ text: 'ID', value: 'id' },
				{ text: this.$t('tables.running'), value: 'Running' },
				{ text: this.$t('tables.error'), value: 'Error' },
				{ text: this.$t('tables.actions'), value: 'actions' }
			],
			valid: true

		};
	},
	created() {
		this.showProgress(this.$t('groupofcars.progress.get'));
		this.updateGroupList();
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
		addGroup() {
			if (this.$refs.form.validate()) {
				this.showProgress(this.$t('groupofcars.progress.add'));
				this.$puiRequests.postRequest(
					'/car/group',
					this.newgroup,
					() => {
						this.updateGroupList();
					},
					() => {
						this.progress = false;
						// pui9 notification
						this.$puiNotify.error(this.$t('k8scluster.notifications.error.add'), this.$t('error'));
						this.showDialog = true;
					}
				);

				this.addGroupDialog = false;
				this.clearForm();
			}
		},
		addEnablerInGroup(groupId) {
			let groupArray = groupId.split(":")
			let groupName = groupArray[groupArray.length - 1]
			if (this.$refs.form.validate()) {
				this.showProgress(this.$t('enabler.progress.add'));
				// create additional parameters object
				let values = this.enabler.values ? JSON.parse(this.enabler.values) : {};
				if (this.enabler.fullnameOverride) values.fullnameOverride = this.enabler.enablerName;

				let body = {
					enablerName: this.enabler.name,
					helmChart: this.enabler.helmChart + '/' + this.enabler.enabler,
					version: this.enabler.enablerVersion,
					values: values
				};
				this.$puiRequests.postRequest(
					`/car/enabler/${groupName}`,
					body,
					(response) => {
						this.updateListResponse = response.data.uid
						this.interval = setInterval(() => {
							this.updateEnablersInGroupList(groupId);
						}, 2 * 1000);
					},
					(error) => {
						if (error.response.data.message.includes('500 Internal Server Error: [no body]')){
							this.interval = setInterval(() => {
								this.updateEnablersInGroupList(groupId);
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

				this.addEnablerInGroupDialog = false;
				this.clearForm();
			}
		},
		clearForm() {
			this.$refs.form.resetValidation();
			this.$refs.form.reset();

			this.newgroup = {};
		},
		deleteGroup(groupId) {
			this.showProgress(this.$t('groupofcars.progress.delete'));
			let groupArray = groupId.split(":")
			let groupName = groupArray[groupArray.length - 1]
			this.$puiRequests.deleteRequest(
				`/car/group/${groupName}`,
				null,
				() => {
					this.interval = setInterval(() => {
						this.updateGroupList(groupId);
					}, 2 * 1000);
				},
				(error) => {
					console.log(error);
					this.progress = false;

					if (error.response.data.message.includes('409 Conflict'))
						this.$puiNotify.error(this.$t('groupofcars.notifications.error.enabler'), this.$t('error'));
					else this.$puiNotify.error(this.$t('groupofcars.notifications.error.delete'), this.$t('error'));
					this.showDialog = true;
				}
			);
			this.deleteGroupDialog = false;
		},
		showProgress(info) {
			this.progressInfo = info;
			this.progress = true;
		},
		updateGroupList(groupId) {
			console.log(this.group)
			this.$puiRequests.getRequest(
				'/car/group',
				null,
				(response) => {
					this.groupofcars = response.data;
					for(let group of this.groupofcars){
						let fecha = new Date(Number(group.timestamp.value));
						group.timestamp.value = fecha.toLocaleString()
					}
					if (groupId) {
						let group = response.data.find((i) => i.id === groupId);
						
						if (!group) {
							clearInterval(this.interval);
							this.progress = false;
						}
					} else {
						this.progress = false;
					}
				},
				(error) => {
					console.log(error);
					clearInterval(this.interval);
					this.progress = false;
					// pui9 notification
					this.$puiNotify.error(this.$t('groupofcars.notifications.error.clusters'), this.$t('error'));
					this.showDialog = true;
				}
			);
		},
		updateEnablersInGroupList(groupId, enablerId) {
			let groupArray = groupId.split(":")
			let groupName = groupArray[groupArray.length - 1]
			this.$puiRequests.getRequest(
				`/car/enabler/group/${groupName}`,
				null,
				(response) => {
					this.enablersingroup = response.data;
					this.enablersingroup = this.enablersingroup.filter(item => item.status.value !== 'Deleting')
					if (enablerId) {
						let enabler = response.data.find((i) => i.id === enablerId);
						
						if (!enabler) {
							clearInterval(this.interval);
							this.progress = false;
						}
					} else {
						clearInterval(this.interval);
						this.progress = false;
					}
				},
				() => {
					clearInterval(this.interval);
					this.progress = false;
					// pui9 notification
					this.$puiNotify.error(this.$t('groupofcars.notifications.error.clusters'), this.$t('error'));
					this.showDialog = true;
				}
			);
		},
		deleteEnablerInGroup(groupId,enablerId) {
			this.showProgress(this.$t('enablersingroupofcars.progress.delete'));
			let groupArray = groupId.split(":")
			let groupName = groupArray[groupArray.length - 1]

			let enablerArray = enablerId.split(":")
			let enablerName = enablerArray[enablerArray.length - 1]

			this.$puiRequests.deleteRequest(
				`/car/enabler/group/${groupName}/${enablerName}`,
				null,
				() => {
					this.interval = setInterval(() => {
						this.updateEnablersInGroupList(groupId,enablerId);
					}, 2 * 1000);
				},
				(error) => {
					console.log(error);
					this.progress = false;

					if (error.response.data.message.includes('409 Conflict'))
						this.$puiNotify.error(this.$t('enablersingroupofcars.notifications.error.enabler'), this.$t('error'));
					else this.$puiNotify.error(this.$t('enablersingroupofcars.notifications.error.delete'), this.$t('error'));
					this.showDialog = true;
				}
			);
			this.deleteGroupDialog = false;
		},
		async getRepositories() {
			this.showProgress(this.$t('enabler.progress.repositories'));
			this.$puiRequests.getRequest(
				'/helmrepository/list',
				null,
				(response) => {
					this.repositories = response.data;
					console.log(this.repositories)
					this.progress = false;
				},
				(error) => {
					console.log(error);
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
				(error) => {
					console.log(error);
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
		downloadVehiclesCsv(groupId) {
			let groupArray = groupId.split(":")
			let groupName = groupArray[groupArray.length - 1]
			this.$puiRequests.getRequest(
				`/car/cluster/group/csv/${groupName}`,
				null,
				(response) => {
					const blob = new Blob([response.data], {type: 'text/csv'})
					const url = URL.createObjectURL(blob)
					const link = document.createElement('a')
					link.href = url
					link.setAttribute('download', 'vehicles.csv')
					link.click()
				},
				(error) => {
					console.log(error);
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

.rounded-card {
  border-radius: 15px; /* Adjust the value based on your preference */
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* Adjust the shadow as needed */
  overflow: hidden; /* Ensure the shadow is not clipped */
}

.rounded-table {
  border-radius: 15px; /* Adjust the value based on your preference */
  overflow: hidden; /* Ensure the rounded corners are applied */
}

.v-data-table >>> a {
	text-decoration: none !important;
	color: var(--primarycolor) !important;
}

div >>> .v-input--selection-controls__input {
	color: var(--primarycolor) !important;
}
</style>
