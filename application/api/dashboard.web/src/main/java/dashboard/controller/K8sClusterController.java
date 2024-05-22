package dashboard.controller;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import dashboard.model.k8scluster.K8sCluster;
import dashboard.model.k8scluster.K8sClusterReduced;
import dashboard.model.k8scluster.NewK8sCluster;
import dashboard.service.interfaces.IK8sClusterService;
import es.prodevelop.pui9.annotations.PuiFunctionality;

@RestController
@RequestMapping("/k8scluster")
public class K8sClusterController {

	@Autowired
	private IK8sClusterService clusterService;

	@GetMapping(value = "/list")
	@PuiFunctionality(id = "listget", value = "READ_K8S_CLUSTER")
	public List<K8sCluster> list() {
		return clusterService.getClusterList();
	}

	@GetMapping(value = "/list/reduced")
	@PuiFunctionality(id = "listgetreduced", value = "READ_K8S_CLUSTER")
	public List<K8sClusterReduced> reducedList() {
		return clusterService.getReducedClusterList();
	}

	@PuiFunctionality(id = "insert", value = "WRITE_K8S_CLUSTER")
	@PostMapping(value = "/insert")
	public void insert(@RequestBody NewK8sCluster cluster) {
		clusterService.addCluster(cluster);
	}

	@PuiFunctionality(id = "insert-file", value = "WRITE_K8S_CLUSTER")
	@PostMapping(value = "/insert/file")
	public JsonObject insertUsingfile(@RequestParam("file") MultipartFile kubeconfig, @RequestParam("name") String name,
			@RequestParam("description") String description, @RequestParam("cloud") String cloud, @RequestParam("cni") String cni)
			throws IOException {
		NewK8sCluster cluster = clusterService.addCluster(kubeconfig, name, description, cloud, cni);
		return clusterService.addCluster(cluster);
	}

	@PuiFunctionality(id = "delete", value = "WRITE_K8S_CLUSTER")
	@DeleteMapping(value = "/delete")
	public void delete(@RequestParam String clusterId, @RequestHeader (value = "Force") String force) {
		clusterService.deleteCluster(clusterId, force);
	}

	@GetMapping(value = "/nodes/{clusterId}")
	@PuiFunctionality(id = "nodelist", value = "READ_K8S_CLUSTER")
	public JsonArray nodeList(@PathVariable String clusterId) {
		return clusterService.getClusterNodes(clusterId);
	}
}
