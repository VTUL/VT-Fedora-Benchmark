# VT Fedora Benchmark

Fully automated benchmark for Fedora 4 Repository testing realistic workflows leveraging
collected sensor data obtained from sensor- and accelerometer-outfitted Goodwin Hall at
Virginia Tech. This raw data is stored in HDF5 files.

VT Fedora Benchmark is primarily meant to run withing AWS ecosystem. When evaluating Fedora
using the benchmark overall workflow can be split into 2 parts:

* **Setup** - involves provisioning and subsequent provisioning of AWS resources. This part
is fully automated using [Ansible](https://www.ansible.com/) playbook.
* **Execution** - involves running workflows against resources provisioned in the step 1.
This part is fully automated using [Gradle](https://gradle.org/) build system.

## Setup

#### Ansible

After cloning the repository make sure to install and properly configure Ansible on your host
machine. Please follow instructions mentioned in the Ansible documentation.

1. Install Ansible - [Installation](http://docs.ansible.com/ansible/intro_installation.html) and
[Getting Started](http://docs.ansible.com/ansible/intro_getting_started.html) sections
2. Configure Ansible with EC2 - [AWS EC2 External Inventory](http://docs.ansible.com/ansible/intro_dynamic_inventory.html#example-aws-ec2-external-inventory-script)
section

#### AWS

After Ansible has been installed and properly set up it is necessary to make sure AWS is properly prepared.
The benchmark requires input HDF5 files to be available for processing in AWS S3 bucket. Please make
sure to create personal S3 bucket and upload all the files you wish to use for processing. 

Sample input set containing _60 HDF5 files of size 50MB_ is available here: https://drive.google.com/drive/folders/0B5gbHbvEraLnLXZjc055TUNpcW8?usp=sharing

In addition it is necessary to manually create EC2 IAM role named **FedoraAnsibleS3ReadRole** with at least
_AmazonS3ReadOnlyAccess_ managed policy (you can specify _AmazonS3FullAccess_ but it is not necessary).
Please note that not all versions of Ansible EC2 allow programmatically create IAM roles on AWS, which is
why, for now, is [this Ansible playbook step](aws-playbook.yml#L75) commented out. If you're positive that your version of Ansible
supports mentioned functionality feel free to uncomment [following section](aws-playbook.yml#L75) in `automation/aws-playbook-yml`
and skip this step.

#### Executing Playbook

After above-mentioned configuration has been performed you are ready to run the playbook and get resources
set up. All the necessary files are stored under `automation` directory.

1. Setup Ansible global variables stored in [automation/group_vars/all](all). Make sure to follow guidelines
stored in the same file for each variable.
2. Execute Ansible playbook - [automation/aws-playbook.yml](aws-playbook.yml)
```
# example execution
ansible-playbook -i ec2.py automation/aws-playbook.yml
```

## Execution

Assuming that everything went well you now have configured AWS environment with all the major components
installed and communicating with each other. Ansible setup additionally takes care of altering your local
benchmark configuration file with correct values from AWS to enable smoother execution. The benchmark itself
is mere Gradle-based Java application and thus all the Gradle commands apply. 

Please note that
you don't have to have Gradle installed - the solution comes with 2 scripts - `gradlew` for Linux/OS X and 
`gradlew.bat` for Windows. Feel free to replace below gradle commands with appropriate script.

#### Building

```
gradle assemble

or

gradle build
```

#### Running
```
# running in batch/offline mode
gradle run -Dadministrator=edu.vt.sil.administrator.BatchAdministrator

# running in interactive mode (read below for explanation) 
gradle run -Dadministrator=edu.vt.sil.administrator.InteractiveAdministrator -Dexec.args="<enter arguments here>"
```

## Additional Materials

Above-mentioned guide allows you to get going as quickly as possible. If you wish to learn more about overall workflow
different execution modes and experiment customization please visit following website: [Fedora 4 Benchmarking](https://webapps.es.vt.edu/confluence/display/~agalad/Fedora+4+Benchmarking)