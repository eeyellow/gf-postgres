#!/bin/sh

set -e

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

# Load PostGIS into both template_database and $POSTGRES_DB
for DB in template_postgis "$POSTGRES_DB" "${@}"; do
    echo "Add new extensions"
    psql --dbname="$DB" -c "
        CREATE EXTENSION IF NOT EXISTS tds_fdw;
    "
done