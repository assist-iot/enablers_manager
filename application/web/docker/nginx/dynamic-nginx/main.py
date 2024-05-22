from kubernetes import client, config, watch
import re
import logging
import os 

config.load_kube_config()
v1 = client.CoreV1Api()
batchV1 = client.BatchV1Api()
configmap_name = os.getenv('CONFIGMAP_NAME','dashboard-dashboard-pui9-web-configmap')

def get_configmap_data():
    configmap = v1.read_namespaced_config_map(configmap_name, 'asdo')
    default_conf = configmap.data.get("default.conf", "")
    inicio_server = default_conf.find("server {")
    if inicio_server != -1:
        contador_llaves = 1
        indice = inicio_server + len("server {")
        while contador_llaves != 0 and indice < len(default_conf):
            if default_conf[indice] == '{':
                contador_llaves += 1
            elif default_conf[indice] == '}':
                contador_llaves -= 1
            indice += 1
        fin_server = indice
        if contador_llaves == 0:
            pass
        else:
            logging.error(f"Error: The keys of the server block are not balanced.")
       
        return inicio_server, fin_server, configmap, default_conf
    else:
        logging.error("Error: The start of the server block was not found.")

def add_configmap_data(service):
    try: 
        if service == 'bkpi-kibana':
            location = '/kibana'
            nginx_location = """
            location ^~ /kibana {
                rewrite ^/kibana(/.*)$ $1 break;
                proxy_pass http://bkpi-kibana.default:5601/;
                proxy_http_version 1.1;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
            }
                        """            
        elif service == 'puddash':
            location = '/grafana'
            nginx_location = """
            location ^~ /grafana {
                rewrite ^/grafana(/.*)$ $1 break;
                proxy_pass http://puddash.default:80/;
                proxy_http_version 1.1;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
            }
                        """
        elif service == 'siempilot-kibana':
            location = '/siem'
            nginx_location = """
            location ^~ /siem {
                rewrite ^/siem/(.*) /$1 break;
                proxy_pass https://siempilot-kibana.default:5601/;
                proxy_http_version 1.1;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
            }
                        """ 

        inicio_server, fin_server, configmap, default_conf = get_configmap_data()
        if inicio_server != -1 and fin_server != -1:
            # Extraer el bloque server
            server_block = default_conf[inicio_server:fin_server]
            patron_location = r"location\s+\^~\s+{}\s*{{".format(re.escape(location))

            if re.search(patron_location, server_block):
                logging.warn(f"The location {location} already exists")
                return -1
            else:
                fin_server = default_conf.find("}", inicio_server) + 1
                server_block = default_conf[inicio_server:fin_server]
                server_block  += nginx_location + "\n"
                default_conf = default_conf[:inicio_server] + server_block + default_conf[fin_server:]
                configmap.data["default.conf"] = default_conf
                v1.patch_namespaced_config_map(configmap_name, 'asdo', configmap)
                logging.info(f"The location was added succesfully")
                return 0
            
    except Exception as e:
        logging.error(f"Error during configmap patch: {e}")
        raise

def delete_configmap_data(service):
    try:
        if service == 'bkpi-kibana':
            nginx_location = """
            location ^~ /kibana {
                rewrite ^/kibana(/.*)$ $1 break;
                proxy_pass http://bkpi-kibana.default:5601/;
                proxy_http_version 1.1;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
            }
                        """            
        elif service == 'puddash':
            nginx_location = """
            location ^~ /grafana {
                rewrite ^/grafana(/.*)$ $1 break;
                proxy_pass http://puddash.default:80/;
                proxy_http_version 1.1;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
            }
                        """
        elif service == 'siempilot-kibana':
            nginx_location = """
            location ^~ /siem {
                rewrite ^/siem/(.*) /$1 break;
                proxy_pass https://siempilot-kibana.default:5601/;
                proxy_http_version 1.1;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
            }
                        """ 

        configmap = v1.read_namespaced_config_map(configmap_name, 'asdo')
        default_conf = configmap.data.get("default.conf", "")
        inicio_nginx_location = default_conf.find(nginx_location)

        if inicio_nginx_location != -1:

            fin_nginx_location = default_conf.find('}', inicio_nginx_location) + 1
            default_conf = default_conf[:inicio_nginx_location] + default_conf[fin_nginx_location:]
            configmap.data["default.conf"] = default_conf
            v1.patch_namespaced_config_map(configmap_name, 'asdo', configmap)
            logging.info(f"The location block was deleted successfully")
            return 0
        else:
            logging.error(f"The location block was not found in the default.conf file.")
            return -1
            
    except Exception as e:
        logging.error(f"Error during configmap patch: {e}")
        raise
    
def main():

    try:
        enablerServices = ['bkpi-kibana','puddash','siempilot-kibana']
        w = watch.Watch()
        for event in w.stream(v1.list_service_for_all_namespaces, timeout_seconds=0):
            if event['object'].metadata.name in enablerServices and event['type'] == 'ADDED':
                if add_configmap_data(event['object'].metadata.name)==-1:
                    continue
                else:
                    v1.delete_collection_namespaced_pod(namespace='asdo', label_selector='app.kubernetes.io/component=web,app.kubernetes.io/name=dashboard-pui9')
            elif event['object'].metadata.name in enablerServices and event['type'] == 'DELETED':
                if delete_configmap_data( event['object'].metadata.name) == -1:
                    continue
                else:
                    v1.delete_collection_namespaced_pod(namespace='asdo', label_selector='app.kubernetes.io/component=web,app.kubernetes.io/name=dashboard-pui9')
    except Exception as e:
        logging.error(f"{e}")
        raise

if __name__ == '__main__':
    main()