#!/usr/bin/env bash

if [[ $1 == "--config" ]] ; then
  cat <<EOF
    configVersion: v1
    kubernetes:
    - name: ns
      apiVersion: v1
      kind: Namespace
      executeHookOnEvent: ["Added"]
      group: "main"
      jqFilter: '{"nsname": .metadata.name}'
EOF
else
  namespaces=$(jq -r '.[].snapshots.ns[] | select(.filterResult.nsname|test("review.")) | .filterResult.nsname' $BINDING_CONTEXT_PATH)
  for nsname in $namespaces; do
    kubectl label ns $nsname boss="welcome_to_the_club_buddy"
  done
fi
