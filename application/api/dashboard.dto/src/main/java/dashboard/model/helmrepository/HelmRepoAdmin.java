package dashboard.model.helmrepository;

public class HelmRepoAdmin {

	private Double created;
	private Double modified;
	private String operationalState;

	public HelmRepoAdmin(Double created, Double modified, String operationalState) {
		super();
		this.created = created;
		this.modified = modified;
		this.operationalState = operationalState;
	}

	public HelmRepoAdmin() {
	}

	public Double getCreated() {
		return created;
	}

	public void setCreated(Double created) {
		this.created = created;
	}

	public Double getModified() {
		return modified;
	}

	public void setModified(Double modified) {
		this.modified = modified;
	}

	public String getOperationalState() {
		return operationalState;
	}

	public void setOperationalState(String operationalState) {
		this.operationalState = operationalState;
	}

}
