# ec2box (UNDER CONSTRUCTION)

There is no cloud. It's just someone else's computer.

<img
  alt="I am the Architect."
  src="https://raw.githubusercontent.com/samkennerly/posters/master/ec2box.jpeg"
  title="It's more fun to compute.">

## abstract

An <dfn>ec2box</dfn> is an [AWS EC2 instance] equipped with its own:

- [keypair] to enable [remote SSH login] to the box
- [security group] to control network access to/from the box
- [CloudWatch log group] to save and display log messages from the box
- [IAM role], [policy], and [profile] to allow the box to use other AWS resources
- [cloud-init] script to install software, run a launch script, and send log messages

The `test` module launches example [free-tier] boxes.

[AWS EC2 instance]: https://aws.amazon.com/ec2/

## basics

1. Install [dependencies](#dependencies).
1. Create a new repo [from this template].
1. Open a [terminal] and `cd` to this folder.
1. Run `bin/keygen` to generate an [RSA keypair].
1. Run `bin/up test` to provision test resources.
1. Run `bin/down test` to remove all test resources.

### boxes

The [test](test) module includes example boxes.
Each box runs a small example script:

| name | language | what does it do? |
| ---- | -------- | ---------------- |
| leeroy | bash | print a message to [STDOUT] |
| dorothy | ruby | print messages to [STDOUT] in an [infinite loop] |



- `leeroy` runs a [bash] script which prints a single message to [STDOUT].
- `dorothy` runs a [Ruby] script which prints messages to STDOUT [indefinitely].


### credentials

### state files





Terraform stores [state] in two files when it is [initialized]:
```sh
terraform.tfstate
terraform.tfstate.backup
```
Terraform can also store state [remotely] instead of using local files.

**Caution:** State files can contain secrets. Remember to [gitignore] them.

[from this template]: https://help.github.com/en/github/creating-cloning-and-archiving-repositories/creating-a-repository-from-a-template
[Terminal]: https://en.wikipedia.org/wiki/Command-line_interface

[initialized]: https://www.terraform.io/docs/commands/init.html
[gitignore]: .gitignore
[state]: https://www.terraform.io/docs/backends/state.html
[remotely]: https://www.terraform.io/docs/state/remote.html
[backend]: https://www.terraform.io/docs/backends/
[outputs]: https://learn.hashicorp.com/terraform/getting-started/outputs

## contents

### [bin](bin) scripts
### [etc](etc) config files
### [test](test) module
### [main.tf](main.tf)


## dependencies

1. [AWS credentials]
1. [Terraform] >= 0.12
1. [OpenSSH] to run `bin/keygen` and `bin/login`
1. [jq] to run `bin/login`

Terraform searches for AWS credentials in several places:

1. [hard-coded] (this can be [dangerous])
1. [environment variables]
1. a [credentials file]

[Terraform]: https://www.terraform.io/downloads.html

[hard-coded]: https://www.terraform.io/docs/providers/aws/index.html#static-credentials
[dangerous]: https://qz.com/674520/companies-are-sharing-their-secret-access-codes-on-github-and-they-may-not-even-know-it/
[environment variables]: https://www.terraform.io/docs/providers/aws/index.html#environment-variables
[credentials file]: https://www.terraform.io/docs/providers/aws/index.html#shared-credentials-file


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



[Let's do this]: https://www.youtube.com/watch?v=jbq5dsQ-l9M

## faq

### How do I view log messages?

- CloudWatch console
- Ubuntu logger
- log rotation

### How do I deploy code to a box?

### Do I need to use remote state?

### Where are the official docs?

- Terraform [docs]
- Terraform AWS [provider docs]
- Terraform AWS [example modules]

[docs]: https://www.terraform.io/docs/index.html
[provider docs]: https://www.terraform.io/docs/providers/aws/index.html
[example modules]: https://github.com/terraform-providers/terraform-provider-aws/tree/master/examples
