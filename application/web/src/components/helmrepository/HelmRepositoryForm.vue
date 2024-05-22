<template>
	<div class="pui-form">
		<v-form class="mb-4 pb-4" ref="form" v-model="valid" lazy-validation @submit.prevent v-if="modelLoaded">
			<v-layout row wrap class="pui-form-layout">
				<div class="pui-form-layout">
					<v-row dense>
						<v-col cols="4">
							<pui-text-field
								:id="`id-device`"
								v-model="model.id"
								label="Device ID"
								:disabled="model.id != null"
								required
								toplabel
								maxlength="10"
							>
							</pui-text-field>
						</v-col>
					</v-row>
					<v-row dense>
						<v-col cols="12">
							<pui-text-field
								:id="`name-device`"
								v-model="model.name"
								label="Device name"
								:disabled="formDisabled"
								required
								toplabel
								maxlength="10"
							>
							</pui-text-field>
						</v-col>
					</v-row>
					<v-row dense>
						<v-col cols="24">
							<pui-text-field
								:id="`description-device`"
								v-model="model.description"
								label="Device description"
								:disabled="formDisabled"
								required
								toplabel
								maxlength="100"
							>
							</pui-text-field>
						</v-col>
					</v-row>
				</div>
				<!-- <v-flex xs12>
				<v-text-field filled label="ID" color="blue" v-model="model.id" outline required></v-text-field>
				<v-text-field filled label="Name" color="blue" v-model="model.name" outline required></v-text-field>
				<v-text-field filled label="Description" color="blue" v-model="model.description" outline required></v-text-field>
			</v-flex> -->

				<pui-form-footer v-if="!isModalDialog">
					<pui-form-footer-btns
						:formDisabled="formDisabled"
						:saveDisabled="saving"
						:saveAndNew="saveAndNew"
						:saveAndUpdate="saveAndUpdate"
						:save="save"
						:back="back"
					></pui-form-footer-btns>
				</pui-form-footer>
			</v-layout>
		</v-form>
		<pui-form-loading v-else></pui-form-loading>
	</div>
</template>

<script>
import PuiFormMethodsMixin from 'pui9-mixins/PuiFormMethodsMixin';

export default {
	mixins: [PuiFormMethodsMixin],
	data() {
		return {
			modelName: 'device'
		};
	}
};
</script>
