package dashboard.model.dto;

import dashboard.model.dto.interfaces.IDevicePk;
import es.prodevelop.pui9.annotations.PuiField;
import es.prodevelop.pui9.enums.ColumnType;
import es.prodevelop.pui9.model.dto.AbstractTableDto;
import es.prodevelop.pui9.utils.PuiObjectUtils;

public class DevicePk extends AbstractTableDto implements IDevicePk {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@PuiField(columnname = IDevicePk.ID_COLUMN, ispk = true, nullable = false, type = ColumnType.numeric)
	private Integer id;
	
	public DevicePk() {
	}
	
	public DevicePk(Integer id) {
		this.id = id;
	}

	@Override
	public Integer getId() {
		return id;
	}

	@Override
	public void setId(Integer id) {
		this.id = id;
	}

	@Override
	@SuppressWarnings("unchecked")
	public DevicePk createPk() {
//		IDevicePk idevicePk = new DevicePk();
		DevicePk pk = new DevicePk();
		PuiObjectUtils.copyProperties(pk, this);
		return pk;
	}

}
