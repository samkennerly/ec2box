# ec2box (UNDER CONSTRUCTION)

The cloud is just someone else's computer.

![The clouds would catch the colors.](ec2box.jpeg)

## abstract

Use [Terraform] to launch [EC2 instances] from [Amazon Web Services].

[Terraform]: https://www.terraform.io/
[EC2 instances]: https://en.wikipedia.org/wiki/Amazon_Elastic_Compute_Cloud
[Amazon Web Services]: https://aws.amazon.com/

## basics

1. [Clone] this repo or [use it as a template].
1. Open a [terminal] and `cd` to this folder.
1. UNDER CONSTRUCTION

- install Terraform (it's one file)
- Terraform searches for AWS credentials in [env vars] or a [file] like `~/.aws/credentials`

[env vars]: https://www.terraform.io/docs/providers/aws/index.html#environment-variables
[file]: https://www.terraform.io/docs/providers/aws/index.html#shared-credentials-file


[Clone]: https://help.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository
[use it as a template]: https://help.github.com/en/github/creating-cloning-and-archiving-repositories/creating-a-repository-from-a-template
[Terminal]: https://en.wikipedia.org/wiki/Command-line_interface

## commands

| command                 | what does it do?  |
| ----                    | ----  |
| `show`                  | Show current state (might include secrets!) |
| `init FOLDER`           |       |
| `plan FOLDER`           | Show what `apply FOLDER` intends to do. Don't do it. |
| `apply FOLDER`          | Update resources to match contents of `FOLDER/main.tf`.  |
| `taint THING`           | Mark `thing` as ??? |
| `untaint THING`         | Mark `thing` as OK.  |
| `destroy FOLDER`        | Deactivate every resource declared in `FOLDER`.  |
| `validate FOLDER`       | Check all `.tf` files in `FOLDER` for errors. \
| `version`               | Show version for plugins and Terraform itself. |
| `fmt FOLDER`            | Autoformat all `.tf` files in `FOLDER`. |
| `console FOLDER`        | Start interactive console for debugging |

## dependencies
## examples
## faq


[AWS Provider]

[AWS examples]

[AWS Provider]: https://www.terraform.io/docs/providers/aws/index.html
[AWS examples]: https://github.com/terraform-providers/terraform-provider-aws/tree/master/examples