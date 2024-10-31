YAML_PATH=".github/toc.yml"
cat $YAML_PATH

# Correct the query for checking if v0.9.0 exists under cheetah-application
result=$(yq '.[] | select(has("cheetah-application")) | .["cheetah-application"].items[] | select(.name == "v0.9.0") | .name' "$YAML_PATH")

if [ -z "$result" ]; then
    # Insert v0.9.0 into the items list of cheetah-application, maintaining the correct structure
    yq eval '
      .[] |= (
        select(has("cheetah-application")) |
        .["cheetah-application"].items |= [{"name": "v0.9.0", "href": "charts/cheetah-application/v0.9.0/README.md"}] + .
      )
    ' -i "$YAML_PATH"
    echo "Version v0.9.0 added"
else
    echo "Version v0.9.0 found, skipping"
fi

echo "Result: $result"