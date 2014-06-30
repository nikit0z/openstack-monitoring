#!/bin/bash

get_catalog(){
    CATALOG=$(curl -is -H 'Content-type: application/json' -X 'POST' ${OS_AUTH_URL}/auth/tokens -d '{
      "auth": {
        "scope": {
          "project": {
            "name": "'${OS_PROJECT_NAME}'",
            "domain": {
              "name": "'${OS_DOMAIN_NAME}'"
            }
          }
        },
        "identity": {
          "methods": [
            "password"
          ],
          "password": {
            "user": {
              "domain": {
                "name": "'Default'"
              },
              "name": "'${OS_USERNAME}'",
              "password": "'${OS_PASSWORD}'"
            }
          }
        }
      }
    }')
}

get_token(){
    TOKEN=$(echo "$CATALOG" |  awk '/X-Subject-Token/ {print $2}')
}

get_project_id(){
    PROJECT_ID=$(echo "$CATALOG" | tail -n +9 | python -c 'import sys; import json; data = json.loads(sys.stdin.readline()); print data["token"]["project"]["id"]')
}
