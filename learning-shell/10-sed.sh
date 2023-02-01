sed 's/unix/linux/' sample.txt
sed 's/unix/linux/2' sample.txt
sed 's/unix/linux/g' sample.txt

sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal' sample.txt

      Update REDIS_ENDPOINT with REDIS server IP Address
      Update CATALOGUE_ENDPOINT with Catalogue server IP address

      Update `REDIS_ENDPOINT` with Redis Server IP
      Update `MONGO_ENDPOINT` with MongoDB Server IP