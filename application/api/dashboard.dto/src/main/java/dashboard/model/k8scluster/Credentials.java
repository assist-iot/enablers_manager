package dashboard.model.k8scluster;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.google.gson.annotations.SerializedName;

public class Credentials {

	private String apiVersion;
	private List<Cluster> clusters;
	private List<Context> contexts;
	@SerializedName("current-context")
	@JsonProperty("current-context")
	private String currentContext;
	private String kind;
	private Object preferences;
	private List<User> users;

	public Credentials(String apiVersion, List<Cluster> clusters, List<Context> contexts, String currentContext,
			String kind, Object preferences, List<User> users) {
		super();
		this.apiVersion = apiVersion;
		this.clusters = clusters;
		this.contexts = contexts;
		this.currentContext = currentContext;
		this.kind = kind;
		this.preferences = preferences;
		this.users = users;
	}

	public Credentials() {
	}

	public String getApiVersion() {
		return apiVersion;
	}

	public void setApiVersion(String apiVersion) {
		this.apiVersion = apiVersion;
	}

	public List<Cluster> getClusters() {
		return clusters;
	}

	public void setClusters(List<Cluster> clusters) {
		this.clusters = clusters;
	}

	public String getCurrentContext() {
		return currentContext;
	}

	public void setCurrentContext(String currentContext) {
		this.currentContext = currentContext;
	}

	public String getKind() {
		return kind;
	}

	public void setKind(String kind) {
		this.kind = kind;
	}

	public Object getPreferences() {
		return preferences;
	}

	public void setPreferences(Object preferences) {
		this.preferences = preferences;
	}

	public List<Context> getContexts() {
		return contexts;
	}

	public void setContexts(List<Context> contexts) {
		this.contexts = contexts;
	}

	public List<User> getUsers() {
		return users;
	}

	public void setUsers(List<User> users) {
		this.users = users;
	}

	static class Cluster {
		private String name;
		private Details cluster;

		public Cluster() {

		}

		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}

		public Details getCluster() {
			return cluster;
		}

		public void setCluster(Details cluster) {
			this.cluster = cluster;
		}

		static class Details {
			@SerializedName("certificate-authority-data")
			@JsonProperty("certificate-authority-data")
			private String certificateAuthorityData;
			private String server;

			public Details() {

			}

			public String getCertificateAuthorityData() {
				return certificateAuthorityData;
			}

			public void setCertificateAuthorityData(String certificateAuthorityData) {
				this.certificateAuthorityData = certificateAuthorityData;
			}

			public String getServer() {
				return server;
			}

			public void setServer(String server) {
				this.server = server;
			}

		}
	}

	static class Context {

		private String name;
		private Details context;

		public Context() {

		}

		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}

		public Details getContext() {
			return context;
		}

		public void setContext(Details context) {
			this.context = context;
		}

		static class Details {
			private String cluster;
			private String user;

			public Details() {

			}

			public String getCluster() {
				return cluster;
			}

			public void setCluster(String cluster) {
				this.cluster = cluster;
			}

			public String getUser() {
				return user;
			}

			public void setUser(String user) {
				this.user = user;
			}
		}
	}

	static class User {
		private String name;
		private Details user;

		public User() {
		}

		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}

		public Details getUser() {
			return user;
		}

		public void setUser(Details user) {
			this.user = user;
		}

		static class Details {
			@SerializedName("client-certificate-data")
			@JsonProperty("client-certificate-data")
			private String clientCertificateData;
			@SerializedName("client-key-data")
			@JsonProperty("client-key-data")
			private String clientKeyData;

			public Details() {
				super();
			}

			public String getClientCertificateData() {
				return clientCertificateData;
			}

			public void setClientCertificateData(String clientCertificateData) {
				this.clientCertificateData = clientCertificateData;
			}

			public String getClientKeyData() {
				return clientKeyData;
			}

			public void setClientKeyData(String clientKeyData) {
				this.clientKeyData = clientKeyData;
			}

		}
	}
}
