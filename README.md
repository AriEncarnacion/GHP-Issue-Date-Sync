# GHP Issue Date Sync

**GHP Issue Date Sync** is a tool that allows you to automatically update a custom "Date Created" field in your GitHub Projects with the `created_at` date of each issue. This helps in tracking the age of issues within your project, making project management by date easeir.

## How it Works

1. Pulls all issues from a specified GitHub Project.
2. Updates a custom "Date Created" field in the project with each issue's `created_at` date.

## Prerequisites

### 1. Create a `.env` File

At the root of the project, create a `.env` file and add the following environment variables:

```env
TOKEN=
GITHUB_ORG=
PROJECT_TITLE=
FIELD_NAME=
FIELD_NODE_ID=
PROJECT_NODE_ID=
```

### 2. Obtain a GitHub Personal Access Token

Before starting, you’ll need to create a GitHub Personal Access Token (PAT). Follow these steps:

1. Go to your GitHub account settings.
2. Navigate to Developer settings > Personal access tokens > Tokens (classic).
3. Click Generate new token.
4. Give the token a descriptive name.
5. Under Select scopes, ensure you select the following scopes:

   a. `repo:` Full control of private repositories (required to access issues).

   b. `read:org:` Read-only access to organization details.

   c. `project:` Full control of projects, including project boards.

6. Click Generate token and copy it immediately, as GitHub will only show it to you once.

Once you have the token, add it to your `.env` file as the `TOKEN` value.

## Setup Instructions

### 1. Add a "Date Created" Field in Your GitHub Project

In your GitHub Project, create a new field named `Date Created`. This is where the script will store the `created_at` date for each issue.

_Note: The field can be named whatever you want. Just update the `FIELD_NAME` in the `.env` accordingly._

### 2. Configure the `.env` File

Fill in the `.env` file with the following values:

- `TOKEN`: Your GitHub Personal Access Token.
- `GITHUB_ORG`: The name of your GitHub organization.
- `PROJECT_TITLE`: The title of your GitHub Project.
- `FIELD_NAME`: The name of the new Date Created field.

### 3. Retrieve Node IDs

Run the `get_node_ids.sh` script to retrieve the Node IDs for both the project and the Date Created field:

```bash
sh get_node_ids.sh
```

This will output the `PROJECT_NODE_ID` and `FIELD_NODE_ID`.

Example output:

```
Project Node ID: XXX_xxXXxxxxxx1XXx_X
'Date Created' Field Node ID: XXX_xxXXXxxxxx1Xx_X
```

### 4. Update the `.env` File with Node IDs

Update your `.env` file with the `PROJECT_NODE_ID` and `FIELD_NODE_ID` obtained from the previous step.

### 5. Run the Update Script

Finally, run the `update_date_created.py` script.

```bash
python3 update_date_created.py
```

_Note: Depending on how many issues exist in your repo, this may take a while._

## Contributions

Contributions are encouraged. I've barely used GraphQL, so optimizations are likely possible.
