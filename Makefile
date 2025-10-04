# Makefile for managing environment switching and database operations in the dev-docker project

.PHONY: help switch-env list-envs show-env equip odoo14 equip_prj db-create db-drop db-list db-restore

# Show help text
help:
	@echo "Environment switching commands:"
	@echo "  make equip       - Switch to equip environment"
	@echo "  make odoo14      - Switch to odoo14 environment"
	@echo "  make equip_prj   - Switch to equip_prj environment"
	@echo "  make list-envs   - List all available environment files"
	@echo "  make show-env    - Show current environment"
	@echo "  make switch-env  - Interactive environment switch"
	@echo ""
	@echo "Database management commands:"
	@echo "  make db-create DBNAME=name  - Create a new database"
	@echo "  make db-drop DBNAME=name    - Drop (delete) a database"
	@echo "  make db-list                - List all databases"
	@echo "  make db-restore DBNAME=name FILE=path/to/file.sql - Restore database from SQL file"
	@echo ""
	@echo "Example: make equip"
	@echo "Example: make db-create DBNAME='MY_DATABASE'"
	@echo "Example: make db-drop DBNAME='MY_DATABASE'"
	@echo "Example: make db-restore DBNAME='MY_DATABASE' FILE='/path/to/backup.sql'"

# Switch to equip environment
equip:
	@echo "Switching to equip environment..."
	@./switch_env.sh equip

# Switch to odoo14 environment
odoo14:
	@echo "Switching to odoo14 environment..."
	@./switch_env.sh odoo14

# Switch to equip_prj environment
equip_prj:
	@echo "Switching to equip_prj environment..."
	@./switch_env.sh equip_prj

# List all available environment files
list-envs:
	@./switch_env.sh list

# Show current environment
show-env:
	@./switch_env.sh show

# Interactive environment switch
switch-env:
	@echo "Available environments:"
	@./switch_env.sh list
	@read -p "Enter environment name: " env; \
	./switch_env.sh "$env"

# Database management commands
db-create:
	@if [ -z "$(DBNAME)" ]; then \
		echo "Error: DBNAME is required. Usage: make db-create DBNAME=database_name"; \
		exit 1; \
	fi
	@echo "Creating database: $(DBNAME)"
	@docker exec -it dev-docker-db-1 psql -U odoo -d postgres -c "CREATE DATABASE \"$(DBNAME)\";"

db-drop:
	@if [ -z "$(DBNAME)" ]; then \
		echo "Error: DBNAME is required. Usage: make db-drop DBNAME=database_name"; \
		exit 1; \
	fi
	@echo "Dropping database: $(DBNAME)"
	@docker exec -it dev-docker-db-1 psql -U odoo -d postgres -c "DROP DATABASE \"$(DBNAME)\";"

db-list:
	@echo "Listing all databases:"
	@docker exec -it dev-docker-db-1 psql -U odoo -d postgres -c "\l"

db-restore:
	@if [ -z "$(DBNAME)" ] || [ -z "$(FILE)" ]; then \
		echo "Error: Both DBNAME and FILE are required. Usage: make db-restore DBNAME=name FILE=path/to/file.sql"; \
		exit 1; \
	fi
	@echo "Restoring database: $(DBNAME) from $(FILE)"
	@docker exec -it dev-docker-db-1 psql -U odoo -d postgres -c "SELECT 1 FROM pg_database WHERE datname = '$(DBNAME)';" | grep -q "$(DBNAME)" || \
	docker exec -it dev-docker-db-1 psql -U odoo -d postgres -c "CREATE DATABASE \"$(DBNAME)\";"
	@docker exec -i dev-docker-db-1 psql -U odoo -d "$(DBNAME)" < "$(FILE)"