FROM node:14

# Install Docker dependencies
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common

# Install Docker
RUN curl -fsSL https://get.docker.com | sh

# Add the Jenkins user to the docker group
RUN usermod -aG docker jenkins

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install

# Bundle app source
COPY . /usr/src/app

EXPOSE 9000
CMD [ "npm", "start" ]