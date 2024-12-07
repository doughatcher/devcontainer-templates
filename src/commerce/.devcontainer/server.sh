#!/bin/bash

if [ "$PHP_MODE" == "fpm" ]; then
    echo "Running in FPM mode"
    php-fpm --allow-to-run-as-root --nodaemonize
else
    echo "Running in built-in server mode"
    php -S 127.0.0.1:$PORT -t ./pub/ ./phpserver/router.php
fi
