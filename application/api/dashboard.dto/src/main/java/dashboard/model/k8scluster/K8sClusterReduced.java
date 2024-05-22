package dashboard.model.k8scluster;

import com.fasterxml.jackson.annotation.JsonProperty;

public class K8sClusterReduced {

	@JsonProperty("uid")
	private String uid;
	private String name;

	public K8sClusterReduced() {

	}

	public K8sClusterReduced(String uid, String name) {
		super();
		this.uid = uid;
		this.name = name;
	}

	public String getId() {
		return uid;
	}

	public void setId(String id) {
		this.uid = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}


}
