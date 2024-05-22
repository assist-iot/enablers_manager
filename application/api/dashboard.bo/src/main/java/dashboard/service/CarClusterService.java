package dashboard.service;

import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import dashboard.model.CarCluster;
import dashboard.model.NewCarCluster;
import dashboard.service.interfaces.ICarClusterService;
@Service
public class CarClusterService implements ICarClusterService {

	private String url;
	private static final String PATH = "/car/cluster";
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
	public CarCluster getClusterById(String clusterId) {
		ResponseEntity<CarCluster> response = orchestratorRestTemplate
				.getForEntity(url.concat("/{clusterId}"), CarCluster.class, clusterId);
		return response.getBody();
	}

	@Override
	public List <CarCluster> getClusterByGroup(String groupId) {
		ResponseEntity<CarCluster[]> response = orchestratorRestTemplate
				.getForEntity(url.concat("/group/{groupId}"), CarCluster[].class, groupId);
		return Arrays.asList(response.getBody());
	}
	
	@Override
	public ResponseEntity<String> getClusterByGroupCsv(String groupId) {
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.valueOf("text/csv"));
		ResponseEntity<String> response = orchestratorRestTemplate
				.getForEntity(url.concat("/group/csv/{groupId}"), String.class, groupId);
		return ResponseEntity.ok().headers(response.getHeaders()).body(response.getBody());
	}

	@Override
	public CarCluster getClusterByIdGroup(String clusterId, String groupId) {
		ResponseEntity<CarCluster> response = orchestratorRestTemplate
				.getForEntity(url.concat("/{clusterId}/{groupId}"), CarCluster.class, clusterId, groupId);
		return response.getBody();
	}

	@Override
	public JsonObject createCluster(NewCarCluster carCluster) {
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		HttpEntity<NewCarCluster> entity = new HttpEntity<>(carCluster, headers);
		
		String response = orchestratorRestTemplate.postForObject(url, entity, String.class);
		return new Gson().fromJson(response, JsonObject.class);
	}

	@Override
	public void deleteCluster(String clusterId) {
		orchestratorRestTemplate.delete(url.concat("/{clusterId}"), clusterId);
	}

}
