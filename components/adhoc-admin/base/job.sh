#!/bin/bash
set -x

ADHOC_SCRIPT=${ADHOC_SCRIPT:-/scripts/custom/job.sh}

run_adhoc(){
  if [ -e "${ADHOC_SCRIPT}" ]; then
    "${ADHOC_SCRIPT}"
  else
    echo "missing: ${ADHOC_SCRIPT}"
    echo "You are probably using this wrong"
    return 1
  fi
}

run_adhoc
