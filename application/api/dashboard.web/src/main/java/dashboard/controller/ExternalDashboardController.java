package dashboard.controller;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import es.prodevelop.pui9.annotations.PuiNoSessionRequired;

@Controller
@RequestMapping("/externaldashboard")
@PuiNoSessionRequired
public class ExternalDashboardController {

	@GetMapping(value = "/iframe")
	public ResponseEntity<String> iframe(@RequestParam String externalDashboard) {
		HttpHeaders headers = new HttpHeaders();
		@SuppressWarnings({ "rawtypes", "unchecked" })
		HttpEntity request = new HttpEntity(headers);
		RestTemplate restTemplate = new RestTemplate();
		return restTemplate.exchange(externalDashboard, HttpMethod.GET, request, String.class);
	}
}
