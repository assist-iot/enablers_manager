package dashboard.views.dao.interfaces;

import java.util.List;

import dashboard.views.dto.interfaces.IVDevice;
import es.prodevelop.pui9.exceptions.PuiDaoFindException;
import es.prodevelop.pui9.model.dao.interfaces.IViewDao;

public interface IVDeviceDao extends IViewDao<IVDevice> {

	List<IVDevice> findById(Integer id) throws PuiDaoFindException;
	List<IVDevice> findByName(String name) throws PuiDaoFindException;
	List<IVDevice> findByDescription(String description) throws PuiDaoFindException;
}
