package dashboard.service;

import org.springframework.stereotype.Service;

import dashboard.model.dao.interfaces.IDeviceDao;
import dashboard.model.dto.interfaces.IDevice;
import dashboard.model.dto.interfaces.IDevicePk;
import dashboard.service.interfaces.IDeviceService;
import dashboard.views.dao.interfaces.IVDeviceDao;
import dashboard.views.dto.interfaces.IVDevice;
import es.prodevelop.pui9.service.AbstractService;

@Service
public class DeviceService extends AbstractService<IDevicePk, IDevice, IVDevice, IDeviceDao, IVDeviceDao>
		implements IDeviceService {

}
