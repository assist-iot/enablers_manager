package dashboard.service;

import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import dashboard.model.Enabler;
import dashboard.model.EnablerCluster;
import dashboard.model.NewEnabler;
import dashboard.service.interfaces.IEnablerService;

@Service
public class EnablerService implements IEnablerService {

	private String url;
	private static final String PATH = "/enabler";
	private RestTemplate orchestratorRestTemplate;

	@Autowired
	public void setOrchestratorRestTemplate(RestTemplate orchestratorRestTemplate) {
		this.orchestratorRestTemplate = orchestratorRestTemplate;
	}

	public String getUrl() {
		return url;
	}

	@Autowired
	@Qualifier("orchestratorApiUrl")
	public void setURL(String url) {
		this.url = url.concat(PATH);
	}

	@Override
	public List<Enabler> getEnablerList() {
		ResponseEntity<Enabler[]> response = orchestratorRestTemplate.getForEntity(url,
				Enabler[].class);
		return Arrays.asList(response.getBody());
	}

	@Override
	public JsonObject addEnabler(NewEnabler enabler) {
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		HttpEntity<NewEnabler> entity = new HttpEntity<>(enabler, headers);

		String response = orchestratorRestTemplate.postForObject(url, entity, String.class);
		return new Gson().fromJson(response, JsonObject.class);
	}

	@Override
	public JsonObject upgradeEnabler(String enablerId, NewEnabler enabler) {
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		HttpEntity<NewEnabler> entity = new HttpEntity<>(enabler, headers);

		String response = orchestratorRestTemplate.postForObject(url + "/upgrade/" + enablerId, entity, String.class);
		return new Gson().fromJson(response, JsonObject.class);
	}

	@Override
	public void deleteEnabler(String enablerId, String force, String timeout) {
		MultiValueMap<String, String> headers = new LinkedMultiValueMap<>();
		headers.add("Force", force);
		headers.add("Timeout", timeout);
		HttpEntity<?> request = new HttpEntity<Object>(headers);
		orchestratorRestTemplate.exchange(url + '/' + enablerId, HttpMethod.DELETE, request, String.class);
	}

	@Override
	public void deleteEnablerPv(String enablerId) {
		orchestratorRestTemplate.delete(url.concat("/volumes/{enablerId}"), enablerId);
	}

	@Override
	public List<EnablerCluster> getClusterEnablerList(String clusterId) {
		ResponseEntity<EnablerCluster[]> response = orchestratorRestTemplate
				.getForEntity(url.concat("/cluster").concat("/{clusterId}"), EnablerCluster[].class, clusterId);
		return Arrays.asList(response.getBody());
	}

}
