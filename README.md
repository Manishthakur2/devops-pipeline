# devops-pipeline

A production-ready CI/CD pipeline that automatically tests, builds, and deploys a containerized Flask application to AWS EC2 on every push to main.

---

## Architecture

```
Developer pushes code
        │
        ▼
┌─────────────────┐
│  GitHub Actions  │
│                 │
│  1. Run Tests   │──── FAIL ──▶ Pipeline blocked, no deploy
│  2. Build Image │
│  3. Push to     │
│     Docker Hub  │
│  4. Deploy to   │
│     AWS EC2     │
│  5. Health Check│──── FAIL ──▶ Alert triggered
└─────────────────┘
        │
        ▼
   App is live on EC2
```

---

## Tech Stack

| Tool | Purpose |
|---|---|
| GitHub Actions | CI/CD automation |
| Docker | Containerization |
| Docker Hub | Image registry |
| AWS EC2 | Cloud deployment |
| Flask | Web application |
| pytest | Automated testing |

---

## Pipeline Stages

**1. Test** — Runs on every push and pull request. Installs dependencies with pip cache for faster builds, then runs pytest. Pipeline is blocked if any test fails — nothing broken ever reaches production.

**2. Build & Push** — Triggers only on push to main. Builds the Docker image and pushes it to Docker Hub at `manishthakur2/devops-pipeline:latest`.

**3. Deploy** — SSHes into the AWS EC2 instance, pulls the latest image, replaces the running container with zero manual intervention.

**4. Health Check** — Hits the `/health` endpoint after deploy. If the app doesn't respond with 200, the pipeline fails and the issue is flagged immediately.

---

## Key Features

- **Zero-downtime deploys** — old container is stopped and replaced automatically
- **Non-root container** — app runs as unprivileged user for security
- **Pip caching** — dependency caching cuts build time by ~70%
- **Branch protection** — main branch requires CI to pass before any merge
- **Health gate** — deployment is verified post-launch, not just assumed

---

## Project Structure

```
devops-pipeline/
├── app/
│   ├── app.py            # Flask application
│   └── test_app.py       # pytest test suite
├── .github/
│   └── workflows/
│       └── ci.yml        # GitHub Actions pipeline
├── Dockerfile            # Container definition
├── docker-compose.yml    # Local run config
├── .dockerignore         # Keeps image clean
└── requirements.txt      # Python dependencies
```

---

## Running Locally

```bash
git clone https://github.com/manishthakur2/devops-pipeline.git
cd devops-pipeline

# Run with Docker
docker compose up

# App is live at http://localhost:5000
```

---

## API Endpoints

| Endpoint | Method | Response |
|---|---|---|
| `/` | GET | `{"message": "DevOps Pipeline is live!", "status": "ok"}` |
| `/health` | GET | `{"status": "healthy"}` |

---

## GitHub Secrets Required

| Secret | Description |
|---|---|
| `DOCKER_USERNAME` | Docker Hub username |
| `DOCKER_PASSWORD` | Docker Hub access token |
| `EC2_HOST` | EC2 public IP address |
| `EC2_USER` | EC2 SSH username |
| `EC2_SSH_KEY` | Private key for EC2 SSH access |

---

## What I Learned

- How to design a multi-stage CI/CD pipeline with job dependencies
- Securing containers by running as a non-root user
- Using GitHub Secrets to manage credentials safely
- Automating zero-downtime deployments to cloud infrastructure
- Verifying deployments with post-deploy health checks

---

*Built by [Manish Thakur](https://github.com/manishthakur2)*
