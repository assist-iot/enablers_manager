<template>
	<pui-datatable :modelName="modelName"></pui-datatable>
</template>

<script>
// import actions from './HelmRepositoryActions';

// console.log(actions);

export default {
	name: 'helmrepository-grid',
	data() {
		return {
			// actions: actions.actions,
			modelName: 'helmrepository'
		};
	}
};
</script>
