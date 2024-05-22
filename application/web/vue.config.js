const DASHBOARD_HOST = (process.env.DASHBOARD_HOST) ? process.env.DASHBOARD_HOST : '158.42.161.177';
const PILOT_HOST = (process.env.PILOT_HOST) ? process.env.PILOT_HOST : '158.42.161.177';
const KIBANA_HOST = (process.env.KIBANA_HOST) ? process.env.KIBANA_HOST : '158.42.161.177';
const ENABLE_AUTH_IDM = (process.env.ENABLE_AUTH_IDM) ? process.env.ENABLE_AUTH_IDM : true; 

module.exports = {
	transpileDependencies: ['vuetify'],
	chainWebpack: (config) => {
		config.plugin('html').tap((args) => {
			args[0].title = 'ASSIST-IoT Dashboard';
			return args;
		});
	},
	devServer: {
		port: 8081,
		watchOptions: {
			ignored: /node_modules/,
			aggregateTimeout: 300,
			poll: 300,
		},

		proxy: {
			'^/dashboard': {
				target: `http://${DASHBOARD_HOST}:30800`,
				changeOrigin: true, 
				...(ENABLE_AUTH_IDM ? {
					pathRewrite: {
						'^/dashboard/login/signin': '/dashboard/loginAutzIdm/signin'
					}
				} : {}),
			},
			'^/pilot': {
				target: `http://${PILOT_HOST}:8974`,
				changeOrigin: true,
				pathRewrite: {
					'^/pilot': ''
				  }
			}
		},
	},
	publicPath: '/assistiot'
};