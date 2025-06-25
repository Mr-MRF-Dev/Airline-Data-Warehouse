FROM mcr.microsoft.com/mssql/server:2022-latest

LABEL name="Airline DWH Database" \
    description="MSSQL Server for Airline DWH Application" \
    version="1.0"

ENV ACCEPT_EULA=Y
ENV MSSQL_SA_PASSWORD=Admin@Pass
ENV MSSQL_PID=Developer

EXPOSE 1433

VOLUME /var/opt/mssql

COPY ./source-database/*.sql /scripts/
COPY ./source-database/data/*.sql /scripts/data/
COPY ./data-warehouse/*.sql /scripts/
COPY ./data-warehouse/data/*.sql /scripts/data/
COPY ./storage-area/*.sql /scripts/

RUN /bin/bash -c "/opt/mssql/bin/sqlservr & sleep 30 & /opt/mssql-tools18/bin/sqlcmd -S localhost,1433 -U sa -P Admin@Pass -C -i /scripts/source-db-ddl.sql \
    && /opt/mssql-tools18/bin/sqlcmd -S localhost,1433 -U sa -P Admin@Pass -C -i /scripts/dwh-db-ddl.sql \
    && /opt/mssql-tools18/bin/sqlcmd -S localhost,1433 -U sa -P Admin@Pass -C -i /scripts/sa-db-ddl.sql \
    && /opt/mssql-tools18/bin/sqlcmd -S localhost,1433 -U sa -P Admin@Pass -C -i /scripts/data/data-source-db-dml.sql \
    && /opt/mssql-tools18/bin/sqlcmd -S localhost,1433 -U sa -P Admin@Pass -C -i /scripts/data/big-data-source-db-dml.sql \
    && /opt/mssql-tools18/bin/sqlcmd -S localhost,1433 -U sa -P Admin@Pass -C -i /scripts/data/data-datetime-dim-script-dml.sql \
    "

CMD [ "/opt/mssql/bin/sqlservr" ]
