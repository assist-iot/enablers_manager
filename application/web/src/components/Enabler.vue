<template>
	<v-container >
		<v-row justify="space-around" align="center" style="max-height: 85vmin">

			<!-- Menu Buttons -->
			<v-col cols="12" class="text-right" style="min-height: 125px">
				<v-btn
					large
					dark
					color="var(--main-25)"
					@click="
						getClusters();
						addEnablerDialog = true;
					"
				>
					<v-icon dark left>add_circle</v-icon>
					{{ $t('enabler.new') }}
				</v-btn>
			</v-col>

			<!-- Enablers table -->
			<v-col cols="12" class="rounded-card">
				<v-data-table :headers="tableHeaders" :items="enablers" :no-data-text="$t('enabler.noData')" class="rounded-table">
					<template v-slot:item.actions="{ item }">
						<v-tooltip bottom>
							<template v-slot:activator="{ on }">
								<v-btn
									icon
									v-on="on"
									:disabled="item.status == 'Pending'"
									@click="
										deleteEnablerDialog = true;
										enabler = item;
									"
								>
									<v-icon>cancel</v-icon>
								</v-btn>
							</template>
							<span>{{ $t('enabler.delete') }}</span>
						</v-tooltip>
						<v-tooltip bottom>
							<template v-slot:activator="{ on }">
								<v-btn
									icon
									v-on="on"
									:disabled="item.status == 'Pending'"
									@click="
										upgradeEnablerDialog = true;
										enabler = item;
										getEnablerVersionFromHelmChart(enabler.helmChart)
									"
								>
									<v-icon>upgrade</v-icon>
								</v-btn>
							</template>
							<span>Upgrade enabler</span>

						</v-tooltip>
					</template>
				</v-data-table>
			</v-col>

			<!-- Upgrade enabler dialog -->
			<div class="text-m-center">
				<v-dialog v-model="upgradeEnablerDialog" max-width="750">
					<v-card>
						<v-toolbar color="var(--primarycolor)">
							<v-btn icon dark @click="upgradeEnablerDialog = false">
								<v-icon>close</v-icon>
							</v-btn>
							<v-toolbar-title class="white--text">{{ $t('enabler.upgrade') }}</v-toolbar-title>
						</v-toolbar>
						<v-form ref="form" v-model="valid" lazy-validation>
							<v-container>
								<v-row align="center">
									<v-col md="6" cols="12">
										<v-text-field
											filled
											:label="$t('forms.timeout')"
											color="var(--primarycolor)"
											v-model="element.timeout"
											outline
											required
											:rules="[(v) => !!v || $t('forms.timeout') + ' ' + $t('forms.required'),
											(v) => (v >= 60 && v <= 1200) || $t('forms.timeout') + $t('forms.timeoutrequired')]"
										></v-text-field>
									</v-col>
									<v-col md="6" cols="12">
										<v-select
											:items="chartVersions"
											item-text="name"
											item-value="name"
											v-model="element.enablerVersion"
											:label="$t('enabler.form.versions')"
											required
											clearable
										></v-select>
									</v-col>
									<v-col cols="12">
										<v-textarea
											filled
											:label="$t('enabler.form.values')"
											color="var(--primarycolor)"
											v-model="element.values"
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
							<v-btn color="green darken-1" text @click="upgradeEnabler(enabler.uid);upgradeEnablerDialog = false;" >{{ $t('save') }}</v-btn>
							<v-btn
								color="red darken-1"
								text
								@click="
									clearForm();
									upgradeEnablerDialog = false;
								"
								>{{ $t('cancel') }}</v-btn
							>
						</v-card-actions>
					</v-card>
				</v-dialog>
			</div>
			
			<!-- Delete enabler dialog -->
			<div class="text-center">
				<v-dialog v-model="deleteEnablerDialog" max-width="750">
					<v-card>
						<v-card-title class="headline">{{ $t('enabler.delete') }}</v-card-title>
						<v-divider></v-divider>
						<v-card-text
							><p class="font-weight-regular mt-5">
								{{ $t('enabler.deleteConfirmation') }} <strong>{{ enabler.uid }}</strong> ?
							</p></v-card-text
						>
						<v-card-actions>
							<v-spacer></v-spacer>
							<v-btn
								color="green darken-1"
								text
								@click="
									deleteEnablerDialog = false;
									deleteEnablerForceDialog = true
								"
								>{{ $t('delete') }}</v-btn
							>
							<v-btn color="red darken-1" text @click="deleteEnablerDialog = false">{{ $t('cancel') }}</v-btn>
						</v-card-actions>
					</v-card>
				</v-dialog>
			</div>

			<!-- Delete enabler force -->
			<div class="text-center">
				<v-dialog v-model="deleteEnablerForceDialog" max-width="750" persistent>
					<v-card>
						<v-card-title class="headline">{{ $t('enabler.deleteEnablerForce') }}</v-card-title>
						<v-divider></v-divider>
						<v-card-text
							><p class="font-weight-regular mt-5">
								{{ $t('enabler.deleteEnablerForceConfirmation') }} <strong>{{ enabler.uid }}</strong> ? {{ $t('enabler.deleteEnablerForceHint') }}
							</p></v-card-text
						>
						<v-card-actions>
							<v-spacer></v-spacer>
							<v-btn
								color="green darken-1"
								text
								@click="
									deleteEnablerPvcDialog = false;
									enabler.force = 'true'
									deleteEnabler(enabler.uid, false,enabler.force);
									deleteEnablerForceDialog = false
								"
								>{{ $t('yes') }}</v-btn
							>
							<v-btn
								color="red darken-1"
								text
								@click="
									deleteEnablerPvcDialog = true;
									deleteEnablerForceDialog = false
									enabler.force = 'false'

								"
								>{{ $t('no') }}
							</v-btn>
							<v-btn 
								color="red darken-1" 
								text 
								@click="
									deleteEnablerForceDialog = false
								">{{ $t('cancel') }}
							</v-btn>
						</v-card-actions>
					</v-card>
				</v-dialog>
			</div>

			<!-- Delete enabler pvc dialog -->
			<div class="text-center">
				<v-dialog v-model="deleteEnablerPvcDialog" max-width="750" persistent>
					<v-card>
						<v-card-title class="headline">{{ $t('enabler.deletePv') }}</v-card-title>
						<v-divider></v-divider>
						<v-card-text
							><p class="font-weight-regular mt-5">
								{{ $t('enabler.deletePvConfirmation') }} <strong>{{ enabler.uid }}</strong> ?
							</p></v-card-text
						>
						<v-card-actions>
							<v-spacer></v-spacer>
							<v-btn
								color="green darken-1"
								text
								@click="
									deleteEnabler(enabler.uid, true, enabler.force);
									deleteEnablerPvcDialog = false;
								"
								>{{ $t('yes') }}</v-btn
							>
							<v-btn
								color="red darken-1"
								text
								@click="
									deleteEnabler(enabler.uid, false, enabler.force);
									deleteEnablerPvcDialog = false;
								"
								>{{ $t('no') }}</v-btn
							>
						</v-card-actions>
					</v-card>
				</v-dialog>
			</div>

			<!-- Add enabler dialog -->
			<div class="text-m-center">
				<v-dialog v-model="addEnablerDialog" max-width="750">
					<v-card>
						<v-toolbar color="var(--main-85)">
							<v-btn icon light @click="addEnablerDialog = false">
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
											v-model="element.name"
											outline
											required
											:rules="[(v) => !!v || $t('forms.name') + ' ' + $t('forms.required')]"
										></v-text-field>
									</v-col>
									<v-col md="6" cols="12">
										<v-checkbox v-model="element.fullnameOverride" :label="$t('enabler.form.fullnameOverride')">
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
											v-model="element.helmChart"
											:label="$t('enabler.form.repository')"
											@change="getRepoCharts(element.helmChart)"
											required
											:rules="[(v) => !!v || $t('enabler.form.repository') + ' ' + $t('forms.required')]"
										></v-select>
									</v-col>
									<v-col md="6" cols="12">
										<v-select
											v-if="element.helmChart"
											:items="repoCharts"
											item-text="Name"
											item-value="name"
											v-model="element.enabler"
											label="Enabler"
											@change="getChartVersions(element.enabler)"
											required
											:rules="[(v) => !!v || 'Enabler ' + $t('forms.required')]"
										></v-select>
									</v-col>
									<v-col md="6" cols="12">
										<v-select
											v-show="element.enabler"
											:items="chartVersions"
											item-text="name"
											item-value="name"
											v-model="element.enablerVersion"
											:label="$t('enabler.form.versions')"
											clearable
										></v-select>
									</v-col>
									<v-col md="6" cols="12"></v-col>
									<v-col cols="12">
										<v-divider></v-divider>
									</v-col>
									<v-col cols="12">
										<h3>Deployment configuration</h3>
									</v-col>
									<v-col md="6" cols="12">
										<v-checkbox v-model="element.auto" :label="$t('enabler.form.scheduler')"></v-checkbox>
									</v-col>
									<v-col md="6" cols="12">
										<v-select
											v-if="!element.auto"
											:items="clusters"
											item-text="name"
											item-value="cluster"
											v-model="element.cluster"
											:label="$t('enabler.form.cluster')"
											@change="guardarUid()"
											:rules="[(v) => (!!v && !element.auto) || $t('enabler.form.cluster') + ' ' + $t('forms.required')]"
										></v-select>
										<v-select
											v-else
											:items="placementPolicies"
											v-model="element.placementPolicy"
											:label="$t('enabler.form.policy')"
											:rules="[(v) => (!!v && element.auto) || $t('enabler.form.policy') + ' ' + $t('forms.required')]"
										></v-select>
									</v-col>
									<v-col md="6" cols="12">
										<v-checkbox v-model="element.globalService" v-if="element.cluster == cloudCluster && !element.auto">
											<template v-slot:label>
												<v-tooltip bottom>
													<template v-slot:activator="{ on }">
														<span v-on="on">{{ $t('enabler.form.globalService') }}</span>
													</template>
													{{ $t('enabler.form.globalServiceTooltip') }}
												</v-tooltip>
											</template>
										</v-checkbox>
									</v-col>
									<v-col md="6" cols="12">
										<v-text-field
											filled
											:label="$t('forms.timeout')"
											color="var(--primarycolor)"
											v-model="element.timeout"
											outline
											required
											:rules="[(v) => !!v || $t('forms.timeout') + ' ' + $t('forms.required'),
											(v) => (v >= 60 && v <= 1200) || $t('forms.timeout') + $t('forms.timeoutrequired')]"
										></v-text-field>
									</v-col>
									<v-col cols="12">
										<v-textarea
											filled
											:label="$t('enabler.form.values')"
											color="var(--primarycolor)"
											v-model="element.values"
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
							<v-btn color="green darken-1" text @click="addEnabler()" :disabled="clusters.length == 0">{{ $t('save') }}</v-btn>
							<v-btn
								color="red darken-1"
								text
								@click="
									clearForm();
									addEnablerDialog = false;
								"
								>{{ $t('cancel') }}</v-btn
							>
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
	name: 'Enabler',
	data() {
		return {
			addEnablerDialog: false,
			chartVersions: [],
			clusters: [],
			upgradeEnablerDialog: false,
			deleteEnablerDialog: false,
			deleteEnablerPvcDialog: false,
			deleteEnablerForceDialog: false,
			editEnablerDialog: false,
			element: {},
			enabler: {},
			enablers: [],
			interval: null,
			placementPolicies: [
				{ text: this.$t('enabler.form.policies.worstFit'), value: 'worst-fit' },
				{ text: this.$t('enabler.form.policies.bestFit'), value: 'best-fit' },
				{ text: this.$t('enabler.form.policies.trafficMost'), value: 'most-traffic' }
			],
			progress: false,
			progressInfo: '',
			repoCharts: [],
			repositories: [],
			updateListResponse: '',
			tableHeaders: [
				{ text: 'ID', value: 'uid' },
				{ text: this.$t('tables.name'), value: 'name' },
				{ text: 'Helm Chart', value: 'helmChart' },
				{ text: 'Version', value: 'version' },
				{ text: this.$t('enabler.table.cluster'), value: 'cluster' },
				{ text: this.$t('enabler.table.status'), value: 'status' },
				{ text: this.$t('enabler.table.detailedStatus'), value: 'description' },
				{ text: this.$t('tables.actions'), value: 'actions' }
			],
			valid: true
		};
	},
	computed: {
		cloudCluster() {
			if (this.clusters.length === 0) return '';
			let cloudCluster = this.clusters.find((i) => i.cloud === 'true')
			if (!cloudCluster) {
				return cloudCluster
			}else{
				return cloudCluster.name
			}
		},
		globalServiceEnabled() {
			return this.element.cluster === this.cloudCluster && !this.element.auto;
		}
	},
	created() {
		this.showProgress(this.$t('enabler.progress.get'));
		this.updateEnablerList();
	},
	beforeDestroy() {
		clearInterval(this.interval);
	},
	methods: {
		guardarUid() {
			this.element.uidcluster = this.clusters.find((i) => i.name === this.element.cluster).uid	
			return
		},
		addEnabler() {
			if (this.$refs.form.validate()) {
				this.showProgress(this.$t('enabler.progress.add'));

				// create additional parameters object
				let values = this.element.values ? JSON.parse(this.element.values) : {};
				if (this.element.fullnameOverride) values.fullnameOverride = this.element.name;
				if (this.globalServiceEnabled) values.globalService = this.element.globalService;

				let body = {
					name: this.element.name,
					helmChart: this.element.helmChart + '/' + this.element.enabler,
					version: this.element.enablerVersion,
					timeout: this.element.timeout,
					auto: !!this.element.auto,
					values: values
				};
				if (this.element.auto) body.placement_policy = this.element.placementPolicy;
				else body.cluster = this.element.uidcluster;

				this.$puiRequests.postRequest(
					'/enabler/insert',
					body,
					(response) => {
						this.updateListResponse = response.data.uid
						this.interval = setInterval(() => {
							this.updateEnablerList();
						}, 2 * 1000);
					},
					(error) => {
						if (error.response.data.message.includes('500 Internal Server Error: [no body]')){
							this.interval = setInterval(() => {
								this.updateEnablerList();
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

				this.addEnablerDialog = false;
				this.clearForm();
			}
		},
		upgradeEnabler(enablerId) {
			if (this.$refs.form.validate()) {
				this.showProgress(this.$t('enabler.progress.add'));

				// create additional parameters object
				let values = this.element.values ? JSON.parse(this.element.values) : {};

				let body = {
					version: this.element.enablerVersion,
					timeout: this.element.timeout,
					values: values
				};

				this.$puiRequests.postRequest(
					'/enabler/upgrade',
					body,
					(response) => {
						this.updateListResponse = response.data.uid
						this.interval = setInterval(() => {
							this.updateEnablerList();
						}, 2 * 1000);
					},
					(error) => {
						if (error.response.data.message.includes('500 Internal Server Error: [no body]')){
							this.interval = setInterval(() => {
								this.updateEnablerList();
							}, 2 * 1000);
						}else{
							if (error.response.data.message.includes('The enabler already exists'))
							this.$puiNotify.error(this.$t('enabler.notifications.error.exist'), this.$t('error'));
							else this.$puiNotify.error(this.$t('enabler.notifications.error.deploy'), this.$t('error'));
							this.showDialog = true;
							this.progress = false;						
						}
						// pui9 notification
					},
					null, 
					{enablerId: enablerId}
				);

				this.upgradeEnablerDialog = false;
				this.clearForm();
			}
		},
		valuesRules() {
			return true;
		},
		clearForm() {
			this.$refs.form.resetValidation();
			this.$refs.form.reset();
			this.element = {};
		},
		deleteEnabler(enablerId, deletePv, force) {
			this.showProgress(this.$t('enabler.progress.delete'));
			if (deletePv) {
				this.$puiRequests.deleteRequest(
					'/enabler/volumes',
					null,
					() => {
						this.interval = setInterval(() => {
							this.updateEnablerList(enablerId);
						}, 2 * 1000);
						this.$puiRequests.deleteRequest(
							'/enabler/delete',
							null,
							() => {},
							() => {
								this.progress = false;
								this.$puiNotify.error(this.$t('enabler.notifications.error.delete'), this.$t('error'));
								this.showDialog = true;
							},
							{ enablerId: enablerId },
							{
								"Force": force,
								"Timeout": 120
							}
						);
					},
					(error) => {
						console.log(error);
						this.progress = false;
						this.$puiNotify.error(this.$t('enabler.notifications.error.deletePvc'), this.$t('error'));
						this.showDialog = true;
					},
					{ enablerId: enablerId },
				);
			} else {
				this.$puiRequests.deleteRequest(
					'/enabler/delete',
					null,
					() => {
						this.interval = setInterval(() => {
							this.updateEnablerList(enablerId, 'deleted');
						}, 2 * 1000);
					},
					(error) => {
						console.log(error);
						this.progress = false;
						this.$puiNotify.error(this.$t('enabler.notifications.error.delete'), this.$t('error'));
						this.showDialog = true;
					},
					{ enablerId: enablerId },
					{
						"Force": force,
						"Timeout": 120
					}
				);
			}

			this.deleteEnablerDialog = false;
		},
		getChartVersions(chart) {
			this.showProgress(this.$t('enabler.progress.versions'));
			setTimeout(() => {
				this.chartVersions = this.repoCharts.find((i) => i.Name == chart).versions;
				this.progress = false;
			}, 1000);
		},
		getClusters() {
			this.showProgress(this.$t('enabler.progress.clusters'));
			this.$puiRequests.getRequest(
				'/k8scluster/list',
				null,
				(response) => {
					this.clusters = response.data;
					this.getRepositories();
				},
				(error) => {
					console.log(error);
					this.progress = false;
					this.$puiNotify.error(this.$t('enabler.notifications.error.cluster'), this.$t('error'));
					this.showDialog = true;
				}
			);
		},
		getRepoCharts(repo) {
			this.showProgress(this.$t('enabler.progress.enablers'));
			this.element.enabler = null;
			this.element.enablerVersion = null;
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
		async getRepositories() {
			this.showProgress(this.$t('enabler.progress.repositories'));
			this.$puiRequests.getRequest(
				'/helmrepository/list',
				null,
				(response) => {
					this.repositories = response.data;
					this.progress = false;
				},
				(error) => {
					console.log(error);
					this.progress = false;
				}
			);
		},
		getRepoUrl(repo) {
			return this.repositories.find((i) => i.name == repo).uid;
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
		showProgress(info) {
			this.progressInfo = info;
			this.progress = true;
		},
		updateEnablerList(enablerId) {
			this.$puiRequests.getRequest(
				'/enabler/list',
				null,
				(response) => {
					this.enablers = response.data;
					if (enablerId) {
						let enabler = response.data.find((i) => i.uid === enablerId);

						// an enabler can have "failed" status (e.g. timeout)
						if (!enabler || enabler.status == 'Error' || enabler.status == 'Enabled') {
							clearInterval(this.interval);
							this.progress = false;
						}
					} else if (enablerId === undefined) {
						this.progress = false;
						let enabler = this.enablers.find((i) => i.status === 'Pending');
						if (enabler === undefined){
							clearInterval(this.interval);
						}
					} else {
						this.progress = false;
					}
				},
				() => {
					clearInterval(this.interval);
					this.progress = false;
					// pui9 notification
					this.$puiNotify.error(this.$t('enabler.notifications.error.enablers'), this.$t('error'));
					this.showDialog = true;
				}
			);
		},
		getEnablerVersionFromHelmChart(helmChart){
			let chartName = helmChart.split('/')
			this.$puiRequests.getRequest(
				'/helmrepository/list',
				null,
				(response) => {
					this.repositories = response.data;
					let repoId = this.repositories.find((i) => i.name == chartName[0]).uid
					this.$puiRequests.getRequest(
						'/helmrepository/charts',
						{ repoId: repoId },
						(response) => {
							this.repoCharts = response.data;
							this.getChartVersions(chartName[1])
						},
						(error) => {
							console.log(error);
							this.progress = false;
							this.$puiNotify.error(this.$t('enabler.notifications.error.charts'), this.$t('error'));
							this.showDialog = true;
						}
					);
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

.v-data-table >>> a {
	text-decoration: none !important;
	color: var(--primarycolor) !important;
}

div >>> .v-input--selection-controls__input {
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

</style>
