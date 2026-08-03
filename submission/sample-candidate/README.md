# Config Service — Sample Candidate Submission

A lightweight configuration management service written in Go and deployed locally on Kubernetes (Kind). Infrastructure is provisioned using Terraform, and configuration data is persisted in PostgreSQL.

---

# Architecture

```
.
├── cmd/
├── internal/
│   ├── domain/
│   ├── handler/
│   ├── repository/
│   └── service/
├── infra/
│   └── terraform/
│       ├── bootstrap/
│       ├── modules/
│       │   ├── namespace/
│       │   └── postgres/
│       └── platform/
├── k8s/
├── Dockerfile
├── Makefile
└── README.md
```

---

# API

| Method | Path | Description |
|--------|------|-------------|
| GET | `/ping` | Health check |
| POST | `/configs` | Create or update a configuration |
| GET | `/configs/{id}` | Retrieve a configuration |

---

## POST /configs

Example request:
curl -X POST http://localhost:8080/configs \
-H "Content-Type: application/json" \
-d '{
  "id":"cfg_1",
  "host":"localhost",
  "port":8080,
  "app_name":"config-service",
  "log_level":"INFO"
}'


---

## GET /configs/{id}

Example:

```bash
curl http://localhost:8080/configs/cfg_1
```

---

# Prerequisites

Install the following:

- Go 1.25+
- Docker
- Kind
- kubectl
- Terraform >= 1.8
- GNU Make

---

# Terraform Configuration

Create the Terraform variable files from the provided examples.

```bash
cp infra/terraform/bootstrap/terraform.tfvars.example \
   infra/terraform/bootstrap/terraform.tfvars

cp infra/terraform/platform/terraform.tfvars.example \
   infra/terraform/platform/terraform.tfvars
```

Update the values if required before deployment. 

---

# Deployment

Provision the infrastructure using terraform and deploy the application.

```bash
make up
```

This performs the following:

- Creates the Kind cluster.
- Provisions the Kubernetes namespace.
- Deploys PostgreSQL using statefulset
- Builds the application Docker image.
- Loads the image into the Kind cluster.
- Deploys the Config Service.

---

# Validate Deployment

Run deployment smoke checks.

```bash
make smoke
```

This verifies:

- Config Service deployment rollout
- Config Service pod readiness
- PostgreSQL pod readiness
- Kubernetes services

---

# Run Unit Tests

Execute the provided Go unit tests.

```bash
make test
```

or

```bash
go test ./... -v
```

---

# Access the Application

Forward the service locally.

```bash
kubectl port-forward \
-n config-service \
svc/config-service \
8080:8080
```

Health endpoint:

```bash
curl http://localhost:8080/ping
```

---

# API Examples

## Create Configuration

```bash
curl -X POST http://localhost:8080/configs \
-H "Content-Type: application/json" \
-d '{
  "id":"cfg_1",
  "host":"localhost",
  "port":8080,
  "app_name":"config-service",
  "log_level":"INFO"
}'
```

---

## Retrieve Configuration

```bash
curl http://localhost:8080/configs/cfg_1
```

---

# Verify Database

Connect to PostgreSQL.

```bash
kubectl exec -it \
-n config-service \
postgres-0 \
-- psql -U postgres -d configdb
```

Verify persisted data.

```sql
SELECT * FROM configs;
```

---

# Validation Performed

The following validation steps were completed:

- Successfully provisioned the Kind cluster using Terraform.
- Successfully provisioned the Kubernetes namespace and PostgreSQL using Terraform.
- Successfully deployed the Config Service.
- Verified PostgreSQL connectivity.
- Verified application startup.
- Successfully created configuration records through the REST API.
- Successfully retrieved configuration records through the REST API.
- Verified persisted data directly in PostgreSQL.
- Executed the provided Go handler unit tests.
- Verified deployment health using Kubernetes smoke checks.

---

# Cleanup

Destroy all provisioned infrastructure.

```bash
make down
```

---

# Future Improvements

Given additional time, the following enhancements would be implemented:
- CI/CD pipeline for automated build, validation, testing, and deployment.
- Production-grade secret management (e.g., Vault or cloud secret managers).
- Structured logging and application metrics.
- Helm configuration for the application deployment
- End-to-end integration tests.
- Database migration automation.