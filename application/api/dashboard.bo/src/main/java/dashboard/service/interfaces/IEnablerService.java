package dashboard.service.interfaces;

import java.util.List;

import com.google.gson.JsonObject;

import dashboard.model.Enabler;
import dashboard.model.EnablerCluster;
import dashboard.model.NewEnabler;

public interface IEnablerService {

	List<Enabler> getEnablerList();

	List<EnablerCluster> getClusterEnablerList(String clusterId);

	JsonObject addEnabler(NewEnabler enabler);

	JsonObject upgradeEnabler( String enablerId, NewEnabler enabler);

	void deleteEnabler(String enablerId, String force, String timeout);

	void deleteEnablerPv(String enablerId);

}
