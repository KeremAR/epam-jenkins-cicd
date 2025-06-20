    FROM node:7.8.0

    WORKDIR /app

    COPY package.json ./

    RUN npm install

    COPY . .

    EXPOSE 3000

    ENTRYPOINT ["npm", "start"]
