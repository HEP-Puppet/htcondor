import json
import os
import re
from collections import OrderedDict

def update_metadata_json(release):
    input_file = 'metadata.json'
    with open(input_file) as f:
        content = json.load(f, object_pairs_hook=OrderedDict)

    content['version'] = release
    with open(input_file, 'w+') as f:
        json.dump(content, f, indent=2, separators=(',', ': '))


def update_readme(release):
    input_file = 'README.md'
    with open(input_file) as f:
        content = f.readlines()

    pattern = "v(\d+\.)?(\d+\.)?(\*|\d+)$"
    for i, line in enumerate(content):
        if 'Latest stable version' in line:
            line = re.sub(pattern, 'v' + release, line)
            content[i] = line
            break

    content = ''.join(content)
    with open('README.md', 'w+') as f:
        f.write(content)


def update_changelog(release):
    input_file = 'CHANGELOG.md'
    with open(input_file) as f:
        content = f.read()
    content = content.replace('Unreleased', 'v' + release)
    content = content.replace('HEAD', 'v' + release)
    with open(input_file, 'w+') as f:
        f.write(content)

if __name__ == '__main__':
    release = os.environ.get('RELEASE', 'unreleased')
    update_metadata_json(release)
    update_readme(release)
    update_changelog(release)
