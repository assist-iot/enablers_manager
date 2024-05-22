package dashboard.service;

import java.util.List;
import java.util.Arrays;

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

import dashboard.model.CarGroup;

import dashboard.model.CarGroupCarCount;
import dashboard.model.NewCarGroup;
import dashboard.service.interfaces.ICarGroupService;

@Service
public class CarGroupService implements ICarGroupService{
	
	private String url;
	private static final String PATH = "/car/group";
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
	public CarGroup getGroupById(String groupId) {
		ResponseEntity<CarGroup> response = orchestratorRestTemplate
				.getForEntity(url.concat("/{groupId}"), CarGroup.class, groupId);
		return response.getBody();
	}
	
	@Override
	public List <CarGroupCarCount> getGroups() {
		ResponseEntity<CarGroupCarCount[]> response = orchestratorRestTemplate
				.getForEntity(url, CarGroupCarCount[].class);
		return Arrays.asList(response.getBody());
	}

	@Override
	public JsonObject createGroup(NewCarGroup carGroup) {
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		HttpEntity<NewCarGroup> entity = new HttpEntity<>(carGroup, headers);
		
		String response = orchestratorRestTemplate.postForObject(url, entity, String.class);
		return new Gson().fromJson(response, JsonObject.class);
	}

	@Override
	public void deleteGroup(String groupId) {
		orchestratorRestTemplate.delete(url.concat("/{groupId}"), groupId);
	}


}
