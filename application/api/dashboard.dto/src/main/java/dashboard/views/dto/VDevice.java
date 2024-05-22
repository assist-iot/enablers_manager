package dashboard.views.dto;

import dashboard.views.dto.interfaces.IVDevice;
import es.prodevelop.pui9.annotations.PuiEntity;
import es.prodevelop.pui9.annotations.PuiField;
import es.prodevelop.pui9.annotations.PuiViewColumn;
import es.prodevelop.pui9.model.dto.AbstractViewDto;

@PuiEntity(tablename = "v_device")
public class VDevice extends AbstractViewDto implements IVDevice{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@PuiField(columnname = IVDevice.ID_COLUMN)
	@PuiViewColumn(order = 1)
	private Integer id;
	
	@PuiField(columnname = IVDevice.NAME_COLUMN)
	@PuiViewColumn(order = 2)
	private String name;
	
	@PuiField(columnname = IVDevice.DESCRIPTION_COLUMN)
	@PuiViewColumn(order = 3)
	private String description;
	
	@Override
	public Integer getId() {
		return id;
	}

	@Override
	public void setId(Integer id) {
		this.id = id;
	}
	
	@Override
	public String getName() {
		return name;
	}

	@Override
	public void setName(String name) {
		this.name = name;
	}

	@Override
	public String getDescription() {
		return description;
	}

	@Override
	public void setDescription(String description) {
		this.description = description;
	}

}
