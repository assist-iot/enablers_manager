package dashboard.model.dto;

import dashboard.model.dto.interfaces.IDevice;
import es.prodevelop.pui9.annotations.PuiEntity;
import es.prodevelop.pui9.annotations.PuiField;
import es.prodevelop.pui9.enums.ColumnType;

@PuiEntity(tablename = "device")
public class Device extends DevicePk implements IDevice {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@PuiField(columnname = IDevice.NAME_COLUMN, ispk = false, nullable = false, type = ColumnType.text)
	private String name;
	@PuiField(columnname = IDevice.DESCRIPTION_COLUMN, ispk = false, nullable = false, type = ColumnType.text)
	private String description;

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
