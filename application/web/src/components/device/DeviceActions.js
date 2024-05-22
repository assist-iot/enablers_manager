// import pui9api from 'pui9';

const disableDeviceAction = {
	id: 'disableDeviceAction',
	selectionType: 'single',
	label: 'puiaction.disabledevice',
	functionality: 'WRITE_DEVICE',
	checkAvailability: function (row) {
		console.log(row);
		return true;
	},
	runAction: function (action, model, registries) {
		console.log(action);
		console.log(model);
		console.log(registries);
		// TODO
	}
};

export default {
	actions: [disableDeviceAction]
};
