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

import dashboard.model.CarEnabler;
import dashboard.model.CarEnablerInGroup;
import dashboard.model.NewCarEnabler;
import dashboard.service.interfaces.ICarEnablerService;

@Service
public class CarEnablerService implements ICarEnablerService {
	
	private String url;
	private static final String PATH = "/car/enabler";
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
	public List<CarEnabler> getEnablerInCar(String carId) {
		ResponseEntity<CarEnabler[]> response = orchestratorRestTemplate
				.getForEntity(url.concat("/{carId}"), CarEnabler[].class, carId);
		return Arrays.asList(response.getBody());
	}
	
	@Override
	public List<CarEnablerInGroup> getGroupEnablerById(String groupId) {
		ResponseEntity<CarEnablerInGroup[]> response = orchestratorRestTemplate
				.getForEntity(url + "/group/" + groupId, CarEnablerInGroup[].class, groupId);
		return Arrays.asList(response.getBody());
	}
	
	@Override
	public JsonObject createEnablerInGroup(String groupId, NewCarEnabler carEnabler) {
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		HttpEntity<NewCarEnabler> entity = new HttpEntity<>(carEnabler, headers);
		
		String response = orchestratorRestTemplate.postForObject(url + "/" + groupId, entity, String.class);
		return new Gson().fromJson(response, JsonObject.class);
	}

	@Override
	public JsonObject createEnablerInCar(String groupId, String carId, NewCarEnabler carEnabler) {
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		HttpEntity<NewCarEnabler> entity = new HttpEntity<>(carEnabler, headers);
		
		String response = orchestratorRestTemplate.postForObject(url + "/" + groupId + "/" + carId, entity, String.class);
		return new Gson().fromJson(response, JsonObject.class);
	}

	// TODO
	@Override
	public void deleteEnablerInGroup(String groupId, String enablerName) {
		orchestratorRestTemplate.delete(url + "/group/" + groupId + "/" + enablerName, groupId);		
	}

	// TODO
	@Override
	public void deleteEnablerInCar(String groupId, String carId, String enablerName) {
		orchestratorRestTemplate.delete(url + "/car/" + groupId + "/" + carId + "/" + enablerName, groupId);		

	}

}
