docker build -t blue-green-demo -f AdvisorApi/Dockerfile .
docker run -d -p 5020:80 blue-green-demo 