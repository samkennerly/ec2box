# ec2box (UNDER CONSTRUCTION)

There is no cloud. It's just someone else's computer.

<img
  alt="I am the Architect."
  src="https://raw.githubusercontent.com/samkennerly/posters/master/ec2box.jpeg"
  title="It's more fun to compute.">

## abstract

`ec2box` uses [Terraform] to launch [AWS EC2 instances].
Each <q>box</q> includes its own:

- [keypair] to enable remote SSH login
- [security group] to control network access
- [CloudWatch log group] to store and read log messages
- [IAM role], [policy], and [profile] to access other AWS resources
- [cloud-init] template to configure logs, install software, and run a script

The [test] module launches example [free-tier] Ubuntu boxes:

| box name | script language | what does it do? |
| ---- | -------- | ---------------- |
| leeroy | bash | print a message |
| dorothy | ruby | print messages in an [infinite loop] |

[EC2 instance]: https://aws.amazon.com/ec2/

## basics

1. Create a new repo [from this template].
1. Open a [terminal] and `cd` to this [folder].
1. Ensure Terraform can find AWS credentials.
1. Edit [terraform.tfvars] to set input variables.
1. Run `bin/keygen` to generate an RSA keypair.
1. Run `bin/up test` to launch all example boxes.
1. View CloudWatch logs to ensure the boxes worked.
1. Run `bin/down test` to destroy all example boxes.

Terraform stores [state files] in this folder when it is [initialized]:
```sh
terraform.tfstate
terraform.tfstate.backup
```
State files can contain secrets! Be sure to [gitignore] them or use [remote state].

### credentials

Terraform [searches] for AWS credentials in this order:

1. [static credentials]. These can be [dangerous], so `ec2box` does not use them.
1. [environment variables] passed to `terraform` commands:
    ```sh
    AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY
    ```
1. an AWS [profile] and [credentials file]:
    ```sh
    ~/.aws/config
    ~/.aws/credentials
    ```
1. an [IAM role] if Terraform is run from an AWS resource.

### inputs

The [test] module requires [input variables]. Edit [terraform.tfvars] to change them.

- <dfn>profile</dfn> selects an [AWS profile] to use for credentials
- <dfn>region</dfn> selects an [AWS region] in which to launch boxes

### keypairs

`ec2box` uses [SSH keys] to remotely control running boxes.

Run `bin/keygen` to generate keys, or copy an existing [RSA keypair] here:
```sh
etc/ec2box_rsa
etc/ec2box_rsa.pub
```
Terraform will upload a copy of the public key (`.pub` file) to AWS when a box is created or when the public key changes. **The private key should be kept secret.** Be sure to [gitignore] it.

### logs

When a box is launched, its cloud-init [template] configures and starts automatic logging:

- [cloud-init] downloads, installs, configures, and starts an AWS [CloudWatch agent].
- The agent creates a [log stream] and begins streaming from  `/var/log/syslog`.
- The launch script prints errors to STDERR and all other messages to STDOUT.
- The shell redirects STDERR and STDOUT to the Ubuntu [logger].
- The logger saves logs to `/var/log/syslog`.

Cloud-init, system, and launch script logs are (hopefully) visible in the AWS [CloudWatch console]. Streams are grouped by box name, e.g. `leeroy` boxes send logs to the `leeroy` group.

To find launch script logs in the stream, search by the box's name.









[AWS credentials]: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html
[hard-coded]: https://www.terraform.io/docs/providers/aws/index.html#static-credentials
[dangerous]: https://qz.com/674520/companies-are-sharing-their-secret-access-codes-on-github-and-they-may-not-even-know-it/
[environment variables]: https://www.terraform.io/docs/providers/aws/index.html#environment-variables
[credentials file]: https://www.terraform.io/docs/providers/aws/index.html#shared-credentials-file



[CloudWatch agent]: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html
[CloudWatch console]: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Embedded_Metric_Format_View.html


[from this template]: https://help.github.com/en/github/creating-cloning-and-archiving-repositories/creating-a-repository-from-a-template
[Terminal]: https://en.wikipedia.org/wiki/Command-line_interface

[initialized]: https://www.terraform.io/docs/commands/init.html
[gitignore]: .gitignore
[state]: https://www.terraform.io/docs/backends/state.html
[remote state]: https://www.terraform.io/docs/state/remote.html
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
