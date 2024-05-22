package dashboard.model.helmrepository;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import dashboard.model.k8scluster.Credentials;

public class Chart {
	
	@JsonProperty("Name")
	private String Name;
	private List<String> versions;

	public Chart(String Name, List<String> versions) {
		super();
		this.Name = Name;
		this.versions = versions;
	}

	public Chart() {
	}

	public String getName() {
		return Name;
	}

	public void setName(String Name) {
		this.Name = Name;
	}

	public List<String> getVersions() {
		return versions;
	}

	public void setVersions(List<String> versions) {
		this.versions = versions;
	}

}
