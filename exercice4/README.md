# Exercice 4

## What will be the git branching strategy, elaborate why & why not with pros and cons?

in this case I suggest a 3 branchs strategy like:

* main (for dev)
* qa (or test or whatever)
* prod

prod should be merge into test and test into main to be sure to not lose commits.

test will be align on main when needed by QA.

prod will be align on test when ready for production usage and also use to commit hotfixes.

## Which tool you will consider for CI/CD

It depends which tool they already use but here what could be used:

* Gitlab CI
* Jenkins
* Github actions
* Circle CI
* Argo CD (I never use it but it seems interesting if they have a Kubernetes cluster)

I think if tehre is nothing I will try to use Gitlab CI

## What will be your build promotion plans (Dev - QA - Prod)

CI will be tigger at any commits to run tests and build. CD will probably be trigger at every commits on dev and qa branches. For production it will require to create manually a tag to deploy (and perhaps a manual run).

## Provide CI/CD implementation plans with stages

```
stages:
  - build
  - test
  - deploy

default:
  image: debian

build_configure:
  stage: build
  script:
    - ./configure.sh

build_make:
  stage: build
  needs: [build_configure]
  script:
    - make

test_unit_tests:
  stage: test
  needs: [build_make]
  script:
    - echo "Running Unit Test"
    - make unittest

test_integration_tests:
  stage: test
  needs: [build_make]
  script:
    - echo "This run integration tests"
    - make inttest

deploy_prod:
  stage: deploy
  script:
    - echo "This job deploy to production"
    - "push my artificat(s) to s3 or equivalent"
    - launch you deployment with helm,ansible,kustomize or whatever
  rules:
    - if: $CI_COMMIT_TAG =~ /^\d+\.\d+\.\d+.*/
  environment: production

deploy_qa:
  stage: deploy
  script:
    - echo "This job deploy to production"
    - "push my artificat(s) to s3 or equivalent"
    - launch you deployment with helm,ansible,kustomize or whatever
  rules:
    - if: '$CI_COMMIT_REF_NAME == "qa" && $CI_PIPELINE_SOURCE == "push"'
  environment: qa

deploy_dev:
  stage: deploy
  script:
    - echo "This job deploy to production"
    - "push my artificat(s) to s3 or equivalent"
    - launch you deployment with helm,ansible,kustomize or whatever
  rules:
    - if: '$CI_COMMIT_REF_NAME == "main" && $CI_PIPELINE_SOURCE == "push"'
  environment: dev
```

## How will you manage module version dependencies

Probably with git submodules in a main repository and I will suggest to migrate on a mono repo.
