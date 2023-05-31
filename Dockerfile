FROM node:14

# Instalar dependencias de Docker dentro de la imagen
RUN apt-get update && \
    apt-get install ca-certificates curl gnupg

RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN chmod a+r /etc/apt/keyrings/docker.gpg
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

CMD [ "npm", "start" ]