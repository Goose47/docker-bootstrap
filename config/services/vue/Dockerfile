FROM node:16 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx as production-stage
EXPOSE 80
RUN mkdir /app
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build-stage /app/dist /app