package dashboard.views.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import dashboard.views.dao.interfaces.IVDeviceDao;
import dashboard.views.dto.interfaces.IVDevice;
import es.prodevelop.pui9.exceptions.PuiDaoFindException;
import es.prodevelop.pui9.model.dao.AbstractViewDao;

@Repository
public class VDeviceDao extends AbstractViewDao<IVDevice> implements IVDeviceDao{

	@Override
	public List<IVDevice> findById(Integer id) throws PuiDaoFindException {
		return super.findByColumn(IVDevice.ID_FIELD, id);
	}

	@Override
	public List<IVDevice> findByName(String name) throws PuiDaoFindException {
		return super.findByColumn(IVDevice.NAME_FIELD, name);
	}

	@Override
	public List<IVDevice> findByDescription(String description) throws PuiDaoFindException {
		return super.findByColumn(IVDevice.DESCRIPTION_FIELD, description);
	}



	
}
