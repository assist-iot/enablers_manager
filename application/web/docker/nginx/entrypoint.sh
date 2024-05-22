#!/bin/sh
envsubst '${PILOT_HOST} ${PILOT_PORT} ${GRAFANA_HOST_NAME} ${GRAFANA_HOST_PORT} ${AUTHZSERVER_HOST_NAME} ${AUTHZSERVER_HOST_PORT} ${KIBANA_HOST_NAME} ${KIBANA_HOST_PORT} ${DASHBOARD_HOST_NAME} ${DASHBOARD_HOST_PORT} ${ENABLE_AUTH_IDM}'  < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf
