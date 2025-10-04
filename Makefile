# Makefile for managing environment switching in the dev-docker project

.PHONY: help switch-env list-envs show-env equip odoo14 equip_prj

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
	@echo "Example: make equip"

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
	./switch_env.sh "$$env"