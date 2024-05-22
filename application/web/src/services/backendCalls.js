import axios from "axios"

function compareByEntry(a, b) {
	return a.entry.localeCompare(b.entry);
}

function compareBySubfleet(a, b) {
	return a.subfleet.localeCompare(b.subfleet);
}

export default {
	async getIndexQuery(index, query) {
		try{
			let res = await axios.get("/pilot/data/indexQuery", {
			params: {
				index,
				query
			}});
			return res.data;
		}catch(e){
			return e
		}
	},

	async getLTSEData(index, id) {
		let res = await axios.get("/pilot/data", {
			params: {
				index,
				id
			}});
		return res.data;
	},

	async getCarsList(index, query) {
		try{
			let res = await axios.get("/pilot/data/carsList", {
				params: {
					index,
					query
				}});
			return res.data;
		}catch (e){
			console.log(e.response.data.message)
		}

	},

	async getList(index, subfleet, resource) {
		let res = await axios.get("/pilot/data/list", {
			params: {
				index,
				subfleet,
				resource
			}});
		let formattedResponse = res.data.map(item => {
			return resource == "subfleet" ? {"subfleet":item} : { entry: item }
		})
		let sortedResponse = resource == "subfleet" ? formattedResponse.sort(compareBySubfleet) : resource == "country" ? formattedResponse.sort(compareByEntry) : formattedResponse
		return sortedResponse;
	},

	async uploadCalibration(fileInput,model,version) {
		let formData = new FormData();
		formData.append('calibrationFile', fileInput);
		formData.append('model', model);
		formData.append('version', version);

		let res = await axios.post("/pilot/data/calibration", formData);
		return res.data;
	},

	async registerVersion(model,version) {
		let response = await axios.post("/pilot/data/version", {
			params: {
				model,
				version
			}});
		return response;
	},

	async getVersions(model) {
		let res = await axios.get("/pilot/data/versions", {
			params: {
				model
			}});
		let sortedVersions = res.data.versions.items.sort((a,b) =>
			b.version.localeCompare(a.version)).map((obj) => ({ version: obj.version }));
		return sortedVersions;
	},
	async getModels() {
		let response = await axios.get("/pilot/data/model/?namespace=firmware");
		return response
	},

	async postModel(model) {
		let response = await axios.post(`/pilot/data/model/?model=${model}&namespace=firmware`)
		return response
	},

	async postNamespace() {
		let response = await axios.post("/pilot/data/namespace/firmware")
		return response
	},

	async calibrateSubfleet(groupId,model,version) {
		let response = await axios.post(`/pilot/data/calibration/subfleet/${groupId}?model=${model}&version=${version}`)
		return response
	}
}
