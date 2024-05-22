package dashboard.views.dto.interfaces;

import es.prodevelop.pui9.model.dto.interfaces.IViewDto;

public interface IVDevice extends IViewDto {

	public String ID_COLUMN = "id";
	public String ID_FIELD = "id";

	public String NAME_COLUMN = "name";
	public String NAME_FIELD = "name";
	
	public String DESCRIPTION_COLUMN = "description";
	public String DESCRIPTION_FIELD = "description";
	
	Integer getId();
	void setId(Integer id);
	
	String getName();
	void setName(String name);
	
	String getDescription();
	void setDescription(String description);
}
