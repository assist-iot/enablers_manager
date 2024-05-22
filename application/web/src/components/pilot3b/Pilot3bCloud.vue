<template>
	<div class="bkpi-dashboard-container" v-if="dashboardUrl">
		<iframe :src="dashboardUrl" width="100%" height="100%" frameborder="0" />
	</div>
	<pui-form-loading v-else></pui-form-loading>
</template>

<script>
export default {
	name: 'Pilot3b',
	data() {
		return {
			dashboardUrl: undefined
		};
	},
	props: {
		variable: String
	},
	beforeMount() {
		// hide core header
		setTimeout(() => {
			document.getElementsByClassName('v-main__wrap')[0].firstElementChild.style.display = 'none';
		}, 10);
	},
	beforeDestroy() {
		// show core header
		document.getElementsByClassName('v-main__wrap')[0].firstElementChild.style.display = 'block';
	},
	created() {
		this.$puiRequests.getRequest(
			`/puivariable/getVariable/${this.variable}`,
			null,
			(response) => {
				this.dashboardUrl = response.data;
			},
			(error) => {
				console.log(error);
			}
		);
	}
};
</script>

<style>
.bkpi-dashboard-container {
	height: 99vh;
}
</style>
