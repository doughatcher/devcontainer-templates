#!/bin/bash

set -e

: ${PORT:=8443}
: ${BASEURL:="https://localhost:$PORT/"}
: ${DEPLOY_MODE:="developer"}
: ${INSTALL_SAMPLE_DATA:="false"}
: ${COMMERCE_EDITION:="magento/community-edition"} # magento/community-edition
: ${SKIP_SETUP:="false"}


if [ "$SKIP_SETUP" != "true" ]
then

    if [ ! -f app/etc/env.php ]
        then

        if [ -z "$(ls -A)" ]; then
            composer create-project --repository-url=https://repo.magento.com/ $COMMERCE_EDITION ./new

            if [ -n "$COMPOSER_REQUIRES" ]; then
                composer require $COMPOSER_REQUIRES
            fi

        else
        composer install
        fi

        INSTALL="true"
        bin/magento setup:install \
            --backend-frontname=backend \
            --amqp-host=127.0.0.1 \
            --amqp-port=5672 \
            --amqp-user=guest \
            --amqp-password=guest \
            --db-host=127.0.0.1 \
            --db-user=magento \
            --db-password=magento \
            --db-name=magento \
            --search-engine=opensearch \
            --opensearch-host=127.0.0.1 \
            --opensearch-port=9200 \
            --opensearch-index-prefix=magento2 \
            --opensearch-enable-auth=1 \
            --opensearch-username=admin \
            --opensearch-password=fhgLpkH66PwD \
            --opensearch-timeout=15 \
            --session-save=redis \
            --session-save-redis-host=127.0.0.1 \
            --session-save-redis-port=6379 \
            --session-save-redis-db=2 \
            --session-save-redis-max-concurrency=20 \
            --cache-backend=redis \
            --cache-backend-redis-server=127.0.0.1 \
            --cache-backend-redis-db=0 \
            --cache-backend-redis-port=6379 \
            --page-cache=redis \
            --page-cache-redis-server=127.0.0.1 \
            --page-cache-redis-db=1 \
            --page-cache-redis-port=6379

        bin/magento config:set --lock-env web/secure/use_in_frontend 1
        bin/magento config:set --lock-env web/secure/use_in_adminhtml 1
        bin/magento config:set --lock-env web/seo/use_rewrites 1
        bin/magento config:set --lock-env system/full_page_cache/caching_application 1
        bin/magento config:set --lock-env system/full_page_cache/ttl 604800
        bin/magento config:set --lock-env catalog/search/enable_eav_indexer 1
        bin/magento config:set --lock-env dev/static/sign 0

        # bin/magento admin:adobe-ims:enable \
        #                 --organization-id=$IMS_ORG_ID \
        #                 --client-id=IMS_CLIENT_ID \
        #                 --client-secret=$IMS_CLIENT_SECRET \
        #                 --2fa=$IMS_2FA_ENABLED

        bin/magento module:disable Magento_AdminAdobeImsTwoFactorAuth Magento_TwoFactorAuth

        bin/magento cache:enable block_html full_page

        bin/magento admin:user:create --admin-user admin --admin-password admin123 --admin-firstname demo --admin-lastname user --admin-email noreply@blueacornici.com

        if [ -n "$POST_INSTALL_CMD" ]; then
            eval "$POST_INSTALL_CMD"
        fi

        bin/magento config:set --lock-env web/unsecure/base_url "$BASEURL"
        bin/magento config:set --lock-env web/secure/base_url "$BASEURL"

        bin/magento deploy:mode:set $DEPLOY_MODE
        bin/magento indexer:reindex
    else
        bin/magento setup:upgrade
    fi

    bin/magento cache:flush

fi

