package dashboard.service.interfaces;

import dashboard.model.dao.interfaces.IDeviceDao;
import dashboard.model.dto.interfaces.IDevice;
import dashboard.model.dto.interfaces.IDevicePk;
import dashboard.views.dao.interfaces.IVDeviceDao;
import dashboard.views.dto.interfaces.IVDevice;
import es.prodevelop.pui9.service.interfaces.IService;

public interface IDeviceService extends IService<IDevicePk, IDevice, IVDevice, IDeviceDao, IVDeviceDao>{


}
