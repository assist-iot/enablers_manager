package dashboard.model.helmrepository;

import dashboard.model.helmrepository.Auth;

public class NewPrivateHelmRepository {

	private String name;
	private String description;
	private String url;
	private Auth auth;

	public NewPrivateHelmRepository() {
	}

	public NewPrivateHelmRepository(String name, String description, String url) {
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
	
	public Auth getAuth() {
		return auth;
	}

	public void setAuth(Auth auth) {
		this.auth = auth;
	}

}
