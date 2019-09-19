# References:
# https://nodejs.org/en/docs/guides/nodejs-docker-webapp/
# https://docs.docker.com/develop/develop-images/multistage-build/

FROM node:11.6 as builder
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build
RUN npm ci --only=production

FROM node:11.6
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app .
EXPOSE 3000

CMD ["npm", "run", "start:prod"]