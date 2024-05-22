package es.prodevelop.pui9.spring.config;

import java.util.Collections;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.core.env.Environment;
import org.springframework.web.client.RestTemplate;

import dashboard.service.OrchestratorRequestResponseHandlerInterceptor;
import es.prodevelop.pui9.interceptors.CommonInterceptor;
import es.prodevelop.pui9.interceptors.PuiInterceptor;
import es.prodevelop.pui9.spring.configuration.AbstractAppSpringConfiguration;
import es.prodevelop.pui9.spring.configuration.annotations.PuiSpringConfiguration;

@PuiSpringConfiguration
@ComponentScan(basePackages = { "dashboard" })
public class DashboardSpringConfiguration extends AbstractAppSpringConfiguration {

	private static final String ORCHESTRATOR_API_URL = "ORCHESTRATOR_API_URL";

	@Autowired
	private Environment env;

//	@Autowired
//	private SmartRequestResponseHandlerInterceptor smartRequestResponseHandlerInterceptor;

	@Override
	protected String getJndiName() {
		return "java:comp/env/jdbc/dashboard";
	}

	@Override
	protected PuiInterceptor getHandlerInterceptor() {
		return new CommonInterceptor();
	}

//	@Override
//	protected String getAppnameForElasticsearch() {
//		return "Dashboard";
//	}

	@Bean("orchestratorApiUrl")
	public String orchestratorApiUrl() {
		if (env.containsProperty(ORCHESTRATOR_API_URL)) {
			System.out.println(
					"Found env_var " + ORCHESTRATOR_API_URL + " with value: " + env.getProperty(ORCHESTRATOR_API_URL));
			return env.getProperty(ORCHESTRATOR_API_URL);
		} else {
			String defaultValue = "http://158.42.161.177:30782"; // http://158.42.161.177:5002
			System.out
					.println("Not found any env_var related with the Smart Orchestrator URL. Setting the default value "
							.concat(defaultValue));
			return defaultValue;
		}
	}

	@Bean
	public OrchestratorRequestResponseHandlerInterceptor smartRequestResponseHandlerInterceptor() {
		return new OrchestratorRequestResponseHandlerInterceptor();
	}

	@Bean
	public RestTemplate orchestratorRestTemplate() {
		RestTemplate restTemplate = new RestTemplate();
		restTemplate.setInterceptors(Collections.singletonList(smartRequestResponseHandlerInterceptor()));
		return restTemplate;
	}

	@Override
	protected String getAesSecret() {
		// return "QWERDFVBCXYUJJKPOIUFGDERTBVCYUJK";
		return "01234567890123456789012345678901";
	}

}
