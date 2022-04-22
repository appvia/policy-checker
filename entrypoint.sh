#!/usr/bin/env bash
set -e

RUN_CHECKOV_POLICIES=${RUN_CHECKOV_POLICIES:-false}
RUN_KYVERNO_POLICIES=${RUN_KYVERNO_POLICIES:-false}
POLICY_REPO_DIR="${POLICY_REPO_DIR:-/tmp/policy}"

# Arg 1: json content, Arg 2: key
function jq_fetch () {
    jq -r "if has (\"$2\") then .$2 else error(\"Missing Key: $2\") end" <<< $1
}

if $RUN_CHECKOV_POLICIES ; then
    echo "Locating policy-checker variables within policy_checker.json file..."
    POLICY_CHECKER_VARIABLES=`cat policy_checker.json`
    POLICY_SOURCE=$(jq_fetch "${POLICY_CHECKER_VARIABLES}" "source")
    POLICY_VERSION=$(jq_fetch "${POLICY_CHECKER_VARIABLES}" "version")
    POLICY_CONFIG=$(jq_fetch "${POLICY_CHECKER_VARIABLES}" "config")
    echo "Policy Package: ${POLICY_SOURCE}:${POLICY_VERSION}"

    echo "Fetching Policies..."
    git -c advice.detachedHead=false clone --quiet --depth 1 --branch ${POLICY_VERSION} ${POLICY_SOURCE} ${POLICY_REPO_DIR}
    echo "Policies fetched."

    echo "Running checkov policies..."
    checkov \
        --config-file ${POLICY_REPO_DIR}/${POLICY_CONFIG} \
        --download-external-modules true \
        --directory .
else
    echo "Skipping Checkov tests.. Set 'RUN_CHECKOV_POLICIES' to true to execute these."
fi

if $RUN_KYVERNO_POLICIES ; then
    echo "Skipping Kyverno tests.. Not currently implemented."
fi
