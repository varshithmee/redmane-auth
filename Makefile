.PHONY: help dev up down restart logs ps clean purge build status ngrok-url check-env debug-env

# Include .env file
-include .env .env.local
export

# Colors for terminal output
YELLOW := \033[1;33m
GREEN := \033[1;32m
RED := \033[1;31m
NC := \033[0m # No Color

# Debug environment variables
debug-env:
	@echo "$(YELLOW)Checking environment configuration:$(NC)"
	@echo "NGROK_AUTH_TOKEN=$(if $(NGROK_AUTH_TOKEN),$(GREEN)Found$(NC),$(RED)Not found$(NC))"
	@echo "\nContents of .env file:"
	@if [ -f .env ]; then \
		cat .env | sed 's/^/  /'; \
	else \
		echo "$(RED)  .env file not found$(NC)"; \
	fi
	@echo "\nCurrent working directory:"
	@pwd

# Check for required environment variables
check-env:
	@if [ ! -f .env ]; then \
		echo "$(RED)Error: .env file not found$(NC)"; \
		exit 1; \
	fi
	@if [ -z "$(NGROK_AUTH_TOKEN)" ]; then \
		echo "$(RED)Error: NGROK_AUTH_TOKEN is not set in .env file$(NC)"; \
		echo "Current .env contents:"; \
		cat .env | sed 's/^/  /'; \
		exit 1; \
	fi

# Default target
help:
	@echo "$(YELLOW)Available commands:$(NC)"
	@echo "$(GREEN)make dev$(NC)        - Start development environment with logs"
	@echo "$(GREEN)make up$(NC)         - Start all containers in detached mode"
	@echo "$(GREEN)make down$(NC)       - Stop and remove containers"
	@echo "$(GREEN)make restart$(NC)    - Restart all containers"
	@echo "$(GREEN)make logs$(NC)       - Show logs for all containers"
	@echo "$(GREEN)make ps$(NC)         - List running containers"
	@echo "$(GREEN)make clean$(NC)      - Stop containers and remove volumes"
	@echo "$(GREEN)make purge$(NC)      - Full cleanup (containers, volumes, images)"
	@echo "$(GREEN)make build$(NC)      - Rebuild containers"
	@echo "$(GREEN)make status$(NC)     - Check service health"
	@echo "$(GREEN)make ngrok-url$(NC)  - Get ngrok public URL"

# Development environment
dev: check-env
	@echo "$(YELLOW)Starting development environment...$(NC)"
	docker compose up --build

# Start containers in detached mode
up: check-env
	@echo "$(YELLOW)Starting containers in detached mode...$(NC)"
	docker compose up -d --build
	@echo "$(GREEN)Services are starting...$(NC)"
	@echo "Access Keycloak admin at: http://localhost:8080"
	@echo "Check ngrok status at: http://localhost:4040"

# Stop containers
down:
	@echo "$(YELLOW)Stopping containers...$(NC)"
	docker compose down
	@echo "$(GREEN)Containers stopped$(NC)"

# Restart containers
restart: down up

# Show logs
logs:
	@echo "$(YELLOW)Showing logs for all containers...$(NC)"
	docker compose logs -f

# Show container status
ps:
	@echo "$(YELLOW)Current container status:$(NC)"
	docker compose ps

# Clean up containers and volumes
clean:
	@echo "$(YELLOW)Cleaning up containers and volumes...$(NC)"
	docker compose down -v
	@echo "$(GREEN)Cleanup complete$(NC)"

# Full cleanup including images
purge:
	@echo "$(RED)WARNING: This will remove all containers, volumes, and images$(NC)"
	@read -p "Are you sure? [y/N] " confirmation; \
	if [ "$$confirmation" = "y" ]; then \
		docker compose down -v; \
		docker rmi $$(docker images -q quay.io/keycloak/keycloak) 2>/dev/null || true; \
		docker rmi $$(docker images -q postgres) 2>/dev/null || true; \
		docker rmi $$(docker images -q ngrok/ngrok) 2>/dev/null || true; \
		echo "$(GREEN)Purge complete$(NC)"; \
	fi

# Rebuild containers
build:
	@echo "$(YELLOW)Rebuilding containers...$(NC)"
	docker compose build --no-cache
	@echo "$(GREEN)Build complete$(NC)"

# Check service health
status:
	@echo "$(YELLOW)Checking service health...$(NC)"
	@echo "\nKeycloak:"
	@docker compose exec keycloak curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 || echo "Not responding"
	@echo "\nPostgres:"
	@docker compose exec postgres pg_isready -U keycloak || echo "Not responding"
	@echo "\nNgrok:"
	@curl -s localhost:4040/status | grep -o '"url":"[^"]*"' || echo "Not responding"

# Get ngrok URL
ngrok-url:
	@echo "$(YELLOW)Fetching ngrok public URL...$(NC)"
	@curl -s localhost:4040/api/tunnels | grep -o '"public_url":"[^"]*"' | cut -d'"' -f4 || echo "Ngrok not running"
