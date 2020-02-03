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
- [IAM role], policy, and profile to access other AWS resources
- [cloud-init] template to configure logs, install software, and run a script

The [test] module launches example [free-tier] Ubuntu boxes:

| box name | script language | what does it do?                   |
| -------- | --------------- | ---------------------------------- |
| leeroy   | bash            | print a message                    |
| dorothy  | ruby            | print messages in an infinite loop |

[Terraform]: https://www.terraform.io/
[AWS EC2 instances]: https://aws.amazon.com/ec2/
[keypair]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html
[security group]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-security-groups.html
[CloudWatch log group]: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CloudWatchLogsConcepts.html
[IAM role]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
[cloud-init]: https://cloudinit.readthedocs.io/en/latest/
[test]: test
[free-tier]: https://aws.amazon.com/free

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

[from this template]: https://help.github.com/en/github/creating-cloning-and-archiving-repositories/creating-a-repository-from-a-template
[terminal]: https://en.wikipedia.org/wiki/Command-line_interface
[folder]: https://en.wikipedia.org/wiki/Directory_(computing)
[terraform.tfvars]: terraform.tfvars

### credentials

Terraform [searches] for AWS credentials in this order:

1. Hard-coded credentials in `.tf` files can be [dangerous]. `ec2box` does not use them.
1. Environment variables can be passed to Terraform commands:
    ```sh
    AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY
    ```
1. Credentials files can be stored in a Terraform user's home folder:
    ```sh
    ~/.aws/config
    ~/.aws/credentials
    ```
1. IAM roles can authorize Terraform commands run from an AWS resource.

[searches]: https://www.terraform.io/docs/providers/aws/index.html#authentication
[dangerous]: https://qz.com/674520/companies-are-sharing-their-secret-access-codes-on-github-and-they-may-not-even-know-it/

### inputs

The [test] module requires input [variables]. Edit [terraform.tfvars] to change them.

- <dfn>profile</dfn> selects an [AWS profile] to use for credentials
- <dfn>region</dfn> selects an [AWS region] in which to launch boxes

[test]: test
[variables]: test/variables.tf
[terraform.tfvars]: terraform.tfvars
[AWS profile]: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html
[AWS region]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html

### keypairs

An AWS [keypair] can be used to remotely control each box with [SSH].

Run `bin/keygen` to generate keys, or copy an existing [RSA] keypair here:
```sh
etc/ec2box_rsa
etc/ec2box_rsa.pub
```
Terraform will upload a copy of the public key (`.pub` file) to AWS when a box is created or when the public key changes. **The private key should be kept secret.** Be sure to [gitignore] it.

[keypair]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html
[SSH]: https://samkennerly.github.io/random/ssh_keys.html
[RSA]: https://en.wikipedia.org/wiki/RSA_(cryptosystem)
[gitignore]: .gitignore

### logs

When a box is launched, it automatically configures and starts automatic logging:

- [cloud-init] downloads, installs, configures, and starts an AWS [CloudWatch agent].
- The agent creates a [log stream] and begins streaming from  `/var/log/syslog`.
- The launch script prints errors to STDERR and all other messages to STDOUT.
- The shell redirects STDERR and STDOUT to the Ubuntu [logger].
- The logger saves logs to `/var/log/syslog`.

Cloud-init, system, and launch script logs are (hopefully) visible in the AWS [CloudWatch console]. Streams are grouped by box name. To find launch script logs in the stream, search for the box's name.

[cloud-init]: https://cloudinit.readthedocs.io/en/latest/
[CloudWatch agent]: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html
[log stream]: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CloudWatchLogsConcepts.html
[logger]: http://manpages.ubuntu.com/manpages/xenial/man1/logger.1.html
[CloudWatch console]: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Embedded_Metric_Format_View.html

### state files

Terraform will save [state] files when the `test` module is [initialized]:
```sh
terraform.tfstate
terraform.tfstate.backup
```
**State files can contain secrets!** Be sure to [gitignore] them or use [remote state] instead.

[state]: https://www.terraform.io/docs/backends/state.html
[initialized]: https://www.terraform.io/docs/commands/init.html
[gitignore]: .gitignore
[remote state]: https://www.terraform.io/docs/state/remote.html

## contents

These `.tf` files tell Terraform what to include with each box:

- `main.tf` declares AWS [resources] to acquire.
- `outputs.tf` declares [outputs] to return to other modules.
- `variables.tf` declares required [inputs] and their default values.

[resources]: https://www.terraform.io/docs/configuration/resources.html
[outputs]: https://www.terraform.io/docs/configuration/outputs.html
[inputs]: https://www.terraform.io/docs/configuration/variables.html

### [bin](bin) folder

Optional convenience scripts for common Terraform commands.

- `bin/clean [FOLDER]` autoformats and validates Terraform code.
- `bin/down [FOLDER]` destroys all resources declared in a folder.
- `bin/keygen` generates and saves an RSA keypair to the `etc` folder.
- `bin/login [BOXNAME]` uses SSH to login to an EC2 instance remotely.
- `bin/up [FOLDER]` creates or updates all resources declared in a folder.

### [etc](etc) folder

Default values for newly-created boxes. Each can be overridden.

- `ec2box_rsa` is an RSA private key.
- `ec2box_rsa.pub` is an RSA public key.
- `install` is a script which installs software.
- `launch` runs in the [background] when a box is ready to use.
- `policy.json` is an [IAM policy] which grants AWS permissions to a box.
- `template` is a [template file] for a [cloud-init] script.

[background]: x
[IAM policy]: x
[template file]: https://www.terraform.io/docs/configuration/functions/templatefile.html
[cloud-init]: https://cloudinit.readthedocs.io/en/latest/

### [test](test) module

Example resources for testing `ec2box`.

- `main.tf` declares boxes to be created by `terraform apply test`.
- `outputs.tf` declares outputs to be shown by `terraform output`.
- `variables.tf` declares inputs to be read from [terraform.tfvars].

[terraform.tfars]: terraform.tfvars

## dependencies

1. [AWS credentials]
1. [Terraform] >= 0.12
1. [OpenSSH] to run `bin/keygen` and `bin/login`
1. [jq] to run `bin/login`

[AWS credentials]: https://docs.aws.amazon.com/general/latest/gr/aws-security-credentials.html
[Terraform]: https://www.terraform.io/downloads.html
[OpenSSH]: https://www.openssh.com/
[jq]: https://stedolan.github.io/jq/

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

Destroy all test boxes. (Terraform will prompt for confirmation.)
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

### How do I define my own boxes?

Edit the [test] folder. Rename it if you want to.

[test]: test

### Do I need to use [remote state]?

No, but it's usually safer than keeping local state files on one person's laptop.

[remote state]: https://www.terraform.io/docs/backends/state.html

### How do I choose different install and/or launch scripts?

See the `dorothy` box in [test/main.tf] for an example.

[test/main.tf]: test/main.tf

### How do I deploy code to a box?

There are (too) many ways to get code onto cloud machines. Here are some ideas:

- Use [deploy keys] to pull from a private GitHub repository.
- Upload code to a private [S3 bucket] and use [aws s3 cp].
- Use AWS [CodeDeploy] for everything.

To deploy automatically when a box is created, edit the [install] script.

[deploy keys]: https://developer.github.com/v3/guides/managing-deploy-keys/
[S3 bucket]: https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingBucket.html
[aws s3 cp]: https://docs.aws.amazon.com/cli/latest/reference/s3/cp.html
[CodeDeploy]: https://docs.aws.amazon.com/codedeploy/latest/userguide/welcome.html

### Where are the official docs?

- Terraform [docs]
- Terraform AWS [provider docs]
- Terraform AWS [example modules]

[docs]: https://www.terraform.io/docs/index.html
[provider docs]: https://www.terraform.io/docs/providers/aws/index.html
[example modules]: https://github.com/terraform-providers/terraform-provider-aws/tree/master/examples
