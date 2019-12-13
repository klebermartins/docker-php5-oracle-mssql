# docker-php5-oracle-mssql
Clone conf folder before build image.

git clone https://github.com/klebermartins/docker-php5-oracle-mssql.git
cd docker-php5-oracle-mssql/
docker build -t docker-php5-oracle-mssql .
docker run --name {container_name} -dit -v {local_folder}:/var/www/html -p 8181:80 docker-php5-oracle-mssql 




