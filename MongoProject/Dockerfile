FROM swift:latest

# Install OpenSSL dependencies
RUN apt-get update && apt-get install -y libssl-dev

WORKDIR /usr/src/app
COPY . .
RUN swift build --configuration release
CMD [ "swift", "run", "--configuration", "release" ]
