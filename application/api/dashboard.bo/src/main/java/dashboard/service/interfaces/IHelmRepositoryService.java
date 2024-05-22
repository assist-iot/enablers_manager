package dashboard.service.interfaces;

import java.util.List;
import com.google.gson.JsonArray;

import dashboard.model.helmrepository.Chart;
import dashboard.model.helmrepository.HelmRepository;
import dashboard.model.helmrepository.NewPublicHelmRepository;
import dashboard.model.helmrepository.NewPrivateHelmRepository;
import es.prodevelop.pui9.search.SearchResponse;

public interface IHelmRepositoryService {

	List<HelmRepository> getRepositoryList();

	SearchResponse<HelmRepository> getRepositorySearchResults();

	NewPublicHelmRepository addPublicRepository(NewPublicHelmRepository repository);

	NewPrivateHelmRepository addPrivateRepository(NewPrivateHelmRepository repository);

	void updateRepositories();

	void deleteRepository(String repositoryId);

	JsonArray getCharts(String repoId);

}
