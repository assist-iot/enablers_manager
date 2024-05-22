package dashboard.service.interfaces;

import com.google.gson.JsonObject;
import java.util.List;
import org.springframework.http.ResponseEntity;

import dashboard.model.CarCluster;
import dashboard.model.NewCarCluster;

public interface ICarClusterService {

	CarCluster getClusterById(String clusterId);
	
	List <CarCluster> getClusterByGroup(String groupId);
	
	ResponseEntity<String> getClusterByGroupCsv(String groupId);
	
	CarCluster getClusterByIdGroup(String clusterId, String groupId);
	
	JsonObject createCluster(NewCarCluster carCluster);
	
	void deleteCluster(String clusterId);
}
