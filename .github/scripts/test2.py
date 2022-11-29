import argparse
import requests
import sys
import yaml
import argparse
import os
import requests
from pathlib import Path


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
        'per_page': 100,  # default: 30, max: 100
        'page': 0,  # page counting starts from 1, but we increment this in the loop
    }

    releases = []
    prereleases = []
    while True:
        request_params['page'] += 1
        response = requests.get(
            url=repo_url, headers=request_headers, params=request_params).json()

        if not isinstance(response, list):
            # The API should return a list of items for a successful request
            # If it's an object, it's an error object and the workflow should fail
            sys.stderr.write(
                f'Error fetching releases from git for repo {repo_url}: {response}')
            exit(1)

        if len(response) == 0:
            # We get empty list as a response if the page we're on is empty (no more results)
            break

        for x in response:
            if x['prerelease'] == True:
                prereleases.append({
                    'name': x['name'],
                })
            elif x['prerelease'] == False:
                releases.append({
                    'name': x['name'],
                })
            
    return releases, prereleases


def read_repos_from_config():
    CONFIG_FILE_NAME = 'config/applications-that-needs-releases.yaml'

    pwd = os.path.dirname(os.path.realpath(__file__))
    project_root = Path(pwd).parent.parent.absolute()

    with open(project_root.joinpath(CONFIG_FILE_NAME), 'r') as config_file:
        config = yaml.load(config_file, yaml.SafeLoader)
        return config


def parse_args():
    """Parse the command line args"""
    argparser = argparse.ArgumentParser(
        description='Find the latest release of the chart')

    argparser.add_argument(
        '--token',
        dest='token',
        help='The GitHub token to for the GitHub API ',
    )

    argparser.add_argument(
        '--branch',
        dest='branch',
        help='The working branch ',
    )
    return argparser.parse_args()


def getLatestVersion(name):
    CONFIG_FILE_NAME = f'charts/{name}/Chart.yaml'

    pwd = os.path.dirname(os.path.realpath(__file__))
    project_root = Path(pwd).parent.parent.absolute()

    with open(project_root.joinpath(CONFIG_FILE_NAME), 'r') as config_file:
        config = yaml.load(config_file, yaml.SafeLoader)
        return config["version"]

if __name__ == '__main__':
    args = parse_args()
    token = args.token
    branch = args.branch
    
    # github token, used to access github's api
    applications = read_repos_from_config()


    token = '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'

    releases, prereleases = fetch_releases(token)
    none = True
    for app in applications["applications"]:
        version = getLatestVersion(app)
        if  branch == "main":
            for release in releases:
                if release["name"] == app+"-V"+version:
                    print("true")
                    
        elif  branch != "main":
           for prerelease in prereleases:
                if prerelease["name"] == app+"-V"+version+"-preRelease":
                    print("true")
                    
 
        
        
    