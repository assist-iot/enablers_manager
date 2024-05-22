package dashboard.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.ResponseEntity;

import com.google.gson.JsonObject;
import java.util.List;

import dashboard.model.CarCluster;
import dashboard.model.NewCarCluster;
import dashboard.service.interfaces.ICarClusterService;
import es.prodevelop.pui9.annotations.PuiFunctionality;

@RestController
@RequestMapping("/car/cluster")
public class CarClusterController {
	
	@Autowired
	private ICarClusterService carClusterService;

	@GetMapping(value = "/{clusterId}")
	@PuiFunctionality(id = "getbyid", value = "READ_K8S_CLUSTER")
	public CarCluster getCarGroupById(@PathVariable String clusterId) {
		return carClusterService.getClusterById(clusterId);
	}
	
	@GetMapping(value = "/group/{groupId}")
	@PuiFunctionality(id = "getbygroup", value = "READ_K8S_CLUSTER")
	public List <CarCluster> getCarGroupByGroup(@PathVariable String groupId) {
		return carClusterService.getClusterByGroup(groupId);
	}
	
	@GetMapping(value = "/group/csv/{groupId}")
	@PuiFunctionality(id = "getbygroup", value = "READ_K8S_CLUSTER")
	public ResponseEntity <String> getCarGroupByGroupCsv(@PathVariable String groupId) {
		return carClusterService.getClusterByGroupCsv(groupId);
	}
	
	@GetMapping(value = "/{clusterId}/{groupId}")
	@PuiFunctionality(id = "getbyidgroup", value = "READ_K8S_CLUSTER")
	public CarCluster getClusterByIdGroup(@PathVariable String clusterId, @PathVariable String groupId) {
		return carClusterService.getClusterByIdGroup(clusterId, groupId);
	}
	
	@PostMapping
	@PuiFunctionality(id = "insert", value = "WRITE_K8S_CLUSTER")
	public JsonObject insert(@RequestBody NewCarCluster carGroup) {
		return carClusterService.createCluster(carGroup);
	}
	
	@DeleteMapping(value = "/{clusterId}")
	@PuiFunctionality(id = "deletebyid", value = "WRITE_K8S_CLUSTER")
	public void delete(@PathVariable String clusterId) {
		carClusterService.deleteCluster(clusterId);
	}

}
