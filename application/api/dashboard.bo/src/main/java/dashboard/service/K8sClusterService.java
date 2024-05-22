package dashboard.service;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.FileSystemException;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

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
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.yaml.YAMLFactory;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import dashboard.model.k8scluster.Credentials;
import dashboard.model.k8scluster.K8sCluster;
import dashboard.model.k8scluster.K8sClusterReduced;
import dashboard.model.k8scluster.NewK8sCluster;
import dashboard.service.interfaces.IK8sClusterService;

@Service
public class K8sClusterService implements IK8sClusterService {

	private String url;
	private static final String PATH = "/clusters";
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
	public List<K8sCluster> getClusterList() {
		System.out.println(url);
		ResponseEntity<K8sCluster[]> response = orchestratorRestTemplate.getForEntity(url, K8sCluster[].class);
		return Arrays.asList(response.getBody());
	}

	@Override
	public List<K8sClusterReduced> getReducedClusterList() {
		List<K8sCluster> clusters = getClusterList();

		return clusters.stream().filter(i -> i.getStatus().equals("Enabled"))
				.map(i -> new K8sClusterReduced(i.getId(), i.getName()))
				.collect(Collectors.toList());
	}

	@Override
	public JsonObject addCluster(NewK8sCluster cluster) {
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		HttpEntity<NewK8sCluster> entity = new HttpEntity<>(cluster, headers);

		String response = orchestratorRestTemplate.postForObject(url, entity, String.class);
		return new Gson().fromJson(response, JsonObject.class);
	}

	@Override
	public NewK8sCluster addCluster(MultipartFile kubeconfig, String name, String description, String cloud, String cni)
			throws IOException {
		String content = new String(kubeconfig.getBytes(), StandardCharsets.UTF_8);
		Credentials clusterCredentials;

		if (kubeconfig.getContentType().equals("application/json")) {
			Gson gson = new Gson();
			clusterCredentials = gson.fromJson(content, Credentials.class);
		} else if (kubeconfig.getOriginalFilename().endsWith(".yaml")
				|| kubeconfig.getOriginalFilename().endsWith(".yml")) {
			ObjectMapper yamlMapper = new ObjectMapper(new YAMLFactory());
			clusterCredentials = yamlMapper.readValue(content, Credentials.class);
		} else {
			throw new FileSystemException("Not a valid kubeconfig file");
		}

		return new NewK8sCluster(name, description, clusterCredentials, cloud, cni);
	}

	@Override
	public void deleteCluster(String clusterId, String force) {
		MultiValueMap<String, String> headers = new LinkedMultiValueMap<>();
		headers.add("Force", force);
		HttpEntity<?> request = new HttpEntity<Object>(headers);
		orchestratorRestTemplate.exchange(url + '/' + clusterId, HttpMethod.DELETE, request, String.class);
	}

	@Override
	public JsonArray getClusterNodes(String clusterId) {
		ResponseEntity<String> response = orchestratorRestTemplate
				.getForEntity(url.concat("/node").concat("/{clusterId}"), String.class, clusterId);
		return new Gson().fromJson(response.getBody(), JsonArray.class);
	}

}
