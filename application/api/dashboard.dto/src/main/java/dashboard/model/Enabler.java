package dashboard.model;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Enabler {
	@JsonProperty("uid")
	private String uid;
	private String name;
	private String helmChart;
	private String cluster;
	@JsonProperty("status")
	private String status;
	@JsonProperty("description")
	private String description;
	private String version;

	public Enabler() {

	}

	public String getId() {
		return uid;
	}

	public void setId(String uid) {
		this.uid = uid;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getHelmChart() {
		return helmChart;
	}

	public void setHelmChart(String helmChart) {
		this.helmChart = helmChart;
	}
	public String getCluster() {
		return cluster;
	}

	public void setCluster(String cluster) {
		this.cluster = cluster;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

}
