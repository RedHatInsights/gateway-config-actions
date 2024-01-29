#!/bin/sh -l

WORKSPACE=/github/workspace
CONFIGMAPS_TARGET=${WORKSPACE}/_private/configmaps
ROUTES_DIR=${WORKSPACE}/_private/configs

if [ -z "${INPUT_TOKEN}" ]; then
    echo "error: no INPUT_TOKEN supplied"
    exit 1
fi

if [ -z "${INPUT_BRANCH_NAME}" ]; then
   export INPUT_BRANCH_NAME=configmaps
fi

git config --global --add safe.directory ${WORKSPACE}
git config http.sslVerify false
git config user.name "[GitHub] - Automated Action"
git config user.email "actions@github.com"

# Remove configmaps branch from remote if it already exists.
if [ "${INPUT_BRANCH_NAME}" != "main" ] || [  "${INPUT_BRANCH_NAME}" != "master" ]; then
  if git ls-remote --exit-code --heads origin "${INPUT_BRANCH_NAME}" >/dev/null 2>&1; then
    git push origin --delete "${INPUT_BRANCH_NAME}"
  fi
fi

# sync the input branch
git fetch
git checkout -b "${INPUT_BRANCH_NAME}" --no-track origin/master

indent() { sed '2,$s/^/  /'; }

for ENV in stage prod dev ocm
do
  mkdir -p $CONFIGMAPS_TARGET/${ENV}

  ROUTES_CONFIG=${ROUTES_DIR}/${ENV}/routes.json
  ROUTES_CONFIGMAP_FILE=${CONFIGMAPS_TARGET}/${ENV}/routes.configmap.json

  # create templates
  echo -n 'kind: Template
apiVersion: v1
objects:
- ' > $ROUTES_CONFIGMAP_FILE

  # create configmaps
  kubectl create configmap backend-routes --from-file $ROUTES_CONFIG --dry-run=client --validate=false -o json | indent >> $ROUTES_CONFIGMAP_FILE

  # add annotations
  echo '    annotations:
      qontract.recycle: "true"' >> $ROUTES_CONFIGMAP_FILE
done

# remove the routes config directory
rm -rf $ROUTES_DIR

# push the changes
git add .
timestamp=$(date -u)
git commit -m "[GitHub] - Automated ConfigMap Generation: ${timestamp} - ${GITHUB_SHA}" || exit 0
git push origin ${INPUT_BRANCH_NAME}
