#!/bin/bash
# Script to publish modules

set -e

BASEDIR=$(dirname "$0")

ocular-bootstrap
ocular-test
ocular-test dist

# beta or prod
MODE=$1

if [ -d "modules" ]; then
  case $MODE in
    "beta")
      # npm-tag argument: npm publish --tag <beta>
      # cd-version argument: increase <prerelease> version
      lerna publish --npm-tag beta --cd-version prerelease
      ;;

    "prod")
      lerna publish --cd-version patch
      ;;

    *)
      echo -e "\033[91mUnknown publish mode. ocular-publish ['prod' | 'beta']\033[0m"
      exit 1;;
  esac
else
  case $MODE in
    "beta")
      npm version prerelease
      npm publish --tag beta
      break;;

    "prod")
      npm version patch
      npm publish
      break;;

    *)
      echo -e "\033[91mUnknown publish mode. ocular-publish ['prod' | 'beta']\033[0m"
      exit 1;;
  esac
fi
