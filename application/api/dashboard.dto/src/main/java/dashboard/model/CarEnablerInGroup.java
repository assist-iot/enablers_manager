package dashboard.model;

import com.fasterxml.jackson.annotation.JsonProperty;

public class CarEnablerInGroup {

	private String id;
	@JsonProperty("Running")
	private String Running;
	@JsonProperty("Error")
	private String Error;

	public CarEnablerInGroup() {
		
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getRunning() {
		return Running;
	}

	public void setRunning(String Running) {
		this.Running = Running;
	}

	public Object getError() {
		return Error;
	}

	public void setError(String Error) {
		this.Error = Error;
	}


}
