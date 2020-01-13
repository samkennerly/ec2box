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

[Clone]: https://help.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository
[use it as a template]: https://help.github.com/en/github/creating-cloning-and-archiving-repositories/creating-a-repository-from-a-template
[Terminal]: https://en.wikipedia.org/wiki/Command-line_interface

## commands

| command                 | what does it do?  |
| ----                    | ----  |
| `init FOLDER`           |       |
| `plan FOLDER`           | Show what `apply FOLDER` intends to do. Don't do it. |
| `apply FOLDER`          | Update infrastructure to match `FOLDER/main.tf`.  |
| `taint THING`           | Mark `thing` as ??? |
| `untaint THING`         | Mark `thing` as OK.  |
| `destroy THING`         | Deactivate `thing`.  |
| `version`               | Show version for plugins and Terraform itself. |
| `fmt FOLDER`            | Autoformat all `.tf` files in `FOLDER`. |

## dependencies
## examples
## faq


[AWS Provider]

[AWS examples]

[AWS Provider]: https://www.terraform.io/docs/providers/aws/index.html
[AWS examples]: https://github.com/terraform-providers/terraform-provider-aws/tree/master/examples