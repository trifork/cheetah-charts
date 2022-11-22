import argparse
import requests
import sys


# GH API docs https://docs.github.com/en/rest/releases/releases#list-releases

def fetch_releases(token):
    """query the GitHub API and fetch the data for all releases
    This function also does some minor data wrangling for the:
    - date: remove timezone and seconds
    """
    # repository url used in the API
    repo_url = f'https://api.github.com/repos/KastTrifork/cheetah-charts-test/releases'

    # headers used to make requests to GitHub's API
    # the important part is the access token, because we're working with private repos
    request_headers = {
        'Accept': 'application/vnd.github+json',
        'Authorization': f'Bearer {token}',
    }

    # request parameters for the body of the request to GitHub's API
    # we update the page in a loop
    request_params = {
        'per_page': 100, # default: 30, max: 100
        'page': 0, # page counting starts from 1, but we increment this in the loop
    }

    result = []
    while True:
        request_params['page'] += 1
        response = requests.get(url=repo_url, headers=request_headers, params=request_params).json()

        if not isinstance(response, list):
            # The API should return a list of items for a successful request
            # If it's an object, it's an error object and the workflow should fail
            sys.stderr.write(f'Error fetching releases from git for repo {repo_url}: {response}')
            exit(1)

        if len(response) == 0:
            # We get empty list as a response if the page we're on is empty (no more results)
            break

        for x in response:
            result.append({
                'name': x['name'],
            })
    return result

def parse_args():
    """Parse the command line args"""
    argparser = argparse.ArgumentParser(description='Find the latest release of the chart')
    argparser.add_argument(
        '--name',
        '--version',
        dest='name',
        dest='version',      
        help='The name of the chart to search for',
    )
    return argparser.parse_args()

if __name__ == '__main__':
    args = parse_args()
    name = args.name
    version = args.version
    # github token, used to access github's api
    token = "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"

    releases = fetch_releases(token)
    for x in releases:
        if x["name"] == name
             print("true")
        else:
            None

