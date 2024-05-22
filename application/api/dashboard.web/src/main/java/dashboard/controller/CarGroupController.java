package dashboard.controller;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.JsonObject;
import dashboard.model.CarGroup;

import dashboard.model.CarGroupCarCount;
import dashboard.model.NewCarGroup;
import dashboard.service.interfaces.ICarGroupService;
import es.prodevelop.pui9.annotations.PuiFunctionality;

@RestController
@RequestMapping("/car/group")
public class CarGroupController {
	
	@Autowired
	private ICarGroupService carGroupService;

	@GetMapping(value = "/{groupId}")
	@PuiFunctionality(id = "getbyid", value = "READ_K8S_CLUSTER")
	public CarGroup getCarGroupById(@PathVariable String groupId) {
		return carGroupService.getGroupById(groupId);
	}
	
	@GetMapping
	@PuiFunctionality(id = "getGroups", value = "READ_K8S_CLUSTER")
	public List<CarGroupCarCount> getCarGroups() {
		return carGroupService.getGroups();
	}
	
	@PostMapping
	@PuiFunctionality(id = "insert", value = "WRITE_K8S_CLUSTER")
	public JsonObject insert(@RequestBody NewCarGroup carGroup) {
		return carGroupService.createGroup(carGroup);
	}
	
	@DeleteMapping(value = "/{groupId}")
	@PuiFunctionality(id = "deletebyid", value = "WRITE_K8S_CLUSTER")
	public void delete(@PathVariable String groupId) {
		carGroupService.deleteGroup(groupId);
	}

}
