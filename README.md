# igloo-build-tools

## Input env variables

- `NO_DOCKER_LOGIN`: Set to `yes` to skip docker login
- `NO_K8S_TEMPLATE`: Set to `yes` to not replace variables

### Image config

- `IMAGE_SUFFIX` (default: "") : Append a string at the end of the image name
- `IMAGE_TAG_PREFIX` (default: "")
- `KUBE_NAMESPACE`: (optional) Force a namespace
- `KUBE_NAMESPACE_ENV` (default: "") : Append a string a the end of the k8s namespace

### Kubernetes authentication

- `KUBE_SERVER`
- `KUBE_USERNAME`
- `KUBE_PASSWORD`
- `KUBE_TOKEN`
- `KUBE_CLIENT_CERTIFICATE_DATA`
- `KUBE_CLIENT_CERTIFICATE_DATA_ENCODED`: Set true if `KUBE_CLIENT_CERTIFICATE_DATA` is already encoded
- `KUBE_CLIENT_KEY_DATA`
- `KUBE_CLIENT_KEY_DATA_ENCODED`: Set true if `KUBE_CLIENT_KEY_DATA` is already encoded

### For Google Cloud:

- `GCLOUD_SERVICE_ACCOUNT_NAME` [optional]
- `GCLOUD_SERVICE_ACCOUNT_KEY`
- `GCLOUD_CLUSTER_NAME`
- `GCLOUD_CLUSTER_ZONE`

## Output env variables

- `KUBE_NAMESPACE` (example: `namespace-project-name`)
- `KUBE_IMAGE` (example: `123.dkr.ecr.eu-west-1.amazonaws.com/namespace/project-name`)
- `KUBE_DEPLOY_DATE` (example: `2018-04-25T21:33:46Z`)

## Sample

##### `gitlab-ci.yml`

```yaml
.docker-env:
  image: igloo/build-tools:v0.3.1
  services:
    - docker:23.0.5-dind
  variables:
    DOCKER_DRIVER: overlay2
  tags:
    - docker-dind

release:
  extends: .docker-env
  stage: release
  script:
    - . ci-setup
    - ci-build
    - ci-release

deploy-master:
  extends: .docker-env
  stage: deploy
  artifacts:
    paths:
      - .kube-deploy
  script:
    - . ci-setup
    - ci-deploy "./deploy/*.yml"
```

With `helm`

```yaml
.deploy:
  extends: .docker-env
  stage: deploy
  artifacts:
    paths:
    - .kube-deploy
  script:
    - . ci-setup
    - . ci-setup-k8s
    - helm upgrade --install
        $KUBE_NAMESPACE
        --namespace $KUBE_NAMESPACE
        ./deploy/chart
```
