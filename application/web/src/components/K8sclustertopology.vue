<template>
	<div class="topology">
		<div class="topology" ref="topology"></div>
		<div class="text-m-center">
			<!-- Cluster dialog -->
			<v-dialog v-model="clusterDialog" max-width="600">
				<v-card>
					<v-toolbar color="var(--main-85)">
						<v-btn icon light @click="clusterDialog = false">
							<v-icon>close</v-icon>
						</v-btn>
						<v-toolbar-title light>
							{{ $t('k8sclustertopology.clusterEnablers') }}<i>{{ selectedCluster }}</i>
						</v-toolbar-title>
					</v-toolbar>
					<v-list disabled>
						<v-list-item-group v-if="enablers.length > 0" v-model="selectedEnabler" color="primary">
							<v-list-item v-for="(item, i) in enablers" :key="i">
								<v-list-item-icon>
									<v-icon>fa-check</v-icon>
								</v-list-item-icon>
								<v-list-item-content>
									<v-list-item-title v-text="item.name"></v-list-item-title>
									<v-list-item-subtitle v-text="item.helmChart"></v-list-item-subtitle>
								</v-list-item-content>
							</v-list-item>
						</v-list-item-group>
						<v-list-item-group v-else v-model="selectedEnabler" color="primary">
							<v-list-item>
								<v-list-item-icon>
									<v-icon>fa-empty-set</v-icon>
								</v-list-item-icon>
								<v-list-item-content>
									<v-list-item-title>{{ $t('k8sclustertopology.noEnablers') }}</v-list-item-title>
								</v-list-item-content>
							</v-list-item>
						</v-list-item-group>
					</v-list>
					<v-card-actions>
						<v-spacer></v-spacer>
						<v-btn color="green darken-1" text @click="clusterDialog = false">OK</v-btn>
					</v-card-actions>
				</v-card>
			</v-dialog>
			<!-- Node dialog -->
			<div class="text-m-center">
				<v-dialog v-model="nodeDialog" max-width="750" eager>
					<v-card>
						<v-toolbar color="var(--main-85)">
							<v-btn icon light @click="nodeDialog = false">
								<v-icon>close</v-icon>
							</v-btn>
							<v-toolbar-title light>
								{{ $t('k8sclustertopology.newEnabler') }}<i>{{ selectedNode != null ? selectedNode.name : '' }}</i>
							</v-toolbar-title>
						</v-toolbar>
						<v-form ref="enablerForm" v-model="valid" lazy-validation>
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
									<v-col cols="12">
										<v-divider></v-divider>
									</v-col>
									<v-col cols="12">
										<h3>Deployment configuration</h3>
									</v-col>
									<v-col cols="12">
										<v-text-field
											filled
											:label="$t('forms.timeout')"
											color="var(--primarycolor)"
											v-model="element.timeout"
											outline
											required
											:rules="[(v) => !!v || $t('forms.timeout') + ' ' + $t('forms.required'),
											(v) => (v >= 60 && v <= 1200) || $t('forms.timeout') + ' debe estar entre 60 y 1200']"
										></v-text-field>
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
							<v-btn color="green darken-1" text @click="deployEnablerInNode()">{{ $t('save') }}</v-btn>
							<v-btn
								color="red darken-1"
								text
								@click="
									clearNodeForm();
									nodeDialog = false;
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
		</div>
	</div>
</template>

<script>
export default {
	name: 'K8sclustertopology',
	data() {
		return {
			chart: null,
			chartData: {},
			chartVersions: [],
			clusters: [],
			clusterDialog: false,
			element: {},
			enabler: {},
			enablers: [],
			noClustersModal: null,
			nodeDialog: false,
			progress: false,
			progressInfo: '',
			repoCharts: [],
			repositories: [],
			selectedCluster: null,
			selectedEnabler: null,
			selectedNode: null,
			valid: true
		};
	},
	computed: {
		cloudCluster() {
			if (this.clusters.length === 0) return '';
			console.log(this.clusters)
			return this.clusters.find((i) => i.cloud === 'true').name	
		},
		globalServiceEnabled() {
			return this.element.cluster === this.cloudCluster && !this.element.auto;
		}
	},
	mounted() {
		this.getClusterList();
	},
	beforeDestroy() {
		if (this.chart) this.chart.dispose();
	},
	methods: {
		clearNodeForm() {
			this.$refs.enablerForm.resetValidation();
			this.$refs.enablerForm.reset();
			this.element = {};
		},
		deployEnablerInNode() {
			if (this.$refs.enablerForm.validate()) {
				this.showProgress(this.$t('enabler.progress.add'));

				// create additional parameters object
				let values = this.element.values ? JSON.parse(this.element.values) : {};
				values.enablerNodeSelector = this.selectedNode.labels;
				if (this.element.fullnameOverride) values.fullnameOverride = this.element.name;
				if (this.globalServiceEnabled) values.globalService = this.element.globalService;

				let body = {
					name: this.element.name,
					helmChart: this.element.helmChart + '/' + this.element.enabler,
					version: this.element.enablerVersion,
					timeout: this.element.timeout,

					auto: false,
					cluster: this.selectedNode.cluster,
					values: values
				};
				console.log(body)
				this.$puiRequests.postRequest(
					'/enabler/insert',
					body,
					() => {
						this.progress = false;
						this.$puiNotify.success(
							this.$t('k8sclustertopology.notifications.success.enabler'),
							this.$t('k8sclustertopology.notifications.success.enablerHeader')
						);
						this.showDialog = true;
					},
					(error) => {
						console.log(error);
						this.progress = false;
						if (error.response.data.message.includes('500 Internal Server Error: [no body]')){
							this.$puiNotify.success(
							this.$t('k8sclustertopology.notifications.success.enabler'),
							this.$t('k8sclustertopology.notifications.success.enablerHeader')
							)
						}else if(error.response.data.message.includes('The enabler already exists')){
							this.$puiNotify.error(this.$t('k8sclustertopology.notifications.error.exist'), this.$t('error'));
						}else this.$puiNotify.error(this.$t('k8sclustertopology.notifications.error.deploy'), this.$t('error'));
						// pui9 notification						
						this.showDialog = true;
					}
				);

				this.nodeDialog = false;
				this.clearNodeForm();
			}
		},
		drawChart() {
			const self = this;
			let root = this.$am5.Root.new(this.$refs.topology);
			root.setThemes([this.$am5themes_Animated.new(root)]);

			var container = root.container.children.push(
				this.$am5.Container.new(root, {
					width: this.$am5.percent(100),
					height: this.$am5.percent(100),
					layout: root.verticalLayout
				})
			);

			// this.noClustersModal = this.$am5.Modal.new(root, {
			// 	content: 'There are no clusters available'
			// });
			// this.noClustersModal.open();

			var series = container.children.push(
				this.$am5hierarchy.ForceDirected.new(root, {
					singleBranchOnly: false,
					downDepth: 1,
					topDepth: 1,
					// maxRadius: 75,
					minRadius: 20,
					valueField: 'value',
					categoryField: 'name',
					childDataField: 'children',
					idField: 'name',
					linkWithStrength: 0.3,
					linkWithField: 'linkWith',
					manyBodyStrength: -20,
					centerStrength: 0.5
				})
			);

			// click
			series.nodes.template.events.on('click', function (e) {
				if (e.target.dataItem.dataContext.isNode === true) {
					self.clearNodeForm();
					self.selectedNode = e.target.dataItem.dataContext;
					self.getRepositories();
				} else {
					self.selectedCluster = e.target.dataItem.dataContext.name;
					self.getEnablersFromCluster(e.target.dataItem.dataContext.uid);
					self.clusterDialog = true;
				}
			});

			// circles
			series.circles.template.setAll({
				fillOpacity: 0,
				strokeWidth: 1,
				strokeOpacity: 0
			});

			// Disable circles
			// series.circles.template.set('forceHidden', true);
			series.outerCircles.template.set('forceHidden', true);

			// ... except for central node
			// series.circles.template.adapters.add('forceHidden', function (forceHidden, target) {
			// 	// return target.dataItem.get('depth') == 0 ? false : forceHidden;
			// 	return !target.dataItem.dataContext.isNode;
			// });
			// series.outerCircles.template.adapters.add('forceHidden', function (forceHidden, target) {
			// 	// return target.dataItem.get('depth') == 0 ? false : forceHidden;
			// 	return target.dataItem.dataContext.isNode;
			// });

			// Set up labels
			series.labels.template.setAll({
				fill: this.$am5.color(0x000000),
				// y: 50,
				// centerY: this.$am5.percent(-200),
				//y: this.$am5.percent(10),
				oversizedBehavior: 'none',
				fontSize: 18,
				fontWeight: '500'
				// text: '{category}'
			});

			series.labels.template.adapters.add('centerY', function (centerY, target) {
				return target.dataItem.dataContext.isNode ? self.$am5.percent(-175) : self.$am5.percent(-300);
			});

			// disable tooltip
			series.nodes.template.set('tooltipText', '');

			// Use template.setup function to prep up node with an image
			series.nodes.template.setup = function (target) {
				target.events.on('dataitemchanged', function (ev) {
					target.children.push(
						self.$am5.Picture.new(root, {
							width: ev.target.dataItem.dataContext.isNode ? 85 : 125,
							height: ev.target.dataItem.dataContext.isNode ? 85 : 125,
							centerX: self.$am5.percent(50),
							centerY: self.$am5.percent(50),
							src: ev.target.dataItem.dataContext.image
						})
					);
				});
			};

			series.nodes.template.setAll({
				// draggable: false,
				toggleKey: 'none',
				cursorOverStyle: 'pointer'
			});

			this.chartData = {
				// name: 'Root',
				value: 0,
				children: []
			};

			this.clusters.forEach((i) => {
				let cluster = {
					uid: i.uid,
					name: i.name,
					value: 2,
					image: require('@/assets/k8scluster.png'),
					isNode: false,
					children: []
				};
				this.$puiRequests.getRequest(
					'/k8scluster/nodes/' + i.uid,
					null,
					(response) => {
						response.data.forEach((j) => {
							cluster.children.push({
								name: j.name,
								value: 1,
								isNode: true,
								cluster: i.uid,
								labels: j.labels,
								image: require('@/assets/k8s_' +
									('node-role.kubernetes.io/control-plane' in j.labels ? 'master' : 'worker') +
									'_node.png')
							});
						});
						console.log(cluster)
						this.chartData.children.push(cluster);
						this.progress = false;
						series.data.setAll([this.chartData]);
					},
					(error) => {
						console.log(error);
						this.progress = false;
						// pui9 notification
						this.chartData.children.push(cluster);
						this.$puiNotify.error(this.$t('k8sclustertopology.notifications.error.nodes'), this.$t('error'));
						this.showDialog = true;
					}
				);
			});

			series.set('selectedDataItem', series.dataItems[0]);

			// Make stuff animate on load
			series.appear(1000, 100);

			this.chart = root;
		},
		getChartVersions(chart) {
			this.showProgress(this.$t('enabler.progress.versions'));
			setTimeout(() => {
				this.chartVersions = this.repoCharts.find((i) => i.Name == chart).versions;
				this.progress = false;
			}, 1000);
		},
		getClusterList() {
			this.showProgress(this.$t('k8sclustertopology.progress.cluster'));
			this.$puiRequests.getRequest(
				'/k8scluster/list',
				null,
				(response) => {
					this.clusters = response.data;
					if (this.clusters.length > 0) this.drawChart();
					else this.$puiNotify.error(this.$t('k8sclustertopology.notifications.error.noClusters'), this.$t('error'));
					this.progress = false;
				},
				(error) => {
					console.log(error);
					this.progress = false;
					// pui9 notification
					this.$puiNotify.error(this.$t('k8sclustertopology.notifications.error.clusters'), this.$t('error'));
					this.showDialog = true;
				}
			);
		},
		getEnablersFromCluster(clusterId) {
			this.showProgress(this.$t('k8sclustertopology.progress.enablers'));
			this.$puiRequests.getRequest(
				'/enabler/cluster',
				{ clusterId: clusterId },
				(response) => {
					this.enablers = response.data;
					// TODO add a message of "no clusters available"
					this.progress = false;
					this.clusterDialog = true;
				},
				(error) => {
					console.log(error);
					this.progress = false;
					// pui9 notification
					this.$puiNotify.error(this.$t('k8sclustertopology.notifications.error.enablers'), this.$t('error'));
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
					this.$puiNotify.error(this.$t('k8sclustertopology.notifications.error.charts'), this.$t('error'));
					this.showDialog = true;
				}
			);
		},
		getRepositories() {
			this.showProgress(this.$t('enabler.progress.repositories'));
			this.$puiRequests.getRequest(
				'/helmrepository/list',
				null,
				(response) => {
					this.repositories = response.data;
					this.progress = false;
					this.nodeDialog = true;
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
				JSON.parse(str);
			} catch (e) {
				return false;
			}
			return true;
		},
		showProgress(info) {
			this.progressInfo = info;
			this.progress = true;
		}
	}
};
</script>

<style>
.topology {
	width: 100%;
	height: 100%;
	position: absolute;
}
</style>
