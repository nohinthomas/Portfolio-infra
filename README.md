# nohin-portfolio-infra

Terraform infrastructure code for provisioning the Azure Static Web App that hosts [nohin.com.au](https://nohin.com.au).

## Resources managed

| Resource | Type | Purpose |
|---|---|---|
| `nohin-portfolio-tf` | Azure Static Web App (Free) | Hosts the portfolio site |

## Architecture

```
Push to main
      │
      ▼
GitHub Actions
      │
      ├── Terraform Plan  ──────────► Terraform Cloud
      │                                     │
      │                               Stores state
      │                               Shows plan
      │
      └── Terraform Apply ──────────► Terraform Cloud ──► Azure
            (on main only)                                  │
                                                    Creates/updates
                                                      resources
```

## Repository structure

```
nohin-portfolio-infra/
├── README.md
├── .gitignore
├── .github/
│   └── workflows/
│       └── terraform.yml       # Terraform plan + apply pipeline
└── infra/
    ├── main.tf                 # Azure resource definitions
    ├── variables.tf            # Input variables
    └── outputs.tf              # Outputs (URL, API key)
```

## Prerequisites

- [Terraform Cloud account](https://app.terraform.io) — free
- Azure subscription
- GitHub Secrets configured (see below)

## One-time setup

### 1. Create Terraform Cloud workspace
- Sign up at [app.terraform.io](https://app.terraform.io)
- Create organisation: `nohin-portfolio`
- Create workspace: `portfolio-prod`
- Set execution mode to **Remote**

### 2. Create Service Principal (Azure Cloud Shell)
```bash
# Get your subscription ID
az account show --query id -o tsv

# Create the Service Principal
az ad sp create-for-rbac \
  --name "sp-nohin-portfolio" \
  --role Contributor \
  --scopes /subscriptions/YOUR_SUBSCRIPTION_ID \
  --sdk-auth
```

### 3. Add GitHub Secrets
Go to this repo → Settings → Secrets and variables → Actions

| Secret | Value |
|---|---|
| `ARM_CLIENT_ID` | `clientId` from SP output |
| `ARM_CLIENT_SECRET` | `clientSecret` from SP output |
| `ARM_TENANT_ID` | `tenantId` from SP output |
| `ARM_SUBSCRIPTION_ID` | `subscriptionId` from SP output |
| `TF_API_TOKEN` | Terraform Cloud → User Settings → Tokens → Create token |

### 4. Push to main
GitHub Actions handles everything from here.

## After first deployment

Retrieve the Static Web App API key and add it to your **nohin-portfolio** repo secrets:

```bash
# In Terraform Cloud UI → workspace → outputs → api_key
```

Add as `AZURE_STATIC_WEB_APPS_API_TOKEN` in the nohin-portfolio repo.

## CI/CD behaviour

| Trigger | What happens |
|---|---|
| Open PR | `terraform plan` runs — review in Terraform Cloud UI |
| Merge to main | `terraform apply` runs automatically |

## Notes
- Terraform state is stored remotely in Terraform Cloud — never in this repo
- No credentials are stored in code — all via GitHub Secrets.
- The existing resource group `rg-nohin-portfolio` is referenced, not recreated
