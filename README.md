# AWS CloudFormation Starter Playbook

## Introduction

This repository provides a starter template for getting started creating AWS infrastructure using Ansible and CloudFormation.

## Prerequisites

To run this playbook on your local machine, you must install the following prerequisites:

- Ansible 2.4 or higher
- GNU Make 3.82 or higher
- Python PIP package manager
- The following PIP packages:
  - awscli
  - boto3
  - netaddr
  - yq
- jq

You must also configure your local environment with your AWS credentials and you will also need to specify the ARN of the IAM role that your playbook will use to run provisioning tasks.  Your credentials must have permissions to assume this role.

### macOS Environments

On macOS environments, `boto` must be installed as follows:

```bash
$ sudo -H /usr/bin/python -m easy_install pip
...
...
$ sudo -H /usr/bin/python -m pip install boto
...
...
```

## Getting Started

1. Fork this repository to your own new repository
2. Review [`roles/requirements.yml`](./roles/requirements.yml) and modify if required
3. Install roles by running `make roles`
4. Define environments in the [`inventory`](./inventory) file and [`group_vars`](./group_vars) folder or alternatively runing `make environment/<new-environment>`
5. Define a CloudFormation stack name in [`group_vars/all/vars.yml`](./group_vars/all/vars.yml) using the `Stack.Name` variable
6. Add the ARN of the IAM role to assume in each environment by configuring the `Sts.Role` variable in `group_vars/<environment>/vars.yml`
7. Define your CloudFormation template in [`templates/stack.yml.j2`](./templates/stack.yml.j2).  Alternatively you can reference a template included with the `aws-cloudformation` role by setting the `Stack.Template` variable to the path of the template relative to the `aws-cloudformation` role folder (e.g. `Stack.Template: "templates/network.yml.j2"`)
8. Define environment-specific configuration settings as required in `group_vars/<environment>/vars.yml`
9. If you have stack inputs, define them in using the `Stack.Inputs` dictionary in [`group_vars/all/vars.yml`](./group_vars/all/vars.yml).  A common pattern is to then reference environment specific settings for each stack input.
10. Generate your stack templates by running `make generate/<environment>`
11. Deploy your stack by running `make deploy/<environment>`

### Make Commands

The workflow includes various make commands that help simplify day-to-day tasks:

- `make roles` - installs Ansible Galaxy roles
- `make environment/<environment>` - creates a new environment in the [`inventory`](./inventory) file and [`group_vars`](./group_vars) folder
- `make generate/<environment>` - generates templates for the specified environment
- `make deploy/<environment>` - generates and deploys templates for the specified environment

The various make commands also support the following flags:

- `/disable_rollback` - disables stack rollback when creating a stack and a failure occurs
- `/disable_policy` - temporarily disables the configured stack policy for a deployment
- `/debug` - applies the flag `debug=true` to display debug task output defined in the playbook
- `/verbose` - applies the flag `-vvv` to provide verbose Ansible output

You can use any combination of the above flags in combination with the various make commands:

```
# Deploy to dev environment
$ make deploy/dev /disable_rollback /debug
...
...

# Generate templates for qa environment
$ make generate/qa /verbose
...
...
```

## Conventions

- Environment specific settings should always be prefixed with `Stack.Inputs.`, unless you have environment specific settings for variables related to the [`aws-sts`](https://github.com/casecommons/aws-sts) or [`aws-cloudformation`](https://github.com/casecommons/aws-cloudformation) roles as defined below

- Variables related to configuring the [`aws-sts`](https://github.com/casecommons/aws-sts) role are prefixed with `Sts.`

- Variables related to configuring the [`aws-cloudformation`](https://github.com/casecommons/aws-cloudformation) role are prefixed with `Stack.`

## Release Notes

### Version 2.5.0

- **ENHANCEMENT** : Ansible 2.5 support
- **ENHANCEMENT** : Improve make/environment command

### Version 2.4.0

- **ENHANCEMENT** : Ansible 2.4 support

### Version 0.4.0

- **ENHANCEMENT** : Add Make workflow

### Version 0.3.0

- **ENHANCEMENT** : Disables updates to existing cloudformation resources

### Version 0.2.2

- **BUG FIX** : Use templates/stack.yml.j2 cloudformation template by default

### Version 0.2.1

- **ENHANCEMENT** : Move Stack.Template specification after comments related to stack template

### Version 0.2.0

- **NEW FEATURE** : Use stack overrides, a new syntax to override portions of the stack template
- **NEW FEATURE** : Use dot notation syntax for STS configurations

### Version 0.1.0

- First Release

## License

Copyright (C) 2017.  Case Commons, Inc.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.

See www.gnu.org/licenses/agpl.html
