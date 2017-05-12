
# igloo-build-tools


##### `gitlab-ci.yml` sample

```yaml
image: igloo/test-runner

stages:
  - release
  - deploy

.docker-env: &docker-env
  image: docker:1.13.1
  services:
    - docker:1.13.1-dind
  variables:
    DOCKER_DRIVER: overlay2
  before_script:
    - apk add --no-cache curl
    - curl https://raw.githubusercontent.com/iGLOO-be/igloo-build-tools/v0.0.13/install.sh | sh

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
