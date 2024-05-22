package dashboard.service.interfaces;

import java.util.List;

import com.google.gson.JsonObject;

import dashboard.model.CarGroup;

import dashboard.model.CarGroupCarCount;
import dashboard.model.NewCarGroup;

public interface ICarGroupService {
	
	CarGroup getGroupById(String groupId);
	
	List<CarGroupCarCount> getGroups();

	JsonObject createGroup(NewCarGroup carGroup);
	
	void deleteGroup(String groupId);
}
