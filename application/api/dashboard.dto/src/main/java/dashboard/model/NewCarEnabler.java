package dashboard.model;

public class NewCarEnabler {
	
	private String enablerName;
	private String helmChart;
	private Object values;
	private String version;

	public NewCarEnabler() {
		
	}

	public String getEnablerName() {
		return enablerName;
	}

	public void setEnablerName(String enablerName) {
		this.enablerName = enablerName;
	}

	public String getHelmChart() {
		return helmChart;
	}

	public void setHelmChart(String helmChart) {
		this.helmChart = helmChart;
	}

	public Object getValues() {
		return values;
	}

	public void setValues(Object values) {
		this.values = values;
	}
	
	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

}
