# Keycloak Development Environment

## Overview
This project provides a complete development environment for Keycloak with PostgreSQL backend and ngrok integration for external access. The setup includes Docker containers for all services and a comprehensive Makefile for easy management.

## Prerequisites
- Docker and Docker Compose
- Make
- ngrok account with authtoken
- At least 4GB of available RAM
- Git

## Quick Start
1. Clone the repository:
```bash
git clone <repository-url>
cd keycloak-dev
```

2. Set up environment files:
```bash
# Create .env file with default values
cp .env.example .env

# Create .env.local for your local overrides
touch .env.local
```

3. Add your ngrok authentication token to `.env.local`:
```bash
echo "NGROK_AUTH_TOKEN=your_token_here" >> .env.local
```

4. Start the development environment:
```bash
make up
```

## Environment Configuration

### Environment Files
- `.env`: Default configuration values
- `.env.local`: Local overrides (not committed to git)

Required environment variables:
- `NGROK_AUTH_TOKEN`: Your ngrok authentication token

## Available Services

### Keycloak
- Default URL: http://localhost:8080
- Admin Console: http://localhost:8080/admin
- Default credentials:
  - Username: `admin`
  - Password: `admin`

### PostgreSQL
- Port: 5432
- Database: `keycloak`
- Username: `keycloak`
- Password: `password`

### ngrok
- Dashboard: http://localhost:4040
- External URL: Check dashboard or run `make ngrok-url`

## Available Make Commands

### Development
- `make dev`: Start development environment with logs
- `make up`: Start all containers in detached mode
- `make down`: Stop and remove containers
- `make restart`: Restart all containers

### Monitoring
- `make logs`: Show logs for all containers
- `make ps`: List running containers
- `make status`: Check service health
- `make ngrok-url`: Get public ngrok URL
- `make debug-env`: Show environment configuration

### Maintenance
- `make clean`: Stop containers and remove volumes
- `make purge`: Full cleanup (containers, volumes, images)
- `make build`: Rebuild containers

## Project Structure
```
.
├── docker-compose.yml     # Docker Compose configuration
├── Dockerfile            # Keycloak container configuration
├── Makefile             # Development commands
├── .env                 # Default environment variables
├── .env.local           # Local environment overrides
├── .gitignore          # Git ignore rules
└── realm-config/        # Keycloak realm configurations
    └── example-realm.json  # Example realm configuration
```

## Realm Configuration
The `realm-config` directory contains JSON files for realm configurations. These are automatically imported when Keycloak starts.

Example realm configuration includes:
- Basic roles (user, admin)
- Test user account
- Example client configuration

## Security Considerations

### Development Environment
- Default credentials should be changed
- PostgreSQL password should be changed
- Sensitive data should be stored in `.env.local`
- `.env.local` is gitignored for security

### Production Deployment
This setup is for development only. For production:
- Change all default passwords
- Use Docker secrets or secure environment variables
- Configure proper SSL/TLS
- Implement proper backup strategies
- Set up monitoring and alerting
- Configure proper CORS settings

## Troubleshooting

### Common Issues

1. Container fails to start:
```bash
make down
make clean
make up
```

2. Environment variables not loading:
```bash
make debug-env  # Check environment configuration
```

3. Database connection issues:
```bash
make logs  # Check logs for specific errors
```

### Logs and Debugging
- Use `make logs` to view all container logs
- Use `make status` to check service health
- Use `make debug-env` to verify environment variables

