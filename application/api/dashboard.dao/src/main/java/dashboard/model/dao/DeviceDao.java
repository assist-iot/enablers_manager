package dashboard.model.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import dashboard.model.dao.interfaces.IDeviceDao;
import dashboard.model.dto.interfaces.IDevice;
import dashboard.model.dto.interfaces.IDevicePk;
import es.prodevelop.pui9.exceptions.PuiDaoFindException;
import es.prodevelop.pui9.model.dao.AbstractTableDao;

@Repository
public class DeviceDao extends AbstractTableDao<IDevicePk, IDevice> implements IDeviceDao {

	@Override
	public List<IDevice> findById(Integer id) throws PuiDaoFindException {
		return super.findByColumn(IDevicePk.ID_FIELD, id);
	}

	@Override
	public List<IDevice> findByName(String name) throws PuiDaoFindException {
		return super.findByColumn(IDevice.NAME_FIELD, name);
	}

	@Override
	public List<IDevice> findByDescription(String description) throws PuiDaoFindException {
		return super.findByColumn(IDevice.DESCRIPTION_FIELD, description);
	}

}
