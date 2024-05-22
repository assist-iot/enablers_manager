package dashboard.model.helmrepository;

public class NewPublicHelmRepository {

	private String name;
	private String description;
	private String url;

	public NewPublicHelmRepository() {
	}

	public NewPublicHelmRepository(String name, String description, String url) {
		super();
		this.name = name;
		this.description = description;
		this.url = url;
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

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

}
