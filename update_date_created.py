import os
from datetime import datetime

import requests
from dotenv import load_dotenv

from queries import get_issues_query, update_issue_date_query

load_dotenv(".env")

TOKEN = os.getenv("TOKEN")
PROJECT_NODE_ID = os.getenv("PROJECT_NODE_ID")
FIELD_NODE_ID = os.getenv("FIELD_NODE_ID")

graphql_url = "https://api.github.com/graphql"
graphql_headers = {"Authorization": f"Bearer {TOKEN}"}


def update_project_field(issue_id, created_at_date):
    mutation = update_issue_date_query(
        PROJECT_NODE_ID, issue_id, FIELD_NODE_ID, created_at_date
    )
    update_response = requests.post(graphql_url, json=mutation, headers=graphql_headers)
    if update_response.status_code == 200:
        return True
    else:
        print(
            f"Failed to update issue {issue_id}. Status code: {update_response.status_code}"
        )
        return False


def process_issue(item):
    if item["content"]["__typename"] == "Issue":
        issue_id = item["id"]
        created_at = item["content"]["createdAt"]
        created_at_date = datetime.strptime(created_at, "%Y-%m-%dT%H:%M:%SZ").strftime(
            "%Y-%m-%d"
        )

        if update_project_field(issue_id, created_at_date):
            print(
                f'Successfully updated issue #{item["content"]["number"]} with created_at date {created_at_date}'
            )
        else:
            print(
                f'Failed to update issue #{item["content"]["number"]}. Moving to next issue.'
            )


def process_issues():
    has_next_page = True
    end_cursor = None

    while has_next_page:
        query = get_issues_query(PROJECT_NODE_ID, end_cursor)
        response = requests.post(graphql_url, json=query, headers=graphql_headers)

        if response.status_code == 200:
            data = response.json()
            issues = data["data"]["node"]["items"]["nodes"]
            page_info = data["data"]["node"]["items"]["pageInfo"]

            for item in issues:
                process_issue(item)

            has_next_page = page_info["hasNextPage"]
            end_cursor = page_info["endCursor"]
        else:
            print(f"Failed to retrieve issues. Status code: {response.status_code}")
            print(response.json())
            break


if __name__ == "__main__":
    process_issues()
