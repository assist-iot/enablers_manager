package dashboard.model.dto.interfaces;

public interface IDevice extends IDevicePk {

	public String NAME_COLUMN = "name";
	public String NAME_FIELD = "name";
	
	public String DESCRIPTION_COLUMN = "description";
	public String DESCRIPTION_FIELD = "description";
	
	String getName();
	void setName(String name);
	
	String getDescription();
	void setDescription(String description);
}
