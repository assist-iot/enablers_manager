package dashboard.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.JsonObject;

import dashboard.model.Enabler;
import dashboard.model.EnablerCluster;
import dashboard.model.NewEnabler;
import dashboard.service.interfaces.IEnablerService;
import es.prodevelop.pui9.annotations.PuiFunctionality;
import es.prodevelop.pui9.utils.PuiConstants;

@RestController
@RequestMapping("/enabler")
public class EnablerController {

	@Autowired
	IEnablerService enablerService;

	@GetMapping(value = "/list")
	@PuiFunctionality(id = "listget", value = "READ_ENABLER")
	public List<Enabler> list() {
		return enablerService.getEnablerList();
	}

	@GetMapping(value = "/cluster")
	@PuiFunctionality(id = "listInCluster", value = "READ_ENABLER")
	public List<EnablerCluster> list(@RequestParam String clusterId) {
		return enablerService.getClusterEnablerList(clusterId);
	}

	@PuiFunctionality(id = "insert", value = "WRITE_ENABLER")
	@PostMapping(value = "/insert")
	public JsonObject insert(@RequestBody NewEnabler enabler) {
		return enablerService.addEnabler(enabler);
	}

	@PuiFunctionality(id = "insert", value = "WRITE_ENABLER")
	@PostMapping(value = "/upgrade")
	public JsonObject upgrade(@RequestParam String enablerId, @RequestBody NewEnabler enabler) {
		return enablerService.upgradeEnabler(enablerId, enabler);
	}

	@PuiFunctionality(id = "delete", value = "WRITE_ENABLER")
	@DeleteMapping(value = "/delete")
	public void delete(@RequestParam String enablerId, @RequestHeader (value = "Force") String force,  @RequestHeader (value = "Timeout") String timeout) {
		enablerService.deleteEnabler(enablerId,force, timeout);
	}

	@PuiFunctionality(id = "deletePv", value = "WRITE_ENABLER")
	@DeleteMapping(value = "/volumes")
	public void deletePv(@RequestParam String enablerId) {
		enablerService.deleteEnablerPv(enablerId);
	}
}
