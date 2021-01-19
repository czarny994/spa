FROM node:15.5-alpine3.10 AS build-step
RUN mkdir -p /app
WORKDIR /app
COPY package.json package-lock.json /app/
RUN npm install
COPY . /app
RUN npm run build --prod

FROM nginx:1.18.0-alpine
COPY --from=build-step /app/dist/hello-spa /usr/share/nginx/html
