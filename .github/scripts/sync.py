"""
Upload Flink operator Helm chart to OCI registry

Usage:
    python sync.py

Environment variables:
    GITHUB_TOKEN: GitHub token with read/write access to the OCI registry

Requirements:
    requests (pip install requests)
    helm (https://helm.sh/docs/intro/install/)
"""

import base64
import os
import re
import subprocess
import sys

import requests

ARCHIVE_URL = "https://archive.apache.org/dist/flink/"

GIT_REPO = "trifork/cheetah-charts"
IMAGE = "flink-kubernetes-operator"


def get_existing_versions() -> list[str]:
    """Get existing versions"""
    token = os.getenv("GITHUB_TOKEN")
    if token is None:
        print("GITHUB_TOKEN is not set")
        sys.exit(1)

    b64_token_bytes = base64.b64encode(token.encode("ascii"))
    headers = {"Authorization": f"Bearer {b64_token_bytes.decode('ascii')}"}
    resp = requests.get(
        f"https://ghcr.io/v2/{GIT_REPO}/{IMAGE}/tags/list",
        timeout=10,
        headers=headers,
    )

    result = resp.json()
    if "tags" not in result:
        return []

    return result["tags"]


def download_chart(url: str, file: str):
    """Download Helm chart"""
    resp = requests.get(url, timeout=10)
    try:
        resp.raise_for_status()
    except requests.exceptions.HTTPError as err:
        print(f"Error collecting tar ball from {url}: {err}")
        sys.exit(1)

    with open(file, "wb") as f:
        f.write(resp.content)


def helm_login():
    """Login to the Helm registry"""
    token = os.getenv("GITHUB_TOKEN")
    if token is None:
        print("GITHUB_TOKEN is not set")
        sys.exit(1)

    cmd = [
        "helm",
        "registry",
        "login",
        f"ghcr.io/{GIT_REPO}",
        "--username",
        "github-actions",
        "--password-stdin",
    ]
    try:
        subprocess.run(cmd, input=token.encode("ascii"), check=True, timeout=10)
    except subprocess.CalledProcessError as err:
        print(f"Error logging into the Helm registry: {err}")
        sys.exit(1)


def helm_push(chart: str):
    """Push the Helm chart"""
    cmd = ["helm", "push", chart, f"oci://ghcr.io/{GIT_REPO}"]
    try:
        subprocess.run(cmd, check=True, timeout=10)
    except subprocess.CalledProcessError as err:
        print(f"Error pushing Helm chart: {err}")
        sys.exit(1)


def main():
    """Main function"""
    print("Logging into the Helm registry")
    helm_login()

    print("Getting existing operator versions")
    existing_versions = get_existing_versions()
    print(f"Found existing versions: {existing_versions}")

    print(f"Collecting operator versions from {ARCHIVE_URL}")
    resp = requests.get(ARCHIVE_URL, timeout=10)
    try:
        resp.raise_for_status()
    except requests.exceptions.HTTPError as err:
        print(f"Error collecting Kubernetes operator versions: {err}")
        sys.exit(1)

    pattern = re.compile(
        r"<a href=\"flink-kubernetes-operator-(?P<version>\d+\.\d+\.\d+)/\">"
    )
    for result in pattern.finditer(resp.text):
        version = result.group("version")
        print(f"Found version {version}")

        if version in existing_versions:
            print(f"Version {version} already exists")
            continue

        tar_url = f"{ARCHIVE_URL}flink-kubernetes-operator-{version}/flink-kubernetes-operator-{version}-helm.tgz"
        chart = f"{IMAGE}-{version}.tgz"

        print(f"Downloading chart from {tar_url}")
        download_chart(url=tar_url, file=chart)

        print(f"Pushing chart {chart}")
        helm_push(chart)

        print(f"Cleaning up {chart}")
        os.remove(chart)


if __name__ == "__main__":
    main()
