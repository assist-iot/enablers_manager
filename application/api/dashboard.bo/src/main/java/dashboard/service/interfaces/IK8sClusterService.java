package dashboard.service.interfaces;

import java.io.IOException;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import dashboard.model.k8scluster.K8sCluster;
import dashboard.model.k8scluster.K8sClusterReduced;
import dashboard.model.k8scluster.NewK8sCluster;

public interface IK8sClusterService {

	List<K8sCluster> getClusterList();

	JsonObject addCluster(NewK8sCluster cluster);

	NewK8sCluster addCluster(MultipartFile kubeconfig, String name, String description, String cloud, String cni)
			throws IOException;

	void deleteCluster(String clusterId, String force);

	List<K8sClusterReduced> getReducedClusterList();

	JsonArray getClusterNodes(String clusterId);
}
