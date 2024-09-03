#!/bin/bash

# Function to handle errors and exit
handle_error() {
    echo "Error: $1"
    exit 1
}

IFS= read -r -p "Enter your GitHub Personal Access Token: " TOKEN
IFS= read -r -p "Enter your GitHub Organization: " GITHUB_ORG
IFS= read -r -p "Enter your Project Title: " PROJECT_TITLE
IFS= read -r -p "Enter the Date Created Field Name: " FIELD_NAME

# Create the .env file
cat <<EOF > .env
# Global config items
TOKEN="$TOKEN"
GITHUB_ORG="$GITHUB_ORG"

# Config for running shell script
PROJECT_TITLE="$PROJECT_TITLE"
FIELD_NAME="$FIELD_NAME"

# Config for running python script
FIELD_NODE_ID=""
PROJECT_NODE_ID=""
EOF

source .env || handle_error "Failed to source .env file."

# Retrieve the Project Node ID
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
  }") || handle_error "Failed to retrieve project information."

project_id=$(echo $project_response | jq -r --arg title "$PROJECT_TITLE" '.data.organization.projectsV2.nodes[] | select(.title == $title) | .id')
[ -z "$project_id" ] && handle_error "Project ID not found. Please check your Project Title."

# Retrieve the Field Node ID
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
  }") || handle_error "Failed to retrieve field information."

field_id=$(echo $field_response | jq -r --arg field_name "$FIELD_NAME" '.data.node.fields.nodes[] | select(.name == $field_name) | .id')
[ -z "$field_id" ] && handle_error "Field ID not found. Please check your Field Name."

# Update the .env file with the retrieved Node IDs
sed -i '' "s/^FIELD_NODE_ID=.*/FIELD_NODE_ID=\"$field_id\"/" .env || handle_error "Failed to update FIELD_NODE_ID in .env file."
sed -i '' "s/^PROJECT_NODE_ID=.*/PROJECT_NODE_ID=\"$project_id\"/" .env || handle_error "Failed to update PROJECT_NODE_ID in .env file."

# Display the final .env file if everything succeeds
echo ""
echo "The .env file has been updated with the necessary Node IDs:"
echo "---------------------------------------------------------"
cat .env
echo "---------------------------------------------------------"