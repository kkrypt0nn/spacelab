# Contributing Guidelines

Your input is amazing! Making contributing to this project as easy and transparent as possible is one of the most
important side, this includes:

- Reporting a bug
- Discussing the current state of the tools
- Submitting a fix
- Proposing new tools
- Becoming a maintainer

## How to add a new tool?

First you will need to either add the tool as Ubuntu package or GitHub repository, prefer Ubuntu package.

### Update the [`Dockerfile`](./Dockerfile) file

Add the version as argument as `ARG <TOOL_NAME>_VERSION="<VERSION>"` and implement its download and installation, either from source or in the `apt install` command

Then add a comment with the proper name and link to the tool as well as a comment for the Renovate source.

#### GitHub Repository Example

```Dockerfile
# binwalk
# https://github.com/ReFirmLabs/binwalk
# renovate: datasource=github-tags depName=ReFirmLabs/binwalk
ARG BINWALK_VERSION="3.1.0"
```

#### Ubuntu Package Example

```Dockerfile
# dcfldd
# https://packages.ubuntu.com/resolute/dcfldd
# renovate: datasource=deb depName=dcfldd
ARG DCFLDD_VERSION="1.9.3-2"
```

### Update the [`README.md`](./README.md) file

Similarly to the [`Dockerfile`](./Dockerfile), the [`README.md`](./README.md) file gets updated when a tools gets a new version, therefore you will need to add the Renovate source as well. For example:

```md
- [`binwalk`](https://github.com/refirmlabs/binwalk) - Version `3.1.0` <!-- renovate: datasource=github-tags depName=ReFirmLabs/binwalk -->
```

or

```md
- [`dcfldd`](https://dcfldd.sourceforge.net/) - Version `1.9.3-2` <!-- renovate: datasource=deb depName=dcfldd -->
```

Make sure to put the tool in the right category as well.

### Update the [`labels.yaml`](./.github/labels.yaml) and [`renovate.json`](./.github/renovate.json) files

Add a label for the tool in the [`labels.yaml`](./.github/labels.yaml) file, and give it a random color. For example:

```yaml
- name: "tool/binwalk"
  color: "#A3E4D7"
  description: "Affecting Binwalk"
```

Then make Renovate assign this label for when the package in question gets updated by editing [`renovate.json`](./.github/renovate.json). For example:

```json
{
  "description": "Label Binwalk updates",
  "matchPackageNames": ["ReFirmLabs/binwalk"],
  "addLabels": ["tool/binwalk"]
}
```

## All code changes happen through pull requests

Pull requests are the best way to propose changes to the codebase. We actively welcome your pull requests:

1. Fork the repo and create your branch from `main`
2. Keep consistency with the current state of the codebase
3. Format the code of the files properly
4. Issue that pull request!

## Commit messages guidelines

This project uses [`Conventional Commits 1.0.0`](https://conventionalcommits.org/en/v1.0.0/) hence your commit messages **must** follow the same convention or your contributions will be ignored, refused or assigned to another user or maintainer.

It would be more than welcome to keep your contributions as a single commit rather than, for examples, 20 `"feat: fix tool <name>"` commits in-between. You may use multiple commmits if you believe the changes made in these commmits have nothing, or close to nothing, in common - feel free to ask a maintainer on whether or not it should be a single commit or not.
