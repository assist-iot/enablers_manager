package dashboard.controller;

import java.util.List;
import com.google.gson.JsonArray;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import dashboard.model.helmrepository.Chart;
import dashboard.model.helmrepository.HelmRepository;
import dashboard.model.helmrepository.NewPublicHelmRepository;
import dashboard.model.helmrepository.NewPrivateHelmRepository;
import dashboard.model.k8scluster.NewK8sCluster;
import dashboard.service.interfaces.IHelmRepositoryService;
import es.prodevelop.pui9.annotations.PuiFunctionality;
import es.prodevelop.pui9.search.SearchResponse;

@RestController
@RequestMapping("/helmrepository")
public class HelmRepositoryController {

	@Autowired
	private IHelmRepositoryService repositoryService;

	@PostMapping(value = "/echo")
	public NewK8sCluster echo(@RequestBody NewK8sCluster cluster) {
		return cluster;
	}

	@GetMapping(value = "/list")
	@PuiFunctionality(id = "listget", value = "READ_HELM_REPOSITORY")
	public List<HelmRepository> list() {
		return repositoryService.getRepositoryList();
	}

	@PuiFunctionality(id = "list", value = "READ_HELM_REPOSITORY")
	@PostMapping(value = "/list")
	public SearchResponse<HelmRepository> listPost() {
		return repositoryService.getRepositorySearchResults();
	}

	@PuiFunctionality(id = "insert", value = "WRITE_HELM_REPOSITORY")
	@PostMapping(value = "/insert/public")
	public void insert(@RequestBody NewPublicHelmRepository repository) {
		repositoryService.addPublicRepository(repository);
	}
	
	@PuiFunctionality(id = "insert", value = "WRITE_HELM_REPOSITORY")
	@PostMapping(value = "/insert/private")
	public void insert(@RequestBody NewPrivateHelmRepository repository) {
		repositoryService.addPrivateRepository(repository);
	}
	
	@PuiFunctionality(id = "update", value = "WRITE_HELM_REPOSITORY")
	@PostMapping(value = "/update")
	public void insert() {
		repositoryService.updateRepositories();
	}

	@PuiFunctionality(id = "delete", value = "WRITE_HELM_REPOSITORY")
	@DeleteMapping(value = "/delete")
	public void delete(@RequestParam String repositoryId) {
		repositoryService.deleteRepository(repositoryId);
	}

	@GetMapping(value = "/charts")
	@PuiFunctionality(id = "chartlist", value = "READ_HELM_REPOSITORY")
	public JsonArray listCharts(@RequestParam String repoId) {
		return repositoryService.getCharts(repoId);
	}

}
