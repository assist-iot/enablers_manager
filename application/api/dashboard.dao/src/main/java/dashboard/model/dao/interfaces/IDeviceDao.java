package dashboard.model.dao.interfaces;

import java.util.List;

import dashboard.model.dto.interfaces.IDevice;
import dashboard.model.dto.interfaces.IDevicePk;
import es.prodevelop.pui9.exceptions.PuiDaoFindException;
import es.prodevelop.pui9.model.dao.interfaces.ITableDao;

public interface IDeviceDao extends ITableDao<IDevicePk, IDevice> {

	List<IDevice> findById(Integer id) throws PuiDaoFindException;

	List<IDevice> findByName(String name) throws PuiDaoFindException;

	List<IDevice> findByDescription(String description) throws PuiDaoFindException;

}
