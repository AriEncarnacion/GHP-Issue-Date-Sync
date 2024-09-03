#!/bin/bash

source .env

project_response=$(gh api graphql -f query="
  query {
    organization(login: \"${GITHUB_ORG}\") {
      projectsV2(first: 100) {
        nodes {
          id
          title
        }
      }
    }
  }")

project_id=$(echo $project_response | jq -r --arg title "$PROJECT_TITLE" '.data.organization.projectsV2.nodes[] | select(.title == $title) | .id')

echo "Project Node ID: $project_id"

field_response=$(gh api graphql -f query="
  query {
    node(id: \"${project_id}\") {
      ... on ProjectV2 {
        fields(first: 100) {
          nodes {
            ... on ProjectV2Field {
              id
              name
            }
            ... on ProjectV2IterationField {
              id
              name
            }
            ... on ProjectV2SingleSelectField {
              id
              name
            }
          }
        }
      }
    }
  }")

field_id=$(echo $field_response | jq -r --arg field_name "$FIELD_NAME" '.data.node.fields.nodes[] | select(.name == $field_name) | .id')

echo "'$FIELD_NAME' Field Node ID: $field_id"