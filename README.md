# ec2box (UNDER CONSTRUCTION)

There is no cloud. It's just someone else's computer.

<img alt="I am the Architect" src="poster.jpeg" title="It's more fun to compute.">

## abstract

Use [Terraform] to launch [EC2 instances] from [Amazon Web Services].

[Terraform]: https://www.terraform.io/
[EC2 instances]: https://en.wikipedia.org/wiki/Amazon_Elastic_Compute_Cloud
[Amazon Web Services]: https://aws.amazon.com/

## basics

1. Create a new repo [from this template].
1. Open a [terminal] and `cd` to this folder.

- ???

- install Terraform (it's one file)

[from this template]: https://help.github.com/en/github/creating-cloning-and-archiving-repositories/creating-a-repository-from-a-template
[Terminal]: https://en.wikipedia.org/wiki/Command-line_interface

### credentials

Terraform searches for credentials in several places:

1. [hard-coded] (this can be [dangerous])
1. [environment variables]
1. a [credentials file]

[hard-coded]: https://www.terraform.io/docs/providers/aws/index.html#static-credentials
[dangerous]: https://qz.com/674520/companies-are-sharing-their-secret-access-codes-on-github-and-they-may-not-even-know-it/
[environment variables]: https://www.terraform.io/docs/providers/aws/index.html#environment-variables
[credentials file]: https://www.terraform.io/docs/providers/aws/index.html#shared-credentials-file

### state

Terraform stores [state] in two files when it is [initialized]:
```sh
terraform.tfstate
terraform.tfstate.backup
```
Terraform can also store state [remotely] instead of using local files.

**Caution:** State files can contain secrets. Remember to [gitignore] them.

[initialized]: https://www.terraform.io/docs/commands/init.html
[gitignore]: .gitignore
[state]: https://www.terraform.io/docs/backends/state.html
[remotely]: https://www.terraform.io/docs/state/remote.html

## commands

| command           | what does it do?  |
| ----              | ----  |
| `show`            | Show current state (might include secrets!)             |
| `init FOLDER`     | Prepare a [backend], install [plugins], etc.        |
| `plan FOLDER`     | Predict what `apply FOLDER` will do when you run it.    |
| `apply FOLDER`    | Update resources to match contents of `FOLDER/main.tf`. |
| `taint THING`     | Mark `thing` as broken or unsafe. |
| `untaint THING`   | Mark `thing` as OK.  |
| `destroy FOLDER`  | Deactivate every resource declared in `FOLDER`.  |
| `validate FOLDER` | Check all `.tf` files in `FOLDER` for errors. \
| `version`         | Show version for plugins and Terraform itself. |
| `fmt FOLDER`      | Autoformat all `.tf` files in `FOLDER`. |
| `console FOLDER`  | Start interactive console for debugging |
| `output`          | Show all [outputs]. |

[backend]: https://www.terraform.io/docs/backends/
[plugins]: https://www.terraform.io/docs/commands/init.html#plugin-installation
[outputs]: https://learn.hashicorp.com/terraform/getting-started/outputs

## dependencies

1. [Terraform] >= 0.12.19

[Terraform]: https://www.terraform.io/downloads.html

## examples

Example `~/.aws/credentials` file with two profiles, `default` and `gandalf`:
```sh
[default]
aws_access_key_id = CRM114
aws_secret_access_key = POEOPEOEP
[gandalf]
aws_access_key_id = DUR1N
aws_secret_access_key = M3770N
```

Validate `.tf` files in `src/` folder and [autoformat] them in-place:
```sh
> terraform validate src && terraform fmt src
```

Show public IP address of a box:
```sh
> terraform output public_ip
23.555.42.808
```

Time's up. [Let's do this].
```sh
> terraform apply -auto-approve -lock=true production
```

[Let's do this]: https://www.youtube.com/watch?v=jbq5dsQ-l9M

## faq

[AWS Provider]

[AWS examples]

[AWS Provider]: https://www.terraform.io/docs/providers/aws/index.html
[AWS examples]: https://github.com/terraform-providers/terraform-provider-aws/tree/master/examples