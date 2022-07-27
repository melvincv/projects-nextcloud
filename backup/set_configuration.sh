#!/bin/bash
# Define Container Name
NEXTCLOUD_SVR='nextcloud-app-1'
# Define Service Names
ONLYOFFICE_SVR='onlyoffice-server'
NGINX_SVR='nginx'

set -x

docker exec -u www-data ${NEXTCLOUD_SVR} php occ --no-warnings config:system:get trusted_domains >> trusted_domain.tmp

if ! grep -q "${NGINX_SVR}" trusted_domain.tmp; then
    TRUSTED_INDEX=$(cat trusted_domain.tmp | wc -l);
    docker exec -u www-data ${NEXTCLOUD_SVR} php occ --no-warnings config:system:set trusted_domains $TRUSTED_INDEX --value="${NGINX_SVR}"
fi

rm trusted_domain.tmp

docker exec -u www-data ${NEXTCLOUD_SVR} php occ --no-warnings app:install onlyoffice

docker exec -u www-data ${NEXTCLOUD_SVR} php occ --no-warnings config:system:set onlyoffice DocumentServerUrl --value="/ds-vpath/"
docker exec -u www-data ${NEXTCLOUD_SVR} php occ --no-warnings config:system:set onlyoffice DocumentServerInternalUrl --value="http://${ONLYOFFICE_SVR}/"
docker exec -u www-data ${NEXTCLOUD_SVR} php occ --no-warnings config:system:set onlyoffice StorageUrl --value="http://${NGINX_SVR}/"
