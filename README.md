
# igloo-build-tools


##### `gitlab-ci.yml` sample

```yaml
image: igloo/test-runner

stages:
  - release
  - deploy

.docker-env: &docker-env
  image: igloo/build-tools:v0.1.4
  services:
    - docker:1.13.1-dind
  variables:
    DOCKER_DRIVER: overlay2
  tags:
    - docker-dind

release:
  <<: *docker-env
  stage: release
  only:
    - master
    - next
  script:
    - . ci-setup
    - ci-build
    - ci-release

deploy-master:
  <<: *docker-env
  stage: deploy
  environment: production
  only:
    - master
  artifacts:
    paths:
    - .kube-deploy
  script:
    - . ci-setup
    - ci-deploy "./deploy/*.yml"
```
