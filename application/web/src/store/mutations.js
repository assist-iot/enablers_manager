export default {
    changeView: (state, subfleet) => {
    // mutate state
        state.pilot3a.subfleet = subfleet
    },
	calVersions: (state, calVersions) => {
		state.pilot3a.calVersions = calVersions
	},
	addFilter: (state, newFilter) => {
		state.pilot3a.filters.push(newFilter)
	},
	activeFilter: (state, title) => {
		state.pilot3a.activeFilter=title
	}
};

