package dashboard.service;

import java.text.Normalizer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import com.google.gson.JsonArray;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Lazy;
import org.springframework.http.HttpEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.yaml.YAMLFactory;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;

import dashboard.model.helmrepository.Chart;
import dashboard.model.helmrepository.HelmRepository;
import dashboard.model.helmrepository.NewPublicHelmRepository;
import dashboard.model.helmrepository.NewPrivateHelmRepository;
import dashboard.service.interfaces.IHelmRepositoryService;
import es.prodevelop.pui9.search.SearchResponse;

@Service
public class HelmRepositoryService implements IHelmRepositoryService {

	private String url;
	private static final String PATH = "/repos";
	@Lazy
	@Autowired
	private RestTemplate orchestratorRestTemplate;

	public String getUrl() {
		return url;
	}

	@Autowired
	@Qualifier("orchestratorApiUrl")
	public void setURL(String url) {
		this.url = url.concat(PATH);
	}

	@Override
	public List<HelmRepository> getRepositoryList() {
		ResponseEntity<HelmRepository[]> response = orchestratorRestTemplate.getForEntity(url, HelmRepository[].class);
		return Arrays.asList(response.getBody());
	}

	@Override
	public SearchResponse<HelmRepository> getRepositorySearchResults() {
		ResponseEntity<HelmRepository[]> response = orchestratorRestTemplate.getForEntity(url, HelmRepository[].class);
		List<HelmRepository> data = Arrays.asList(response.getBody());

		SearchResponse<HelmRepository> searchResponse = new SearchResponse<>();
		searchResponse.setData(data);
		searchResponse.setTotalRecords((long) data.size());
		searchResponse.setCurrentPage(1);
		searchResponse.setTotalPages((long) 1);
		searchResponse.setCurrentRecords(data.size());

		return searchResponse;
	}

	@Override
	public NewPublicHelmRepository addPublicRepository(NewPublicHelmRepository repository) {
		HttpEntity<NewPublicHelmRepository> entity = new HttpEntity<>(repository);
		return orchestratorRestTemplate.postForObject(url.concat("/public"), entity, NewPublicHelmRepository.class);
	}

	@Override
	public NewPrivateHelmRepository addPrivateRepository(NewPrivateHelmRepository repository) {
		HttpEntity<NewPrivateHelmRepository> entity = new HttpEntity<>(repository);
		return orchestratorRestTemplate.postForObject(url.concat("/private"), entity, NewPrivateHelmRepository.class);
	}
	
	@Override
	public void updateRepositories() {
		orchestratorRestTemplate.postForObject(url.concat("/update"), null, Void.class);
	}
	
	@Override
	public void deleteRepository(String repositoryId) {
		orchestratorRestTemplate.delete(url.concat("/{repositoryId}"), repositoryId);
	}

	@Override
	public JsonArray getCharts(String repoId) {
		ResponseEntity<String> response = orchestratorRestTemplate
				.getForEntity(url + "/charts/" + repoId, String.class);
		return new Gson().fromJson(response.getBody(), JsonArray.class);
	}

}
