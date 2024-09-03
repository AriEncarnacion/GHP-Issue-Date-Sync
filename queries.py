def get_issues_query(project_node_id, end_cursor=None):
    pagination_filter = f', after: "{end_cursor}"' if end_cursor else ""
    return {
        "query": f"""
        query {{
            node(id: "{project_node_id}") {{
                ... on ProjectV2 {{
                    items(first: 100{pagination_filter}) {{
                        nodes {{
                            id
                            content {{
                                __typename
                                ... on Issue {{
                                    number
                                    title
                                    createdAt
                                }}
                            }}
                        }}
                        pageInfo {{
                            hasNextPage
                            endCursor
                        }}
                    }}
                }}
            }}
        }}
        """
    }


def update_issue_date_query(project_node_id, issue_id, field_node_id, created_at):
    return {
        "query": f"""
        mutation {{
            updateProjectV2ItemFieldValue(
                input: {{
                    projectId: "{project_node_id}"
                    itemId: "{issue_id}"
                    fieldId: "{field_node_id}"
                    value: {{
                        date: "{created_at}"
                    }}
                }}
            ) {{
                projectV2Item {{
                    id
                }}
            }}
        }}
        """
    }
