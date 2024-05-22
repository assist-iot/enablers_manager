package dashboard.model;

import com.fasterxml.jackson.annotation.JsonProperty;

public class NewEnabler {

	private String name;
	private String helmChart;
	private Object values;
	private Boolean auto;
	@JsonProperty("placement_policy")
	private String placement_policy;
	private String cluster;
	private String timeout;
	private String version;

	public NewEnabler() {
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	public String getTimeout() {
		return timeout;
	}

	public void setTimeout(String timeout) {
		this.timeout = timeout;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}
	
	public String getHelmChart() {
		return helmChart;
	}

	public void setHelmChart(String helmChart) {
		this.helmChart = helmChart;
	}

	public Boolean getAuto() {
		return auto;
	}

	public void setAuto(Boolean auto) {
		this.auto = auto;
	}

	public String getPlacementPolicy() {
		return placement_policy;
	}

	public void setPlacementPolicy(String placement_policy) {
		this.placement_policy = placement_policy;
	}

	public String getCluster() {
		return cluster;
	}

	public void setCluster(String cluster) {
		this.cluster = cluster;
	}

	public Object getValues() {
		return values;
	}

	public void getValues(Object values) {
		this.values = values;
	}

}
