package dashboard.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import dashboard.model.OsmToken;
import dashboard.service.interfaces.ISmartTokenService;

@Service
public class SmartTokenService implements ISmartTokenService {

	private String url;
	private static final String PATH = "/api/login/tokens";
	private static String token = "";

	public String getUrl() {
		return url;
	}

	@Autowired
	@Qualifier("orchestratorApiUrl")
	public void setURL(String url) {
		this.url = url.concat(PATH);
	}

	public String getToken() {
		return token;
	}

	@Override
	public String obtainTokenFromSmart() {
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);

		Map<String, Object> body = new HashMap<>();
		body.put("username", "admin");
		body.put("password", "admin");

		HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);

		RestTemplate restTemplate = new RestTemplate();
		ResponseEntity<OsmToken> response = restTemplate.postForEntity(url, entity, OsmToken.class);

		token = response.getBody().getToken();

		return token;
	}
}
