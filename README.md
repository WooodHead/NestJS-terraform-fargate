A working example of NestJS app deployed using [AWS ECS](https://aws.amazon.com/ecs/) with [AWS Fargate](https://aws.amazon.com/fargate/) as the compute engine. Based on [terraform-fargate-example](https://github.com/Oxalide/terraform-fargate-example) & [NestJS starter](https://github.com/nestjs/typescript-starter).

## Build (not automated yet, to support deployment process)

### One Time Setup
- create the ECR in AWS manually
- execute `ecr-login.sh`

### Build and push the image
- execute `build.sh` to build the image locally and push to ECR

## Deployment
- `cd deploy`
- `terraform apply`

---

<p align="center">
  <a href="http://nestjs.com/" target="blank"><img src="https://nestjs.com/img/logo_text.svg" width="320" alt="Nest Logo" /></a>
</p>

[travis-image]: https://api.travis-ci.org/nestjs/nest.svg?branch=master
[travis-url]: https://travis-ci.org/nestjs/nest
[linux-image]: https://img.shields.io/travis/nestjs/nest/master.svg?label=linux
[linux-url]: https://travis-ci.org/nestjs/nest
  
  <p align="center">A progressive <a href="http://nodejs.org" target="blank">Node.js</a> framework for building efficient and scalable server-side applications, heavily inspired by <a href="https://angular.io" target="blank">Angular</a>.</p>
    
## Description

[Nest](https://github.com/nestjs/nest) framework TypeScript starter repository.

## Installation

```bash
$ npm install
```

## Running the app

```bash
# development
$ npm run start

# watch mode
$ npm run start:dev

# production mode
$ npm run start:prod
```

## Test

```bash
# unit tests
$ npm run test

# e2e tests
$ npm run test:e2e

# test coverage
$ npm run test:cov
```
