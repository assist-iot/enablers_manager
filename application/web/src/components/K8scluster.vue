<template>
	<v-container>
		<v-row justify="space-around" style="max-height: 85vmin" >
						<!-- Menu Buttons -->
			<v-col cols="12" sm="12" class="text-right" style="min-height: 90px">
				<v-btn large dark color="var(--main-25)" @click="addClusterDialog = true">
					<v-icon dark left>add_circle</v-icon>
					{{ $t('k8scluster.new') }}
				</v-btn>
			</v-col>

			<!-- Clusters table -->
			<v-col cols="12" class="rounded-card">
				<v-data-table :headers="tableHeaders" :items="clusters" :no-data-text="$t('k8scluster.noData')" class="rounded-table">
					<template v-slot:item.actions="{ item }">
						<v-tooltip bottom>
							<template v-slot:activator="{ on }">
								<v-btn
									icon
									v-on="on"
									@click="
										deleteClusterDialog = true;
										device = item;
									"
								>
									<v-icon>cancel</v-icon>
								</v-btn>
							</template>
							<span>{{ $t('k8scluster.delete') }}</span>
						</v-tooltip>
					</template>
				</v-data-table>
			</v-col>

			<!-- Delete cluster dialog -->
			<div class="text-center">
				<v-dialog v-model="deleteClusterDialog" max-width="750">
					<v-card>
						<v-card-title class="headline">{{ $t('k8scluster.delete') }}</v-card-title>
						<v-divider></v-divider>
						<v-card-text
							><p class="font-weight-regular mt-5">
								{{ $t('k8scluster.deleteConfirmation') }} <strong>{{ device.uid }}</strong> ?
							</p></v-card-text
						>
						<v-card-actions>
							<v-spacer></v-spacer>
							<v-btn 
								color="green darken-1" 
								text 
								@click="
									deleteClusterForceDialog = true
									deleteClusterDialog = false
								">{{ $t('delete') }}</v-btn>
							<v-btn 
								color="red darken-1" 
								text 
								@click="
									deleteClusterDialog = false
								">{{ $t('cancel') }}</v-btn>
						</v-card-actions>
					</v-card>
				</v-dialog>
			</div>

			<!-- Delete cluster force dialog -->
			<div class="text-center">
				<v-dialog v-model="deleteClusterForceDialog" max-width="750" persistent>
					<v-card>
						<v-card-title class="headline">{{ $t('enabler.deleteClusterForce') }}</v-card-title>
						<v-divider></v-divider>
						<v-card-text
							><p class="font-weight-regular mt-5">
								{{ $t('enabler.deleteClusterForceConfirmation') }} <strong>{{ device.uid }}</strong> ? {{ $t('enabler.deleteClusterForceHint') }}
							</p></v-card-text
						>
						<v-card-actions>
							<v-spacer></v-spacer>
							<v-btn
								color="green darken-1"
								text
								@click="
									deleteCluster(device.uid, 'true')
									deleteClusterForceDialog = false
								"
								>{{ $t('yes') }}</v-btn
							>
							<v-btn
								color="red darken-1"
								text
								@click="
									deleteCluster(device.uid, 'false')
									deleteClusterForceDialog = false
								"
								>{{ $t('no') }}
							</v-btn>
							<v-btn 
								color="red darken-1" 
								text 
								@click="
									deleteClusterForceDialog = false
								">{{ $t('cancel') }}
							</v-btn>
						</v-card-actions>
					</v-card>
				</v-dialog>
			</div>

			<!-- Add cluster dialog -->
			<div class="text-m-center">
				<v-dialog v-model="addClusterDialog" max-width="750">
					<v-card  class="rounded-card ">
						<v-toolbar color="var(--main-85)">
							<v-btn icon light @click="addClusterDialog = false">
								<v-icon>close</v-icon>
							</v-btn>
							<v-toolbar-title light >{{ $t('k8scluster.new') }}</v-toolbar-title>
							<v-spacer></v-spacer>
						</v-toolbar>
						<v-form ref="fileform" v-model="fileform" lazy-validation v-if="!isForm">
							<v-container>
								<v-row align="center">
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
										<v-text-field
											filled
											:label="$t('forms.description')"
											color="var(--primarycolor)"
											v-model="element.description"
											outline
											required
											:rules="[(v) => !!v || $t('forms.description') + ' ' + $t('forms.required')]"
										></v-text-field>
									</v-col>
									<v-col md="6" cols="12">
										<v-select
											:items="cnis"
											v-model="element.cni"
											:label="$t('k8scluster.form.cni')"
											required
											:rules="[(v) => !!v || $t('k8scluster.form.cni') + ' ' + $t('forms.required')]"
										></v-select>
									</v-col>
									<v-col md="6" cols="12">
										<v-checkbox v-model="element.cloud" :label="$t('k8scluster.form.cloud')">
											<template v-slot:label>
												<v-tooltip bottom>
													<template v-slot:activator="{ on }">
														<span v-on="on">{{ $t('k8scluster.form.cloud') }}</span>
													</template>
													{{ $t('k8scluster.form.cloudToolTip') }}
												</v-tooltip>
											</template>
										</v-checkbox>
									</v-col>
									<v-col md="12" cols="12">
										<v-file-input
											:label="$t('k8scluster.form.file')"
											accept="application/json,.yaml,.yml"
											truncate-length="15"
											show-size
											v-model="element.file"
											:rules="[
												(v) => !!v,
												(v) =>
													(!!v && (v.type == 'application/json' || v.name.endsWith('.yml') || v.name.endsWith('.yaml'))) ||
													$t('k8scluster.form.validKubeconfig')
											]"
										></v-file-input>
									</v-col>
								</v-row>
							</v-container>
						</v-form>
						<v-card-actions>
							<v-spacer></v-spacer>
							<v-btn color="green darken-1" text @click="addCluster()">{{ $t('save') }}</v-btn>
							<v-btn
								color="red darken-1"
								text
								@click="
									clearForm();
									addClusterDialog = false;
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
	name: 'K8sCluster',
	data() {
		return {
			addClusterDialog: false,
			clusters: [],
			deleteClusterDialog: false,
			device: {},
			editClusterDialog: false,
			element: {},
			fileform: false,
			deleteClusterForceDialog: false,
			form: false,
			interval: null,
			progress: false,
			progressInfo: '',
			tableHeaders: [
				{ text: 'ID', value: 'uid' },
				{ text: this.$t('tables.name'), value: 'name' },
				{ text: this.$t('k8scluster.table.server'), value: 'credentials.clusters[0].cluster.server' },
				{ text: this.$t('tables.status'), value: 'status' },
				{ text: this.$t('tables.cloud'), value: 'cloud' },
				{ text: this.$t('tables.cni'), value: 'cni' },
				{ text: this.$t('tables.actions'), value: 'actions' }
			],
			cnis: [
				{ text: 'Cilium', value: 'cilium' },
				{ text: 'Flannel', value: 'flannel' },
			],
		};
	},
	created() {
		this.showProgress(this.$t('k8scluster.progress.get'));
		this.updateClusterList();
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
		addCluster() {
			const isValid = this.isForm ? this.$refs.form.validate() : this.$refs.fileform.validate();
			if (isValid) {
				this.showProgress(this.$t('k8scluster.progress.add'));

				let formData = new FormData();
				formData.append('file', this.element.file);
				formData.append('name', this.element.name);
				formData.append('description', this.element.description);
				formData.append('cloud', !!this.element.cloud);
				formData.append('cni', this.element.cni);

				this.$puiRequests.postRequest(
					'/k8scluster/insert/file',
					formData,
					(response) => {
						this.updateClusterList(response.data.id, ['Enabled', 'Degraded']);
					},
					(error) => {
						console.log(error);
						this.progress = false;
						// pui9 notification
						this.$puiNotify.error(this.$t('k8scluster.notifications.error.add'), this.$t('error'));
						this.showDialog = true;
					},
					{
						'Content-Type': 'multipart/form-data'
					}
				);
				

				this.addClusterDialog = false;
				this.clearForm();
			}
		},
		clearForm() {
			if (this.isForm) {
				this.$refs.form.resetValidation();
				this.$refs.form.reset();
			} else {
				this.$refs.fileform.resetValidation();
				this.$refs.fileform.reset();
			}

			this.element = {};
			this.isForm = false;
		},
		buildClusterBody() {
			let users = [
				{
					name: this.element.username,
					user: {
						'client-certificate-data': this.element.clientCert,
						'client-key-data': this.element.clientKey
					}
				}
			];
			let contexts = [
				{
					context: {
						cluster: this.element.name,
						name: this.element.username
					},
					name: this.element.username + '@kubernetes'
				}
			];

			let body = {
				name: this.element.name,
				description: this.element.description,
				credentials: {
					apiVersion: 'v1',
					clusters: [
						{
							cluster: {
								'certificate-authority-data': this.element.authCert,
								server: this.element.server
							},
							name: this.element.name
						}
					],
					contexts: contexts,
					'current-context': this.element.username + '@kubernetes',
					kind: 'Config',
					preferences: {},
					users: users
				},
				cloud: !!this.element.cloud,
				cni: this.element.cni
			};
			return body;
		},
		deleteCluster(clusterId, force) {
			this.showProgress(this.$t('k8scluster.progress.delete'));
			this.$puiRequests.deleteRequest(
				'/k8scluster/delete',
				null,
				() => {
					this.interval = setInterval(() => {
						this.updateClusterList(clusterId, ['DELETED']);
					}, 2 * 1000);
				},
				(error) => {
					console.log(error);
					this.progress = false;

					if (error.response.data.message.includes('409 Conflict'))
						this.$puiNotify.error(this.$t('k8scluster.notifications.error.enabler'), this.$t('error'));
					else this.$puiNotify.error(this.$t('k8scluster.notifications.error.delete'), this.$t('error'));
					this.showDialog = true;
				},
				{clusterId: clusterId},
				{"Force": force}
			);
			this.deleteClusterDialog = false;
		},
		showProgress(info) {
			this.progressInfo = info;
			this.progress = true;
		},
		updateClusterList(clusterId, status) {
			this.$puiRequests.getRequest(
				'/k8scluster/list',
				null,
				(response) => {
					this.clusters = response.data;

					if (clusterId) {
						let cluster = response.data.find((i) => i.id === clusterId);
						if (!cluster || status.includes(cluster.admin.operationalState)) {
							clearInterval(this.interval);
							this.progress = false;
						}
					} else {
						this.progress = false;
					}
				},
				() => {
					clearInterval(this.interval);
					this.progress = false;
					// pui9 notification
					this.$puiNotify.error(this.$t('k8scluster.notifications.error.clusters'), this.$t('error'));
					this.showDialog = true;
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

.v-sheet .theme--light .v-toolbar {
	/* Elimina los estilos de Vuetify */
	background-color: #d8d9fb !important;
}
</style>
