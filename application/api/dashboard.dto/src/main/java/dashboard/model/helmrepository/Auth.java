package dashboard.model.helmrepository;

public class Auth {

	private String username;
	private String password;

	public Auth(String username, String password) {
		super();
		this.username = username;
		this.password = password;
	}

	public String getUsername() {
		return username;
	}

	public void Username(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void Password(String password) {
		this.password = password;
	}

}
