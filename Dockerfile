FROM node:14

# Install Docker dependencies
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common

# Install Docker
RUN curl -fsSL https://get.docker.com | sh

# Create the "jenkins" user
RUN useradd -m -s /bin/bash jenkins

# Add the Jenkins user to the docker group
RUN usermod -aG docker jenkins
RUN usermod -aG sudo jenkins

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy package.json
COPY package.json ./

# Install app dependencies
RUN npm install

# Bundle app source
COPY . ./
EXPOSE 9000
CMD [ "npm", "start" ]
