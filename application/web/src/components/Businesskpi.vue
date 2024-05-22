<template>
	<div class="bkpi-dashboard-container">
		<iframe :src="src" width="100%" height="100%" frameborder="0" />
	</div>
</template>

<script>

export default {
	name: 'BusinessKpi',
	data() {
		return {
			bKpiDashboardUrl: undefined,
		};
	},
	props: {
		src: String
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

	}
};
</script>

<style>
.bkpi-dashboard-container {
	height: 99vh;
}
</style>
