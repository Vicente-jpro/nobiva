docker run --name house2_db \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=yourpassword \
  -e POSTGRES_DB=house2_development \
  -p 5432:5432 \
  -d postgres

 