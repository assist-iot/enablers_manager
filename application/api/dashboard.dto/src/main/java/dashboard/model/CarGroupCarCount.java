package dashboard.model;

public class CarGroupCarCount {

	private String id;
	private String type;
	private Object description;
	private Object enablers;
	private Object timestamp;
	private String countCars;

	public CarGroupCarCount() {
		
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

	public Object getEnablers() {
		return enablers;
	}

	public void setEnablers(Object enablers) {
		this.enablers = enablers;
	}

	public Object getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(Object timestamp) {
		this.timestamp = timestamp;
	}
	
	public String getCountCars() {
		return countCars;
	}
	
	public void setCountCars(String countCars) {
		this.countCars = countCars;
	}
}
