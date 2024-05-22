package dashboard.model.k8scluster;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.google.gson.annotations.SerializedName;

public class K8sCluster {

	@JsonProperty("uid")
	private String uid;
	private String name;
	private String description;
	private Credentials credentials;
	@JsonProperty("status")
	private String status;
	@JsonProperty("cloud")
	private String cloud;
	@JsonProperty("cni")
	private String cni;

	public K8sCluster() {
	}

	public K8sCluster(String uid, String name, String description, String status, String cloud,
			String cni) {
		super();
		this.uid = uid;
		this.name = name;
		this.description = description;
		this.status = status;
		this.cloud = cloud;
		this.cni = cni;
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

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Credentials getCredentials() {
		return credentials;
	}

	public void setCredentials(Credentials credentials) {
		this.credentials = credentials;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getCloud() {
		return cloud;
	}

	public void setCloud(String cloud) {
		this.cloud = cloud;
	}

	public String getCni() {
		return cni;
	}

	public void setCni(String cni) {
		this.cni = cni;
	}

}
