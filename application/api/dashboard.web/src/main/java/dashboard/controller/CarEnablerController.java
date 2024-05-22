package dashboard.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.JsonObject;

import dashboard.model.CarEnabler;
import dashboard.model.CarEnablerInGroup;

import dashboard.model.NewCarEnabler;
import dashboard.service.interfaces.ICarEnablerService;
import es.prodevelop.pui9.annotations.PuiFunctionality;

@RestController
@RequestMapping("/car/enabler")
public class CarEnablerController {

	@Autowired
	private ICarEnablerService carEnablerService;
	
	@GetMapping(value = "/{carId}")
	@PuiFunctionality(id = "getbycarid", value = "READ_K8S_CLUSTER")
	public List<CarEnabler> getCarEnablerById(@PathVariable String carId) {
		return carEnablerService.getEnablerInCar(carId);
	}
	
	@GetMapping(value = "/group/{groupId}")
	@PuiFunctionality(id = "getbycarid", value = "READ_K8S_CLUSTER")
	public List<CarEnablerInGroup> getGroupEnablerById(@PathVariable String groupId) {
		return carEnablerService.getGroupEnablerById(groupId);
	}
	
	@PostMapping(value = "/{groupId}")
	@PuiFunctionality(id = "insertingroup", value = "WRITE_K8S_CLUSTER")
	public JsonObject insertInGroup(@PathVariable String groupId, @RequestBody NewCarEnabler carEnabler) {
		return carEnablerService.createEnablerInGroup(groupId, carEnabler);
	}
	
	@PostMapping(value = "/{groupId}/{carId}")
	@PuiFunctionality(id = "insertincar", value = "WRITE_K8S_CLUSTER")
	public JsonObject insertInCar(@PathVariable String groupId, @PathVariable String carId, @RequestBody NewCarEnabler carEnabler) {
		return carEnablerService.createEnablerInCar(groupId, carId, carEnabler);
	}
	
	@DeleteMapping(value = "/group/{groupId}/{enablerName}")
	@PuiFunctionality(id = "deleteingroup", value = "WRITE_K8S_CLUSTER")
	public void deleteInGroup(@PathVariable String groupId, @PathVariable String enablerName) {
		carEnablerService.deleteEnablerInGroup(groupId, enablerName);
	}
	
	@DeleteMapping(value = "/car/{groupId}/{carId}/{enablerName}")
	@PuiFunctionality(id = "deleteincar", value = "WRITE_K8S_CLUSTER")
	public void deleteInCar(@PathVariable String groupId, @PathVariable String carId, @PathVariable String enablerName  ) {
		carEnablerService.deleteEnablerInCar(groupId, carId, enablerName);
	}

}
