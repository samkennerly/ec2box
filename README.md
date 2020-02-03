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

To launch, inspect, and deactivate some test boxes:

1. Create a new repo [from this template].
1. Open a [terminal] and `cd` to this [folder].
1. Ensure Terraform can find AWS credentials.
1. Edit [terraform.tfvars] to set input variables.
1. Run `bin/keygen` to generate an RSA keypair.
1. Run `bin/up test` to launch all example boxes.
1. View CloudWatch logs to ensure the boxes worked.
1. Run `bin/login` to login to a box remotely with SSH.
1. Run `bin/down test` to destroy all example resources.

### credentials

Terraform [searches] for AWS credentials in this order:

1. [Static credentials] in `.tf` files can be [dangerous], so `ec2box` does not use them.
1. [Environment variables] can be passed to `terraform` commands:
    ```sh
    AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY
    ```
1. [Credential files] can be stored in a `terraform` user's home folder:
    ```sh
    ~/.aws/config
    ~/.aws/credentials
    ```
1. An [IAM role] can authorize `terraform` commands run from an AWS resource.

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

### state files

Terraform will create [state files] when the `test` module is [initialized]:
```sh
terraform.tfstate
terraform.tfstate.backup
```
State files can contain secrets! Be sure to [gitignore] them or use [remote state] instead.

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

These `.tf` files tell Terraform what to include with each box:

- [main.tf] declares AWS resources to be provisioned for each box.
- [outputs.tf] declares values to be returned when a box is created.
- [variables.tf] declares required inputs and sets default values.

### [bin](bin) folder

Optional convenience scripts for common Terraform commands.

- `bin/clean [FOLDER]` autoformats and validates Terraform code.
- `bin/down [FOLDER]` destroys all resources declared in a folder.
- `bin/keygen [KEYPATH]` generates RSA key files named `KEYPATH` and `KEYPATH.pub`.
- `bin/login [BOXNAME]` uses SSH to login to an EC2 instance.
- `bin/up [FOLDER]` creates or updates all resources declared in a folder.

### [etc](etc) folder

Default values for newly-created boxes. Each can be overridden.

- `ec2box_rsa` is an RSA private key which should be [gitignored].
- `ec2box_rsa.pub` is the RSA public key corresponding to `ec2box_rsa`.
- `install` is a script which installs software on a new box.
- `launch` is launched in the [background] when a box is ready to use.
- `policy.json` is an [IAM policy] which grants AWS permissions to a box.
- `template` is a [template file] for a [cloud-init] script.

### [test](test) module

Example resources for testing `ec2box`.

- `main.tf` declares boxes to be created by `terraform apply test`.
- `outputs.tf` declares outputs to be shown by `terraform output`.
- `variables.tf` declares inputs to be read from [terraform.tfvars].

## dependencies

1. [AWS credentials]
1. [Terraform] >= 0.12
1. [OpenSSH] to run `bin/keygen` and `bin/login`
1. [jq] to run `bin/login`

[Terraform]: https://www.terraform.io/downloads.html

## examples

Example `~/.aws/credentials` file with two profiles, `default` and `gandalf`:
```
[default]
aws_access_key_id = CRM114
aws_secret_access_key = POEOPEOEP
[gandalf]
aws_access_key_id = DUR1N
aws_secret_access_key = M3770N
```

Create or update all test boxes. (Terraform will prompt for confirmation.)
```sh
> bin/up
Initialize and update test resources
Initializing modules...

...

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

dorothy = {
  "address" = "ubuntu@ec2-54-81-15-89.compute-1.amazonaws.com"
  "arn" = "arn:aws:ec2:us-east-1:055586236777:instance/i-0e1016c6382645d91"
  "id" = "i-0e1016c6382645d91"
  "name" = "dorothy"
  "private_ip" = "172.31.18.73"
  "public_ip" = "54.81.15.89"
  "state" = "running"
  "type" = "t3.micro"
  "volume" = "vol-01ec093406b2ec798"
  "zone" = "us-east-1c"
}
leeroy = {
  "address" = "ubuntu@ec2-18-208-220-170.compute-1.amazonaws.com"
  "arn" = "arn:aws:ec2:us-east-1:055586236777:instance/i-0b00f3f44b4e95c93"
  "id" = "i-0b00f3f44b4e95c93"
  "name" = "leeroy"
  "private_ip" = "172.31.7.229"
  "public_ip" = "18.208.220.170"
  "state" = "running"
  "type" = "t3.nano"
  "volume" = "vol-07965727d3c779350"
  "zone" = "us-east-1b"
}
```

Remote login to `dorothy` via SSH. (May require [confirmation] of host's public key.)
```
> bin/login dorothy
SSH into dorothy at ubuntu@ec2-54-81-15-89.compute-1.amazonaws.com
Welcome to Ubuntu 18.04.3 LTS (GNU/Linux 4.15.0-1051-aws x86_64)

...

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@ip-172-31-18-73:~$
```

Use SSH to command the `leeroy` box to re-run its launch script:
```sh
> bin/login leeroy '~/launch'
SSH into leeroy at ubuntu@ec2-18-208-220-170.compute-1.amazonaws.com
LEEROOOOOOOOOOOOOOOOOOOOOOOY JENKINS
```

Destroy all `test` boxes. (Terraform will prompt for confirmation.)
```
Destroy all Terraform-managed resources in test
module.leeroy.aws_key_pair.ec2box: Refreshing state... [id=leeroy]
module.leeroy.aws_security_group.ec2box: Refreshing state... [id=sg-026ab9e2574cdee33]
module.dorothy.aws_cloudwatch_log_group.ec2box: Refreshing state... [id=dorothy]

...

module.dorothy.aws_iam_role.ec2box: Destroying... [id=dorothy]
module.dorothy.aws_security_group.ec2box: Destruction complete after 0s
module.dorothy.aws_iam_role.ec2box: Destruction complete after 0s

Destroy complete! Resources: 14 destroyed.
```

[confirmation]: https://unix.stackexchange.com/questions/33271/how-to-avoid-ssh-asking-permission/33273
[Let's do this]: https://www.youtube.com/watch?v=jbq5dsQ-l9M

## faq

### How do I create my own infrastructure?

Replace the `test` folder with your own module.

### How do I choose different install and/or launch scripts?

See the `dorothy` box in [test/main.tf] for an example.

### How do I deploy code to a box?

There are (too) many ways to [deploy] code to cloud machines. Here are some ideas:

- Upload code to an [S3 bucket] and use [aws s3 cp].
- Pull from GitHub. (May require [deploy keys].)
- Use AWS [CodeDeploy] to pull from GitHub.

To deploy automatically when a box is created, edit the [install] script.

### Do I need to use remote state?

No, but it's usually safer than keeping local state files on one person's laptop.

### Where are the official docs?

- Terraform [docs]
- Terraform AWS [provider docs]
- Terraform AWS [example modules]

[docs]: https://www.terraform.io/docs/index.html
[provider docs]: https://www.terraform.io/docs/providers/aws/index.html
[example modules]: https://github.com/terraform-providers/terraform-provider-aws/tree/master/examples
