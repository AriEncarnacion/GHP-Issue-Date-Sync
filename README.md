# GHP Issue Date Sync

Currently, GitHub Project users can't sort or filter Issues in GitHub Projects based on the `created_at` field. This makes management based on time difficult. This feature is [being tracked by the GitHub team](https://github.com/orgs/community/discussions/8518) but has not been resolved.

**GHP Issue Date Sync** provides a workaround by automating updates to a custom `Date Created` field in your GitHub Project.

## How it Works

1. Pulls all issues from a specified GitHub Project.
2. Updates a custom `Date Created` field in the project with each issue's `created_at` date.

## Prerequisites

### 1. Obtain a GitHub Personal Access Token

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
7. Save this token as you will need it during setup.

### 2. Add a "Date Created" Field in Your GitHub Project

In your GitHub Project, create a new field named `Date Created`. This is where the script will store the `created_at` date for each issue.

_Note: The field can be named whatever you want. Just update the `FIELD_NAME` in the `.env` accordingly._

## How to Use

### 1. Run setup.sh

Run the `setup.sh` script and follow the instructions to fill out your `.env` file

```bash
sh setup.sh
```

### 2. Run the Update Script

Finally, run the `update_date_created.py` script.

```bash
python3 update_date_created.py
```

_Note: Depending on how many issues exist in your repo, this may take a while._

## Future Work

1. Change script to accomplish process in 1 step instead of 2
2. Update script to optionally create the "Date Created" field automatically
3. Enhance script to work with projects

## Contributions

Contributions are encouraged. I've barely used GraphQL, so optimizations are likely possible.
