FROM node:16-alpine as builder

WORKDIR /app

ARG LOGO_FILE=src/logo.svg

COPY package*.json ./

RUN npm install

COPY . .

COPY ${LOGO_FILE} src/logo.svg

RUN npm run build

FROM nginx:1.21-alpine

COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

