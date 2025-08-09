Terraform Project - EC2 Module with Remote Backend (Detailed Explanation)

Project Overview

This Terraform project demonstrates industry best practices for infrastructure provisioning using:

- Reusable modules for EC2 and networking resources
- Remote state management with a shared S3 bucket and DynamoDB lock table
- Separate environment folders (`dev` and `prod`) for isolated deployments
- Use of variables, data sources, and for_each loops for scalable, flexible infrastructure

---

Architecture & Workflow

terraform-project/
├── backend-bootstrap/        # Bootstrap resources for remote state backend (S3 + DynamoDB)
│   ├── main.tf               # Creates S3 bucket and DynamoDB table for state management
│   ├── variables.tf          # Input variables for backend resources
│   ├── terraform.tfvars      # Default variable values for backend setup
│   └── outputs.tf            # Outputs bucket and table names
│
├── modules/
│   └── ec2_stack/            # Reusable module containing your original EC2, VPC, subnet, SG resources
│       ├── main.tf           # Your original resource definitions (unchanged)
│       ├── variables.tf      # Module variables for flexibility
│       └── outputs.tf        # Module outputs like instance IDs and IPs
│
├── envs/
│   ├── dev/                  # Dev environment
│   │   ├── backend.tf        # Configures remote backend with unique key `dev/terraform.tfstate`
│   │   ├── provider.tf       # AWS provider configuration (region etc.)
│   │   ├── main.tf           # Calls the ec2\_stack module
│   │   ├── variables.tf      # Environment-specific variables with defaults
│   │   └── terraform.tfvars  # Variable overrides for dev environment
│   │
│   └── prod/                 # Prod environment (same structure as dev)
│       ├── backend.tf
│       ├── provider.tf
│       ├── main.tf
│       ├── variables.tf
│       └── terraform.tfvars
│
└── README.md

````

---

 Detailed Concepts & Components

1. Remote Backend Bootstrap (`backend-bootstrap/`)

- Purpose: Creates an S3 bucket to store Terraform state files remotely and a DynamoDB table for state locking.
- Why remote state?  
  Local state files (`terraform.tfstate`) are risky because they can be lost or cause conflicts when multiple users collaborate. Using remote state keeps state centralized and secure.
- Resources created:  
  - S3 bucket with versioning & encryption enabled  
  - DynamoDB table for locking, preventing concurrent modifications

---

2. Reusable Module (`modules/ec2_stack/`)

- Contains your original EC2, VPC, subnet, security group, and route table resource definitions exactly as you wrote them.
- Uses variables for flexible configuration (e.g., CIDR blocks, availability zones, instance types).
- Uses a `for_each` loop to create multiple EC2 instances (`jenkins-master`, `build-slave`, `ansible`).
- Data source `aws_ami` dynamically fetches the latest Ubuntu AMI matching a filter.
- Outputs instance IDs and public IPs to be used if needed by other modules or environments.

---

3. Environment Folders (`envs/dev`, `envs/prod`)

- Each environment:
  - Defines its own backend configuration (points to the shared S3 bucket but uses a unique key to isolate state files).
  - Defines its own provider configuration with region and credentials.
  - Passes environment-specific variables to the module (like VPC CIDR, subnets, AZs).
  - Calls the EC2 stack module to provision resources.
- This separation:
  - Ensures environment isolation (dev resources do not interfere with prod).
  - Allows independent lifecycle of environments.
  - Supports best practices like immutable infrastructure and safer deployments.

---

4. Variables

- Variables are used extensively to:
  - Make the infrastructure flexible and reusable.
  - Avoid hardcoding values like region, CIDR blocks, subnet IP ranges, etc.
  - Easily customize infrastructure per environment by changing `.tfvars` files.
- Variables in modules define *what* inputs are needed.
- Variables in environments provide *actual values* for those inputs.

---

5. Data Sources

- Data sources allow Terraform to fetch data from existing infrastructure or AWS services.
- Here, `aws_ami` fetches the most recent Ubuntu 24.04 AMI dynamically, so you always launch the latest OS image without hardcoding the AMI ID.

---

6. for_each Loop

- Used in your EC2 instance resource to create multiple servers (`jenkins-master`, `build-slave`, `ansible`).
- This pattern allows you to create multiple similar resources efficiently with less code duplication.
- Each instance gets a tag `Name` set to its key, so you can identify them easily.

---

 How to Use This Project

# Step 1: Bootstrap Backend (run once)
```bash
cd backend-bootstrap
terraform init
terraform apply -auto-approve
````

* This sets up the remote backend infrastructure (S3 bucket + DynamoDB table).

# Step 2: Deploy an Environment (e.g., prod)

```bash
cd ../envs/prod
terraform init
terraform apply
```

* Terraform will automatically use the remote backend created earlier.
* It will provision your EC2 instances and related resources.
* Use `terraform destroy` in the same folder to tear down environment resources.

---

 Summary of Best Practices Demonstrated

* Modular design: Separate reusable code from environment configs.
* Remote state management: Centralized state with locking prevents conflicts and data loss.
* Environment isolation: Separate state files and configs for dev/prod.
* Parameterization: Use variables and `.tfvars` for flexibility and customization.
* Dynamic data sources: Always use up-to-date images or external data.
* Resource loops: Efficiently manage multiple similar resources.
* Version control: Ignore local state files and keep your Terraform code in Git.

---

 Interview Tips

* Explain how remote state backend (S3 + DynamoDB) helps with collaboration and safety.
* Highlight the module reuse and environment separation.
* Discuss how variables and data sources improve flexibility and maintainability.
* Talk about using for\_each for scalable resource creation.
* Emphasize following infrastructure as code best practices that mirror real industry workflows.

---

