package dashboard.model.helmrepository;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.google.gson.annotations.SerializedName;

import es.prodevelop.pui9.annotations.PuiEntity;
import es.prodevelop.pui9.annotations.PuiField;

@PuiEntity(tablename = "helmrepository")
public class HelmRepository implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@PuiField(columnname = "uid", ispk = true)
	@SerializedName("uid")
	@JsonProperty("uid")
	private String uid;
	@PuiField(columnname = "name", ispk = false)
	private String name;
	@PuiField(columnname = "description")
	private String description;
	private String type;
	private String url;
	private String status;

	public HelmRepository() {

	}

	public HelmRepository(String uid, String name, String description, String status, String type, String url) 
	{
		super();
		this.uid = uid;
		this.name = name;
		this.description = description;
		this.status = status;
		this.type = type;
		this.url = url;
	}

	public String getId() {
		return uid;
	}

	public void setId(String uid) {
		this.uid = uid;
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

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}


}
