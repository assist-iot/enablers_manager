package dashboard.service.interfaces;

import java.util.List;

import com.google.gson.JsonObject;

import dashboard.model.CarEnablerInGroup;
import dashboard.model.CarEnabler;
import dashboard.model.NewCarEnabler;

public interface ICarEnablerService {
	
	List<CarEnabler> getEnablerInCar(String carId);
	
	List<CarEnablerInGroup> getGroupEnablerById(String groupId);

	JsonObject createEnablerInGroup(String groupId, NewCarEnabler carEnabler);

	JsonObject createEnablerInCar(String groupId, String carId, NewCarEnabler carEnabler);
	
	void deleteEnablerInGroup(String groupId, String enablerName);
	
	void deleteEnablerInCar(String groupId, String carId, String enablerName);
}
