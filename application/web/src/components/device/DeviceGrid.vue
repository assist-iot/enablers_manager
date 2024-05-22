<template>
	<pui-datatable :modelName="modelName" :actions="actions"></pui-datatable>
</template>

<script>
import actions from './DeviceActions';

console.log(actions);

export default {
	name: 'device-grid',
	data() {
		return {
			actions: actions.actions,
			modelName: 'device'
		};
	}
};
</script>
