package dashboard.model.k8scluster;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.google.gson.annotations.SerializedName;

public class NewK8sCluster {

	private String name;
	private String description;
	private Credentials credentials;

	@JsonProperty("cloud")
	private String cloud;
	private String cni;

	
	public NewK8sCluster(String name, String description, Credentials credentials, String cloud, String cni) {
		super();
		this.name = name;
		this.description = description;
		this.credentials = credentials;
		this.cloud = cloud;
		this.cni = cni;
	}

	public NewK8sCluster() {

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
	
	public Credentials getCredentials() {
		return credentials;
	}

	public void setCredentials(Credentials credentials) {
		this.credentials = credentials;
	}

	public void setDescription(String description) {
		this.description = description;
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
