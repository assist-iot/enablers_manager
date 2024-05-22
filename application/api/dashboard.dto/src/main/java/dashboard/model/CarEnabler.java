package dashboard.model;

public class CarEnabler {
	
	private String id;
	private String type;
	private Object refGroup;
	private Object status;
	private Object info;
	private Object timestamp;

	public CarEnabler() {
		
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

	public Object getRefGroup() {
		return refGroup;
	}

	public void setRefGroup(Object refGroup) {
		this.refGroup = refGroup;
	}

	public Object getStatus() {
		return status;
	}

	public void setStatus(Object status) {
		this.status = status;
	}

	public Object getInfo() {
		return info;
	}

	public void setInfo(Object info) {
		this.info = info;
	}

	public Object getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(Object timestamp) {
		this.timestamp = timestamp;
	}

}
