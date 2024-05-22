package dashboard.model;

public class CarCluster {

	private String id;
	private String type;
	private Object description;
	private Object refGroup;
	private Object timestamp;
	
	public CarCluster() {
		
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public Object getDescription() {
		return description;
	}

	public void setDescription(Object description) {
		this.description = description;
	}

	public Object getRefGroup() {
		return refGroup;
	}

	public void setRefGroup(Object refGroup) {
		this.refGroup = refGroup;
	}

	public Object getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(Object timestamp) {
		this.timestamp = timestamp;
	}

}
