#!/usr/bin/env bash

REGIONS=(us-east-1 us-east-2 us-west-1 us-west-2 ap-south-1 ap-northeast-2 ap-southeast-1 ap-southeast-2 ap-northeast-1 eu-central-1 eu-west-1 eu-west-2 eu-west-3 eu-north-1 sa-east-1 ca-central-1 me-south-1 ap-east-1 af-south-1 eu-south-1 ap-northeast-3)

function isRegionEnabled()
{
  local region="$1"
  if aws sts get-caller-identity --region "$region" --endpoint-url "https://sts.$region.amazonaws.com" >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

echo "Listing lambda functions in a specific region using Node.js 12..."
for region in "${REGIONS[@]}"; do
  if isRegionEnabled "$region"; then
    lambdaFunctions="$(aws lambda list-functions --function-version ALL --region "$region" --output text --query "Functions[?Runtime=='nodejs12.x'].FunctionArn")"
    if [ ! -z "$lambdaFunctions" ]
    then
      for lambda in ${lambdaFunctions[@]}; do
        echo $lambda
      done
    fi
  fi
done
