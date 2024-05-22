import Vue from 'vue';
import VueRouter from 'vue-router';

Vue.use(VueRouter);

// GEN_REGISTER_COMPONENT_START
// GEN_REGISTER_COMPONENT_END

const puiRoutes = [
	{
		path: '/',
		redirect: 'home'
	},
	{
		path: 'home',
		component: () => import('pui9-base/src/components/PuiWelcomePanel.vue')
	},
	{
		path: 'usersettings',
		component: () => import('pui9-admin/src/components/admin/puiuser/PuiUserSettingsForm.vue')
	},
	{
		path: 'puiaudit',
		component: () => import('pui9-admin/src/components/config/puiaudit/PuiAuditGrid.vue')
	},
	{
		path: 'session',
		component: () => import('pui9-admin/src/components/config/puisession/PuiSessionGrid.vue')
	},
	{
		path: 'puiuser',
		component: () => import('pui9-admin/src/components/admin/puiuser/PuiUserGrid.vue')
	},
	{
		path: '(.*/)?puiuser/:method/:pk',
		props: true,
		component: () => import('pui9-admin/src/components/admin/puiuser/PuiUserForm.vue')
	},
	{
		path: 'puiprofile',
		component: () => import('pui9-admin/src/components/admin/puiprofile/PuiProfileGrid.vue')
	},
	{
		path: '(.*/)?puiprofile/:method/:pk',
		props: true,
		component: () => import('pui9-admin/src/components/admin/puiprofile/PuiProfileForm.vue')
	},
	{
		path: 'puifunctionality',
		component: () => import('pui9-admin/src/components/admin/puifunctionality/PuiFunctionalityGrid.vue')
	},
	{
		path: 'puivariable',
		component: () => import('pui9-admin/src/components/config/puivariable/PuiVariableGrid.vue')
	},
	{
		path: '(.*/)?puivariable/:method/:pk',
		props: true,
		component: () => import('pui9-admin/src/components/config/puivariable/PuiVariableForm.vue')
	},
	{ path: 'puilanguage', component: () => import('pui9-admin/src/components/config/puilanguage/PuiLanguageGrid.vue') },
	{
		path: '(.*/)?puilanguage/:method/:pk',
		props: true,
		component: () => import('pui9-admin/src/components/config/puilanguage/PuiLanguageForm.vue')
	},
	{
		path: 'puiwidget',
		component: () => import('pui9-dashboard/src/components/puiwidget/PuiWidgetGrid.vue')
	},
	{
		path: '(.*/)?puiwidget/:method/:pk',
		props: true,
		component: () => import('pui9-dashboard/src/components/puiwidget/PuiWidgetForm.vue')
	},
	{
		path: 'puidashboard',
		component: () => import('pui9-dashboard/src/components/puidashboard/PuiDashboardGrid.vue')
	},
	{
		path: '(.*/)?puidashboard/:method/:pk',
		props: true,
		component: () => import('pui9-dashboard/src/components/puidashboard/PuiDashboardForm.vue')
	},
	{
		path: 'puiwidgetoverview',
		component: () => import('pui9-dashboard/src/components/PuiWidgetOverview.vue')
	},
	{
		path: 'puidashboardoverview',
		component: () => import('pui9-dashboard/src/components/PuiDashboardOverview.vue')
	}
];

const appRoutes = [
	// GEN_ROUTES_START
	{ path: 'plugins', component: () => import('@/components/Plugins.vue') },
	{ path: 'pilot3bcloud', component: () => import('@/components/pilot3b/Pilot3bCloud.vue'), props: {variable: 'PILOT_3B_CLOUD_DASHBOARD'}},
	{ path: 'pilot3bedge', component: () => import('@/components/pilot3b/Pilot3bEdge.vue'), props: {variable: 'PILOT_3B_EDGE_DASHBOARD'}},
	{ path: 'pilot3bfl', component: () => import('@/components/pilot3b/Pilot3bFl.vue'), props: {variable: 'PILOT_3B_FL_DASHBOARD'} },
	{ path: 'device', component: () => import('@/components/device/DeviceGrid.vue') },
	{ path: '(.*)device/:method/:pk', props: true, component: () => import('@/components/device/DeviceForm.vue') },
	{ path: 'helmrepository', component: () => import('@/components/Helmrepository.vue') }, //@/components/helmrepository/HelmRepositoryGrid.vue
	// { path: '(.*)helmrepository/:method/:pk', props: true, component: () => import('@/components/helmrepository/HelmRepositoryForm.vue') },
	{ path: 'k8scluster', component: () => import('@/components/K8scluster.vue') },
	{ path: 'groupofcars', component: () => import('@/components/Groupofcars.vue') },
	{ path: 'cars', component: () => import('@/components/Cars.vue') },
	{ path: 'pilot3a', component: () => import('@/components/pilot3a/PilotPage.vue') },
	{ path: 'clustertopology', component: () => import('@/components/K8sclustertopology.vue') },
	{ path: 'enabler', component: () => import('@/components/Enabler.vue') },
	// GEN_ROUTES_END
];

const puiNotFound = [{ path: '*', component: () => import('pui9-base/src/components/PuiNotFound') }];

function setAuthRequired(route) {
	return { ...route, meta: { ...route.meta, requiresAuth: true } };
}

const mergedRouter = {
	mode: 'history',
	hash: false,
	base: '/assistiot',
	routes: [
		{
			path: '/login',
			component: () => import('pui9-base/src/components/PuiIntroLayout')
		},
		{
			path: `/`,
			component: () => import('pui9-base/src/components/PuiBaseLayout'),
			children: puiRoutes.concat(appRoutes).concat(puiNotFound).map(setAuthRequired)
		}
	]
};

export default new VueRouter(mergedRouter);
