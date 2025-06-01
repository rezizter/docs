#!/bin/bash

source ~/.cache/venv/mobile-sre-docs-3.8/bin/activate
cd /var/www/html/docs/docs
LC_ALL=en_US
export LC_ALL
git pull
cd /var/www/html/docs/
mkdocs build --clean
exit 0
