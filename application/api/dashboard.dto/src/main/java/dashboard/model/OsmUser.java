package dashboard.model;

public class OsmUser {

	private String username;
	private String password;

	public OsmUser(String username, String password) {
		super();
		this.username = username;
		this.password = password;
	}

	public OsmUser() {
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

}
