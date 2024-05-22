package dashboard.service;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.client.ClientHttpRequestExecution;
import org.springframework.http.client.ClientHttpRequestInterceptor;
import org.springframework.http.client.ClientHttpResponse;

import dashboard.service.interfaces.ISmartTokenService;

public class OrchestratorRequestResponseHandlerInterceptor implements ClientHttpRequestInterceptor {

//	private String url;

	@Autowired
	private ISmartTokenService smartTokenService;

	private static final String AUTHORIZATION = "Token";
//	private static final String TOKEN_PATH = "/api/login/tokens";

//	@Autowired
//	@Qualifier("orchestratorApiUrl")
//	public void setURL(String url) {
//		this.url = url.concat(TOKEN_PATH);
//	}

//	public String getToken() {
//		HttpHeaders headers = new HttpHeaders();
//		headers.setContentType(MediaType.APPLICATION_JSON);
//
//		Map<String, Object> body = new HashMap<>();
//		body.put("username", "admin");
//		body.put("password", "admin");
//
//		HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);
//
//		RestTemplate restTemplate = new RestTemplate();
//		ResponseEntity<OsmToken> response = restTemplate.postForEntity(url, entity, OsmToken.class);
//
//		return response.getBody().getToken();
//
//	}

	@Override
	public ClientHttpResponse intercept(HttpRequest request, byte[] body, ClientHttpRequestExecution execution)
			throws IOException {
		request.getHeaders().remove(AUTHORIZATION);
		request.getHeaders().add(AUTHORIZATION, smartTokenService.getToken());
		ClientHttpResponse response = execution.execute(request, body);
		if (HttpStatus.UNAUTHORIZED == response.getStatusCode()) {
			String accessToken = smartTokenService.obtainTokenFromSmart();
//			if (!StringUtils.isEmpty(accessToken)) {
			request.getHeaders().remove(AUTHORIZATION);
			request.getHeaders().add(AUTHORIZATION, accessToken);
			response = execution.execute(request, body);
		}
		return response;
	}

}
