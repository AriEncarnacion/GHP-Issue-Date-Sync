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

PROJECT_NODE_ID=$(echo $project_response | jq -r --arg title "$PROJECT_TITLE" '.data.organization.projectsV2.nodes[] | select(.title == $title) | .id')

echo "Project Node ID: $PROJECT_NODE_ID"

field_response=$(gh api graphql -f query="
  query {
    node(id: \"${PROJECT_NODE_ID}\") {
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

FIELD_NODE_ID=$(echo $field_response | jq -r --arg field_name "$FIELD_NAME" '.data.node.fields.nodes[] | select(.name == $field_name) | .id')

echo "Field Node ID for Field Name '$FIELD_NAME': $FIELD_NODE_ID"