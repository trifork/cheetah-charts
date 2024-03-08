#!/bin/bash

# Script, which fetches the helm releases from the cluster and 
# lints them against the values.schema.json
# The script assumes the charts are under the 'charts' directory in the root of this repo
# The script takes 2 params:
# <dir-of-json-schema> - directory where the values.schema.json is. e.g., 'flink-job'
# <max-charts-to-lint> - set an upper limit for the number of charts to lint.
#
# Example usage ./lintchart.sh flink-job 20

if [ $# -ne 2 ]; then
    echo "The script takes 2 parameters <dir-of-json-schema> <max-charts-to-lint>"
    echo "Example params: flink-job 20"
fi
    
CHART="$1"
CHART_DIR="charts/${CHART}"
MAX_CHARTS="$2"

echo "Linting charts in directory ${CHART_DIR} for chart ${CHART}. Will stop after linting at most ${MAX_CHARTS}."

TMP_CUR_DIR=$(pwd)
cd ${CHART_DIR}

kubectl get helmreleases.helm.toolkit.fluxcd.io --all-namespaces -o yaml |
yq eval ".items | map(select(.spec.chart.spec.chart == \"${CHART}\")) | .[].spec.values | split_doc" > temp_lint_deleteme.tmp
for i in `seq 0 ${MAX_CHARTS}` ; do
    yq "select(di == ${i})" temp_lint_deleteme.tmp | yq 'load("values.yaml") *= .' > "${i}.tmp" ;
done

for i in `seq 0 ${MAX_CHARTS}` ; do
    if [ `cat "${i}.tmp" | wc -l` -gt 1 ] ;
        then helm lint . --values "${i}.tmp" ;
    fi ;
done

for i in `seq 0 ${MAX_CHARTS}` ; do rm "${i}.tmp" ; done
rm temp_lint_deleteme.tmp

cd $TMP_CUR_DIR
