<template>
	<v-container v-if="repoCharts.length === 0">
		<v-row justify="space-around" style="max-height: 100vmin">
			<v-col cols="12" sm="6" v-for="(card, index) in repositories" :key="index">
				<v-card class="card-rounded text-center">
					<v-card-text>
						<v-row align="center">
							<!-- Columna para la imagen -->
							<v-col cols="auto">
								<v-avatar size="50px">
									<v-img
										alt="Avatar"
										src="@/assets/repositorio.png"
									></v-img>
								</v-avatar>
							</v-col>

							<!-- Columna para el texto (alineado a la izquierda) -->
							<v-col>
								<h6 class="text-h6">
									{{ card.name }}-Repo
								</h6>
							</v-col>

							<!-- Columna para el botón (alineado a la derecha) -->
							<v-col cols="auto">
								<v-btn
									large 
									dark 
									color="var(--main-25)"
									@click="
										plugins = true;
										getRepoCharts(card.uid, card.name)
									"
								>
								{{ $t('plugins.select') }}
								</v-btn>
							</v-col>
						</v-row>
					</v-card-text>
				</v-card>
			</v-col>
		</v-row>
	</v-container>
	<v-container v-else>
		<v-row  justify="space-around" style="max-height: 100vmin">
			<v-col v-for="(card, index) in repoCharts" :key="index" cols="6" sm="6" >
				<v-card class="card-rounded text-center">
					<v-card-text>
						<v-row align="center">
							<!-- Columna para la imagen -->
							<v-col cols="auto">
								<v-avatar size="50px">
									<v-img
										alt="Avatar"
										src="@/assets/enabler.png"
									></v-img>
								</v-avatar>
							</v-col>

							<!-- Columna para el texto (alineado a la izquierda) -->
							<v-col>
								<h6 class="text-h6">
									{{ card.Name }}
								</h6>
							</v-col>

							<!-- Columna para el botón (alineado a la derecha) -->
							<v-col v-if="card.installable == false || card.status == 'Enabled'" cols="auto">
								<v-btn 	
									large
									class = "button-rounded"
									dark color="green" 
									@click="
										filterModal(card.url)">
								{{ $t('plugins.show') }}
								</v-btn>
							</v-col>
							<v-col v-else cols="auto">
								<v-btn 	
									large 
									dark color="var(--main-25)" 
									@click="
										values=card.enabler.values,
										enabler = card.enabler
										addEnablerDialog=true">
								{{ $t('plugins.install') }}
								</v-btn>
							</v-col>
						</v-row>
					</v-card-text>
				</v-card>
			</v-col>
		</v-row>
		
		<!-- Add enabler dialog -->
		<div class="text-m-center">
			<v-dialog v-model="addEnablerDialog" max-width="750">
				<v-card>
					<v-toolbar color="var(--primarycolor)">
						<v-btn icon dark @click="addEnablerDialog = false">
							<v-icon>close</v-icon>
						</v-btn>
						<v-toolbar-title class="white--text">{{ $t('enabler.new') }}</v-toolbar-title>
					</v-toolbar>
					<v-form ref="form"  lazy-validation>
						<v-container>
							<v-row align="center">
								<v-col cols="12">
									<v-textarea
										filled
										:label="$t('enabler.form.values')"
										color="var(--primarycolor)"
										v-model="valuesJSON"
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
						<v-btn color="green darken-1" text @click="addEnabler()">{{ $t('save') }}</v-btn>
						<v-btn
							color="red darken-1"
							text
							@click="
								addEnablerDialog = false;
							"
							>{{ $t('cancel') }}</v-btn
						>
					</v-card-actions>
				</v-card>
			</v-dialog>
		</div>
		<div class="text-m-center">
			<v-dialog v-model="filterDialog" transition="dialog-bottom-transition" max-width="1440">
				<BusinesskpiComponent :src="url"/>
			</v-dialog>
		</div>
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
	</v-container>	
</template>
<script>
import BusinesskpiComponent from './Businesskpi.vue'

export default {
	name: 'BusinessKpi',
	components: {
		BusinesskpiComponent
	},
	data() {
		return {
			repositories:[],
			progress: false,
			plugins: false,
			repoCharts:[],
			clusterCloud: "",
			repositorySelected: "",
			filterDialog: false,
			progressInfo: '',
			enablersList: [],
			enabler:{},
			pluginsAvailable:[
				{"name":"bkpi", "url": "/kibana/", "installable":true, "enabler":{
					"name":"bkpi",
					"helmChart": "",
					"values": {
						"kibana": {
							"envVars": {
							"elasticsearchHost": "http://smart-ltse-api.asdo:8080/nosql/api"
							},
							"kibanaConfig": {
							"kibana.yml": "server.host: \"0.0.0.0\"\nserver.basePath: /kibana\n"
							}
						}
					},
					"cluster": "",
					"version": "0.1.3",
					"timeout": 300,
					"auto": false,
					"placement_policy":""
					},
					"status":""
				},
				{"name":"authorization", "url": "/authzserver", "installable":false,"values":{}},
				{"name":"openapi", "url": "/konga", "installable":false,"values":{}},
				{"name":"puddash", "url": "/grafana", "installable":true, "enabler":{
					"name":"puddash",
					"helmChart": "",
					"values": {
					
					},
					"cluster": "",
					"version": "1.0.1",
					"timeout": 300,
					"auto": false,
					"placement_policy":""
					},
					"status":""
				},
				{"name":"siempilot", "url": "/siem/", "installable":true, "enabler":{
					"name":"siempilot",
					"helmChart": "",
					"values": {},
					"cluster": "",
					"version": "0.1.0",
					"timeout": 300,
					"auto": false,
					"placement_policy":""
					},
					"status":""
				}],
			url:"",
			addEnablerDialog: false,
			values:""
		};
	},
	created() {
		this.updateClusterList()
		this.updateEnablerList()
		this.repoCharts=[]
	},
	methods:{
		updateClusterList() {
			this.$puiRequests.getRequest(
				'/k8scluster/list',
				null,
				(response) => {
					let cluster = response.data.find((i) => i.cloud === "true" & i.status === "Enabled");
					if (Object.entries(cluster).length === 0){
						this.repositories == {}
					}else{
						this.clusterCloud = cluster.uid
						this.getRepositories()
					}
				},
				() => {
					clearInterval(this.interval);
					this.progress = false;
					// pui9 notification
					this.$puiNotify.error(this.$t('k8scluster.notifications.error.clusters'), this.$t('error'));
					// this.showDialog = true;
				}
			);
		},
		async getRepositories() {
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
		getRepoCharts(repo, repoName) {
			this.repositorySelected = repoName
			this.$puiRequests.getRequest(
				'/helmrepository/charts',
				{ repoId: repo },
				(response) => {
					let pluginsAll = response.data;
					this.repoCharts = pluginsAll.map(plugin => {
						const matchingPlugin = this.pluginsAvailable.find(availablePlugin => availablePlugin.name === plugin.Name);
						if (matchingPlugin) {
							const objetoEnOtroJSON = this.enablersList.find(item => item.name === plugin.Name);
							if(plugin.Name == "siempilot"){ plugin.Name = "siem" }
							return {
							Name: plugin.Name,
							url: matchingPlugin.url,
							installable: matchingPlugin.installable,
							enabler: matchingPlugin.enabler,
							status: objetoEnOtroJSON ? objetoEnOtroJSON.status : ""
							};
						}
						return null; // O puedes manejar de otra manera si no encuentras una coincidencia
					}).filter(Boolean); // Elimina elementos nulos
				},
				() => {
					this.progress = false;
					this.$puiNotify.error(this.$t('enabler.notifications.error.charts'), this.$t('error'));
				}
			);
		},
		filterModal(url) {
			this.filterDialog = true;
			this.url = url
		},
		addEnabler() {
			this.showProgress(this.$t('enabler.progress.add'));
			// create additional parameters object
			let values = this.enabler.values;
			let body = {
				name: this.enabler.name,
				cluster: this.clusterCloud,
				helmChart: this.repositorySelected + '/' + this.enabler.name,
				version: this.enabler.version,
				timeout: this.enabler.timeout,
				auto: !!this.enabler.auto,
				values: values
			};

			this.$puiRequests.postRequest(
				'/enabler/insert',
				body,
				(response) => {
					this.interval = setInterval(() => {
						this.updateEnablerList(response.data.uid);
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
		},
		updateEnablerList(enablerId) {
			this.$puiRequests.getRequest(
				'/enabler/list',
				null,
				(response) => {
					this.enablersList = response.data;
					console.log(this.enablersList)
					if (enablerId) {
						let enabler = response.data.find((i) => i.uid === enablerId);
						// an enabler can have "failed" status (e.g. timeout)
						if (!enabler || enabler.status == 'Error' || enabler.status == 'Enabled') {
							let index = this.repoCharts.findIndex(object => object.Name === enabler.name);
							if (index !== -1) {
								this.repoCharts[index].status = enabler.status;
								console.log(this.repoCharts)
							}
							clearInterval(this.interval);
							this.progress = false;
						}
					} else if (enablerId === undefined) {
						this.progress = false;
						let enabler = this.enablersList.find((i) => i.status === 'Pending');
						if (enabler === undefined){
							clearInterval(this.interval);
						}
					} else {
						this.progress = false;
					}
				},
				(error) => {
					clearInterval(this.interval);
					this.progress = false;
					console.log(error)
					// pui9 notification
					this.$puiNotify.error(this.$t('enabler.notifications.error.enablers'), this.$t('error'));
					this.showDialog = true;
				}
			);
		},
		showProgress(info) {
			this.progressInfo = info;
			this.progress = true;
		},
		isJson(str) {
			try {
				let json = JSON.parse(str);
				if (Array.isArray(json)) return false;
				else return true;
			} catch (e) {
				return false;
			}
		}
	},
	
	computed: {
		valuesJSON: {
			get() {
				return JSON.stringify(this.values, null, 2);
			},
			set(newValue) {
				try {
					this.values = JSON.parse(newValue);
				} catch (error) {
					console.error("Invalid JSON format");
				}
			}
		}
	}
};
</script>

<style>
	.v-card__subtitle, .v-card__text, .v-card__title{
		padding: 8px !important
	}
	.no-styles {
		/* Elimina los estilos de Vuetify */
		background-color: inherit !important;
		border: none !important;
		box-shadow: none !important;
		color: inherit !important;
	}
	.card-rounded {
		background-color: white !important;
		border-radius: 15px !important;
		box-shadow: 0 4px 8px rgba(1, 8, 219, 0.302) !important;
		color: inherit !important;
	}
	.button-rounded {
		border-radius: 30px !important;
		box-shadow: 0 4px 8px rgba(1, 1, 219, 0.264) !important;
	}
</style>
