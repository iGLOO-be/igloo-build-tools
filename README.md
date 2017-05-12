
# igloo-build-tools


##### `gitlab-ci.yml` sample

```yaml
image: igloo/test-runner

stages:
  - release
  - deploy

.docker-env: &docker-env
  image: igloo/build-tools:0.0.14
  services:
    - docker:1.13.1-dind
  variables:
    DOCKER_DRIVER: overlay2

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
