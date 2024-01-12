# ec2box

There is no cloud. It's just someone else's computer.

<img
  alt="Will Ferrell, wearing a 3-piece suit, sits in front of a wall of computer monitors, each of which shows Neo from the film THE MATRIX."
  src="https://raw.githubusercontent.com/samkennerly/posters/master/ec2box.jpeg"
  title="I am the Architect.">


## abstract

Use [Terraform] to automatically launch and configure [Amazon EC2] resources. Each <q>box</q> includes its own:

- [EC2 instance] to run programs
- [keypair] to allow remote SSH login
- [security group] to control network access
- [CloudWatch log group] to store and read log messages
- [IAM role], policy, and profile to authorize use of other AWS resources
- [cloud-init] template to configure logs, install software, and run a script

The [test] module launches example [free-tier] Ubuntu boxes:

| box name | script language | what it does                       |
| -------- | --------------- | ---------------------------------- |
| dorothy  | ruby            | print timestamped messages         |
| leeroy   | bash            | print a message, then crash        |

[Terraform]: https://www.terraform.io/
[Amazon EC2]: https://aws.amazon.com/ec2/
[EC2 instance]: https://aws.amazon.com/ec2/instance-types/
[keypair]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html
[security group]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-security-groups.html
[CloudWatch log group]: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CloudWatchLogsConcepts.html
[IAM role]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
[cloud-init]: https://cloudinit.readthedocs.io/en/latest/
[test]: test
[free-tier]: https://aws.amazon.com/free


## basics

- Create a new repo [from this template].
- Open a [terminal] and `cd` to this folder.

[from this template]: https://help.github.com/en/github/creating-cloning-and-archiving-repositories/creating-a-repository-from-a-template
[terminal]: https://en.wikipedia.org/wiki/Command-line_interface

### authorize AWS

Terraform needs access to [AWS security credentials]. These can be hard-coded in `.tf` files, but storing secrets in code [can be dangerous]. It is safer to use [environment variables]:
```sh
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```
or [credentials files] in the user's home folder:
```sh
~/.aws/config
~/.aws/credentials
```

[AWS security credentials]: https://docs.aws.amazon.com/IAM/latest/UserGuide/security-creds.html
[can be dangerous]: https://www.zdnet.com/article/over-100000-github-repos-have-leaked-api-or-cryptographic-keys/
[environment variables]: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#environment-variables
[credentials files]: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#shared-configuration-and-credentials-files

### choose a keypair

- Run `bin/keygen` to generate a [keypair].

The private and public keys will be saved here:
```sh
etc/ec2box_rsa
etc/ec2box_rsa.pub
```

When a new box is created, or the public key changes, Terraform will upload a copy of the public key to AWS. Anyone with both keys (public and private) can then login remotely to each box with [SSH].

*Caution: The private key in the `ec2box_rsa` file must be kept secret.* This repo [gitignores] it.

[keypair]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html
[SSH]: https://samkennerly.github.io/random/ssh_keys.html
[gitignores]: .gitignore

### launch boxes

- Edit [terraform.tfvars] to choose an [AWS profile] and [AWS region].
- Run `bin/up test` to launch all example boxes.

Terraform will save [state] files when the `test` module is [initialized]:
```sh
terraform.tfstate
terraform.tfstate.backup
```
*Caution: State files (including [remote state]) can contain secrets!* This repo [gitignores] them.

[terraform.tfvars]: terraform.tfvars
[AWS profile]: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html
[AWS region]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions
[state]: https://www.terraform.io/docs/backends/state.html
[initialized]: https://www.terraform.io/docs/commands/init.html
[remote state]: https://www.terraform.io/docs/state/remote.html

### inspect boxes

- Run `bin/login` to login to a box remotely with SSH.

Usually, remote login is unnecessary because boxes can be monitored by reading log messages. Each box creates its own [CloudWatch log group] and streams logs to it. The pipeline works like this:

1. [cloud-init] downloads, installs, configures, and starts an AWS [CloudWatch agent].
1. The agent creates a [log stream] and begins streaming from  `/var/log/syslog`.
1. The launch script prints errors to STDERR and all other messages to STDOUT.
1. The shell redirects STDERR and STDOUT to the Ubuntu [logger].
1. The logger saves logs to `/var/log/syslog`.

Cloud-init, system, and launch script logs will then be visible in the AWS [CloudWatch console].

[cloud-init]: https://cloudinit.readthedocs.io/en/latest/
[CloudWatch agent]: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html
[log stream]: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CloudWatchLogsConcepts.html
[logger]: http://manpages.ubuntu.com/manpages/xenial/man1/logger.1.html
[CloudWatch console]: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Embedded_Metric_Format_View.html

### deactivate boxes

1. Run `bin/down test` to destroy all example resources.


## contents

Configuration files for the Terraform [root module]:

- [main.tf] declares AWS [resources] to acquire.
- [outputs.tf] declares [outputs] to return to other modules.
- [variables.tf] declares required [inputs] and their default values.
- [terraform.tfvars] file sets [root module variables].

[root module]: https://developer.hashicorp.com/terraform/language/modules
[main.tf]: main.tf
[resources]: https://www.terraform.io/docs/configuration/resources.html
[outputs.tf]: outputs.tf
[outputs]: https://www.terraform.io/docs/configuration/outputs.html
[variables.tf]: variables.tf
[inputs]: https://www.terraform.io/docs/configuration/variables.html
[terraform.tfvars]: terraform.tfvars
[root module variables]: https://developer.hashicorp.com/terraform/language/values/variables#assigning-values-to-root-module-variables

### [bin](bin)

Short scripts to run Terraform commands:

- `bin/clean [FOLDER]` autoformats and validates Terraform code.
- `bin/down [FOLDER]` destroys all resources declared in a folder.
- `bin/keygen` generates and saves an RSA keypair to the `etc` folder.
- `bin/login [BOXNAME]` uses SSH to login to an EC2 instance remotely.
- `bin/up [FOLDER]` creates or updates all resources declared in a folder.

### [etc](etc)

Default configuration files for each newly-created box:

- `ec2box_rsa` is an RSA private key.
- `ec2box_rsa.pub` is an RSA public key.
- `install` is a script which installs software.
- `launch` runs in the [background] when a box is ready to use.
- `policy.json` is an [IAM policy] which grants AWS permissions to a box.
- `template` is a [template file] for a [cloud-init] script.

[background]: https://stackoverflow.com/questions/9190151/how-to-run-a-shell-script-in-the-background-and-get-no-output
[IAM policy]: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html
[template file]: https://www.terraform.io/docs/configuration/functions/templatefile.html
[cloud-init]: https://cloudinit.readthedocs.io/en/latest/

### [test](test)

Example resources for testing `ec2box`:

- `main.tf` declares boxes to be created by `terraform apply test`.
- `outputs.tf` declares outputs to be shown by `terraform output`.
- `variables.tf` declares inputs to be read from [terraform.tfvars].

[terraform.tfars]: terraform.tfvars

#### [test/dorothy](test/dorothy)

Configuration files for a test box named `dorothy` which prints timestamped messages every 1 second.


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

Create or update all test boxes. (Terraform will prompt for confirmation.)
```sh
> bin/up
Initialize and update test resources
Initializing modules...

...

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

...
```

Remote login to `dorothy` via SSH. (You might need to confirm the [host public key].)
```
> bin/login dorothy
SSH into dorothy at ubuntu@ec2-54-81-15-89.compute-1.amazonaws.com
Welcome to Ubuntu 18.04.3 LTS (GNU/Linux 4.15.0-1051-aws x86_64)

...

ubuntu@ip-123-45-67-89:~$
```

Use SSH to run the launch script on the `leeroy` box again:
```sh
> bin/login leeroy '~/launch'
SSH into leeroy at ubuntu@ec2-18-208-220-170.compute-1.amazonaws.com
LEEROOOOOOOOOOOOOOOOOOOOOOOY JENKINS
```

Destroy all test boxes. (Terraform will prompt for confirmation.)
```
Destroy all Terraform-managed resources in test

...

Destroy complete! Resources: 14 destroyed.
```

[host public key]: https://unix.stackexchange.com/questions/33271/how-to-avoid-ssh-asking-permission/33273


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

Here are some common methods:

- Upload code to a private [S3 bucket] and [aws s3 sync] it to a box.
- Use [deploy keys] to pull from a private GitHub repository.
- Use AWS [CodeDeploy] for everything.

To deploy code automatically when a box is created, edit its [install] script.

[S3 bucket]: https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingBucket.html
[aws s3 sync]: https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3/sync.html
[deploy keys]: https://developer.github.com/v3/guides/managing-deploy-keys/
[CodeDeploy]: https://docs.aws.amazon.com/codedeploy/latest/userguide/welcome.html
[install]: etc/install

### Where are the official docs?

- Terraform [docs]
- Terraform AWS [provider docs]
- Terraform AWS [example modules]

[docs]: https://www.terraform.io/docs/index.html
[provider docs]: https://www.terraform.io/docs/providers/aws/index.html
[example modules]: https://github.com/terraform-providers/terraform-provider-aws/tree/master/examples
