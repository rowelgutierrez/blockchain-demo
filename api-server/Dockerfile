FROM node:alpine as builder
WORKDIR /app

# RUN npm install --quiet --global pm2@2.8.0

COPY package.json .

RUN apk add --no-cache make gcc g++ python && \
  npm install --production --silent && \
  apk del make gcc g++ python

COPY . .
# RUN npm run build

RUN npm install --global nodemon

EXPOSE 8081

CMD nodemon -L --watch "/app/" /app/index.js

# FROM nginx
# COPY --from=builder /app/build /usr/share/nginx/html