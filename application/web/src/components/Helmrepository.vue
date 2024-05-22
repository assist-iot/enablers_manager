<template>
	<v-container>
		<v-row justify="space-around" style="max-height: 85vmin">
						<!-- Menu Buttons -->
			<v-col cols="12" sm="12" class="text-right" style="min-height: 90px">
				<v-btn large dark color="var(--main-25)" @click="addRepositoryDialog = true">
					<v-icon dark left>add_circle</v-icon>
					{{ $t('helmrepository.new') }}
				</v-btn>
			</v-col>

			<!-- Repositories table -->
			<v-col md="12" class="rounded-card">
				<v-data-table :headers="tableHeaders" :items="repositories" :no-data-text="$t('helmrepository.noData')" class="rounded-table">
					<template v-slot:item.actions="{ item }">
						<v-tooltip bottom>
							<template v-slot:activator="{ on }">
								<v-btn
									icon
									v-on="on"
									@click="
										deleteRepositoryDialog = true;
										repoId = item.uid;
									"
								>
									<v-icon>cancel</v-icon>
								</v-btn>
							</template>
							<span>{{ $t('helmrepository.delete') }}</span>

						</v-tooltip>
						<v-tooltip bottom>
							<template v-slot:activator="{ on }">

								<v-btn
									icon
									v-on="on"
									@click="updateRepository()"
								>
									<v-icon>update</v-icon>
								</v-btn>
							</template>
							<span>{{ $t('helmrepository.progress.update') }}</span>
						</v-tooltip>
					</template>
				</v-data-table>
			</v-col>

			<!-- Delete repository dialog -->
			<div class="text-center">
				<v-dialog v-model="deleteRepositoryDialog" max-width="750">
					<v-card>
						<v-card-title class="headline">{{ $t('helmrepository.delete') }}</v-card-title>
						<v-divider></v-divider>
						<v-card-text
							><p class="font-weight-regular mt-5">
								{{ $t('helmrepository.deleteConfirmation') }} <strong>{{ repoId }}</strong> ?
							</p></v-card-text
						>
						<v-card-actions>
							<v-spacer></v-spacer>
							<v-btn color="green darken-1" text @click="deleteRepository(repoId)">{{ $t('delete') }}</v-btn>
							<v-btn color="red darken-1" text @click="deleteRepositoryDialog = false">{{ $t('cancel') }}</v-btn>
						</v-card-actions>
					</v-card>
				</v-dialog>
			</div>

			<!-- Add repository dialog -->
			<div class="text-m-center">
				<v-dialog v-model="addRepositoryDialog" max-width="750">
					<v-card  class="rounded-card ">
						<v-toolbar color="var(--main-85)">
							<v-btn icon light @click="addRepositoryDialog = false">
								<v-icon>close</v-icon>
							</v-btn>
							<v-toolbar-title light>{{ $t('helmrepository.new') }}</v-toolbar-title>
						</v-toolbar>
						<v-form ref="form" v-model="valid" lazy-validation>
							<v-container>
								<v-row align="center">
									<v-col md="6" cols="12">
										<v-text-field
											filled
											:label="$t('forms.name')"
											color="var(--primarycolor)"
											v-model="repository.name"
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
											v-model="repository.description"
											outline
											required
										></v-text-field>
									</v-col>
									<v-col md="6" cols="12">
										<v-text-field
											filled
											label="URL"
											color="var(--primarycolor)"
											v-model="repository.url"
											outline
											required
											:rules="[
												(v) => !!v || 'URL ' + $t('forms.required'),
												(v) =>
													/^(?:(?:https?):\/\/)?(?:(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:\/\S*)?$/.test(
														v
													) || $t('forms.validUrl')
											]"
										></v-text-field>
									</v-col>
									<v-col md="6" cols="12">
										<v-checkbox v-model="repoPrivate" :label="$t('helmrepository.typePrivate')"></v-checkbox>
									</v-col>
								</v-row>
								<v-row align="center" v-if="repoPrivate">
									<v-col cols="12">
										<v-divider></v-divider>
									</v-col>
									<v-col cols="12">
										<h3>Auth</h3>
									</v-col>
									<v-col md="6" cols="12">
										<v-text-field
											filled
											label="Username"
											color="var(--primarycolor)"
											v-model="repository.auth.username"
											outline
											required
											:rules="[
												(v) => !!v || $t('helmrepository.auth.username') + ' ' + $t('forms.required')
											]"
										></v-text-field>
									</v-col>
									<v-col md="6" cols="12">
										<v-text-field
											filled
											label="Password"
											color="var(--primarycolor)"
											v-model="repository.auth.password"
											outline
											required
											:rules="[
												(v) => !!v || $t('helmrepository.auth.password') + ' ' + $t('forms.required')
											]"
										></v-text-field>
									</v-col>
								</v-row>	
							</v-container>
						</v-form>
						<v-card-actions>
							<v-spacer></v-spacer>
							<v-btn color="green darken-1" text @click="addRepository(repoPrivate)">{{ $t('save') }}</v-btn>
							<v-btn
								color="red darken-1"
								text
								@click="
									clearForm();
									addRepositoryDialog = false;
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
	name: 'Helmrepository',
	data() {
		return {
			addRepositoryDialog: false,
			deleteRepositoryDialog: false,
			interval: null,
			progress: false,
			repoPrivate: false,
			progressInfo: '',
			repoId: '',
			repositories: [],
			repository: {auth:{}},
			tableHeaders: [
				{ text: 'ID', value: 'uid' },
				{ text: this.$t('tables.name'), value: 'name' },
				{ text: this.$t('tables.description'), value: 'description' },
				{ text: 'URL', value: 'url' },
				{ text: this.$t('tables.status'), value: 'status' },
				{ text: this.$t('tables.type'), value: 'type' },
				{ text: this.$t('tables.actions'), value: 'actions' }
			],
			valid: true
		};
	},
	created() {
		this.showProgress(this.$t('helmrepository.progress.get'));
		this.updateRepositoryList();
	},
	beforeDestroy() {
		clearInterval(this.interval);
	},
	methods: {
		addRepository(repoPrivate) {
			if (this.$refs.form.validate()) {
				this.showProgress(this.$t('helmrepository.progress.add'));
				if (!repoPrivate) {
					this.$puiRequests.postRequest(
						'/helmrepository/insert/public',
						this.repository,
						() => {
							this.updateRepositoryList();
						},
						(error) => {
							console.log(error);
							this.progress = false;
						}
					);
				}else{
					this.$puiRequests.postRequest(
						'/helmrepository/insert/private',
						this.repository,
						() => {
							this.updateRepositoryList();
						},
						(error) => {
							console.log(error);
							this.progress = false;
						}
					);
				}

				this.addRepositoryDialog = false;
				this.clearForm();
			}
		},
		updateRepository() {
			this.showProgress(this.$t('helmrepository.progress.update'));
			this.$puiRequests.postRequest(
				'/helmrepository/update',
				null,
				() => {
					this.progress = false;
				},
				(error) => {
					console.log(error);
					this.progress = false;
				},
				null
			);
		},
		clearForm() {
			this.$refs.form.resetValidation();
			this.$refs.form.reset();
			this.repository = {};
		},
		convertDate(inputFormat) {
			var d = new Date(inputFormat);
			return d.toLocaleString().replace(',', '');
		},
		deleteRepository(repositoryId) {
			this.showProgress(this.$t('helmrepository.progress.delete'));
			this.$puiRequests.deleteRequest(
				'/helmrepository/delete',
				null,
				() => {
					this.interval = setInterval(() => {
						this.updateRepositoryList(repositoryId);
					}, 2 * 1000);
				},
				(error) => {
					console.log(error);
					this.progress = false;
				},
				{ repositoryId: repositoryId }
			);
			this.deleteRepositoryDialog = false;
		},
		showProgress(info) {
			this.progressInfo = info;
			this.progress = true;
		},
		updateRepositoryList(repositoryId) {
			this.$puiRequests.getRequest(
				'/helmrepository/list',
				null,
				(response) => {
					this.repositories = response.data;
					if (repositoryId) {
						let repository = response.data.find((i) => i.id === repositoryId);
						if (!repository) {
							clearInterval(this.interval);
							this.progress = false;
						}
					} else {
						this.progress = false;
					}
				},
				(error) => {
					console.log(error);
					this.progress = false;
					// pui9 notification
					this.$puiNotify.error(this.$t('helmrepository.notifications.error.repositories'), this.$t('error'));
					this.showDialog = true;
				}
			);
		}
	}
};
</script>

<style scoped>
.v-data-table >>> .v-data-table-header {
	background-color: var(--primarycolor) !important;
}

.v-data-table >>> .v-data-table-header th > span {
	color: white !important;
}

.v-data-table >>> a {
	text-decoration: none !important;
	color: var(--primarycolor) !important;
}

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
