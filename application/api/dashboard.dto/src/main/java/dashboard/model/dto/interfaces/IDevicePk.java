package dashboard.model.dto.interfaces;

import es.prodevelop.pui9.model.dto.interfaces.ITableDto;

public interface IDevicePk extends ITableDto {

	public String ID_COLUMN = "id";
	public String ID_FIELD = "id";
	
	Integer getId();
	void setId(Integer id);
	
}
