url="https://www.uol.com.br"
docker build -t check_availability -f Dockerfile_checkavailability .
docker run --rm -ti -e URL=$url check_availability
