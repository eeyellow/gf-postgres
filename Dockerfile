FROM postgres:11

RUN apt-get update

# postgis
RUN apt-get install -y --no-install-recommends \
        postgresql-client-11 \
        postgresql-11-postgis-2.5

# pgAgent
RUN apt-get install -y --no-install-recommends \
        pgagent

# pgBouncer
RUN apt-get install -y --no-install-recommends \
        pgbouncer

# tds_fdw
RUN apt-get install -y --no-install-recommends \
        wget \
        ca-certificates \
        postgresql-server-dev-11 \
        build-essential \
        libsybdb5 \
        freetds-dev \
        freetds-common
RUN wget https://github.com/tds-fdw/tds_fdw/archive/v2.0.0-alpha.3.tar.gz \
    && tar -xvzf v2.0.0-alpha.3.tar.gz \
    && cd tds_fdw-2.0.0-alpha.3 \
    && make USE_PGXS=1 \
    && make USE_PGXS=1 install

RUN apt-get purge -y wget postgresql-server-dev-11 build-essential ca-certificates \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tds_fdw-2.0.0-alpha.3 \
    && rm /v2.0.0-alpha.3.tar.gz


RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./config/01.initdb-postgis.sh /docker-entrypoint-initdb.d/01.initdb-postgis.sh
COPY ./config/postgresql.conf /etc/postgresql/postgresql.conf
COPY ./config/02.dbSetting.sh /docker-entrypoint-initdb.d/02.dbSetting.sh