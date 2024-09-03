import os

import requests
from dotenv import load_dotenv

load_dotenv(".env.local")

GITHUB_ORG = os.getenv("GITHUB_ORG")
REPO_NAME = os.getenv("REPO_NAME")
TOKEN = os.getenv("TOKEN")

url = f"https://api.github.com/repos/{GITHUB_ORG}/{REPO_NAME}/issues"

headers = {
    "Accept": "application/vnd.github+json",
    "Authorization": f"Bearer {TOKEN}",
    "X-GitHub-Api-Version": "2022-11-28",
}

response = requests.get(url, headers=headers)

if response.status_code == 200:
    issues = response.json()
    for issue in issues:
        print(f"Issue #{issue['number']}: {issue['title']}")
        print(f"Created at: {issue['created_at']}")
        print(f"URL: {issue['html_url']}")
        print("---")
else:
    print(f"Failed to retrieve issues. Status code: {response.status_code}")
    print(response.json())
