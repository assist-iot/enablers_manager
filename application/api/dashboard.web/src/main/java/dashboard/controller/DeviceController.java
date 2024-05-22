package dashboard.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import dashboard.model.dao.interfaces.IDeviceDao;
import dashboard.model.dto.interfaces.IDevice;
import dashboard.model.dto.interfaces.IDevicePk;
import dashboard.service.interfaces.IDeviceService;
import dashboard.views.dao.interfaces.IVDeviceDao;
import dashboard.views.dto.interfaces.IVDevice;

@Controller
@RequestMapping("/device")
public class DeviceController
		extends AbstractController<IDevicePk, IDevice, IVDevice, IDeviceDao, IVDeviceDao, IDeviceService> {

	@Override
	protected String getReadFunctionality() {
		return "READ_DEVICE";
	}

	@Override
	protected String getWriteFunctionality() {
		return "WRITE_DEVICE";
	}

}
