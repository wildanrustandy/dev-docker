# Odoo Development Docker Setup

This repository contains a Docker-based development environment for Odoo, with PostgreSQL database and configuration for local development.

## Prerequisites

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Setup

1. Clone this repository
2. Copy `.env.example` to `.env` and customize the values for your environment, or use the environment switching script or Makefile (recommended):
   ```bash
   # Option 1: Manual copy
   cp .env.example .env
   
   # Option 2: Use the switching script (recommended)
   ./switch_env.sh equip        # For equip project
   ./switch_env.sh odoo14       # For odoo14 project
   ./switch_env.sh equip_prj    # For equip_prj project
   
   # Option 3: Use the Makefile (alternative method)
   make equip                   # For equip project
   make odoo14                  # For odoo14 project
   make equip_prj               # For equip_prj project
   ```
3. Update the `.env` file with your specific paths and settings
4. Ensure your Odoo source code is available at the path specified in `.env` (default is `/Users/wildanrustandy/dev/equip`)

> Note: The `.env` file is ignored by git for security purposes. Use `.env.example` as a template for setting up your own `.env` file.

## Environment Switching

This project includes convenient tools to switch between different environments:

- `switch_env.sh` - A shell script for switching between environment configurations
- `Makefile` - Provides make commands for environment switching

Environment template files are stored in the `env-template/` directory with the naming pattern `.env.template.{project-name}`.

To see all available environments:
```bash
./switch_env.sh list
# or
make list-envs
```

To see the current environment:
```bash
./switch_env.sh show
# or
make show-env
```

To switch environments using Makefile:
```bash
make equip       # Switch to equip environment
make odoo14      # Switch to odoo14 environment
make equip_prj   # Switch to equip_prj environment
```

## Using Shell Functions for Global Access

You can also add shell functions to your `~/.zshrc` or `~/.bashrc` to access environment switching and database management from anywhere:

```bash
# Environment switching function
dev_env() {
    cd /Users/wildanrustandy/Dev/dev-docker && ./switch_env.sh "$1"
}

# Database management functions
dev_db_create() {
    cd /Users/wildanrustandy/Dev/dev-docker && make db-create DBNAME="$1"
}

dev_db_drop() {
    cd /Users/wildanrustandy/Dev/dev-docker && make db-drop DBNAME="$1"
}

dev_db_list() {
    cd /Users/wildanrustandy/Dev/dev-docker && make db-list
}

dev_db_restore() {
    cd /Users/wildanrustandy/Dev/dev-docker && make db-restore DBNAME="$1" FILE="$2"
}

# Alternative functions using the db_manager.sh script
dev_db_create_alt() {
    cd /Users/wildanrustandy/Dev/dev-docker && ./db_manager.sh create "$1"
}

dev_db_drop_alt() {
    cd /Users/wildanrustandy/Dev/dev-docker && ./db_manager.sh drop "$1"
}

dev_db_list_alt() {
    cd /Users/wildanrustandy/Dev/dev-docker && ./db_manager.sh list
}

dev_db_restore_alt() {
    cd /Users/wildanrustandy/Dev/dev-docker && ./db_manager.sh restore "$1" "$2"
}
```

After adding these functions and restarting your shell (or running `source ~/.zshrc`), you can use:

```bash
# Environment switching from anywhere (these will change directory):
dev_env odoo14      # Switch to odoo14 environment
dev_env equip       # Switch to equip environment
dev_env equip_prj   # Switch to equip_prj environment

# Database management from anywhere (no directory change required):
dev_db_create 'MY_DATABASE'
dev_db_drop 'MY_DATABASE'
dev_db_list
dev_db_restore 'MY_DATABASE' '/path/to/backup.sql'
```

**Important:** For the most convenient database management from anywhere, use the universal `dev_db` function:

```bash
# Add this single function to your ~/.zshrc or ~/.bashrc:
dev_db() { /Users/wildanrustandy/Dev/dev-docker/db_manager.sh "$@"; }

# Then you can use from anywhere:
dev_db create 'MY_DATABASE'
dev_db drop 'MY_DATABASE'
dev_db list
dev_db restore 'MY_DATABASE' '/path/to/backup.sql'
```

## Database Management

This project includes convenient tools for database management:

### Using Makefile Commands

```bash
# Create a new database
make db-create DBNAME='MY_DATABASE'

# Drop (delete) a database
make db-drop DBNAME='MY_DATABASE'

# List all databases
make db-list

# Restore a database from SQL file
make db-restore DBNAME='MY_DATABASE' FILE='/path/to/backup.sql'
```

### Using the Database Manager Script

```bash
# Create a new database
./db_manager.sh create 'MY_DATABASE'

# Drop (delete) a database
./db_manager.sh drop 'MY_DATABASE'

# List all databases
./db_manager.sh list

# Backup a database (to host file system)
./db_manager.sh backup 'MY_DATABASE' '/path/to/backup.sql'

# Restore a database from SQL file
./db_manager.sh restore 'MY_DATABASE' '/path/to/backup.sql'
```

### Direct Docker Commands

```bash
# Create a database
docker exec -it dev-docker-db-1 psql -U odoo -d postgres -c "CREATE DATABASE \"MY_DATABASE\";"

# Drop a database
docker exec -it dev-docker-db-1 psql -U odoo -d postgres -c "DROP DATABASE \"MY_DATABASE\";"

# List all databases
docker exec -it dev-docker-db-1 psql -U odoo -d postgres -c "\l"

# Restore from SQL file
docker exec -i dev-docker-db-1 psql -U odoo -d "MY_DATABASE" < /path/to/backup.sql
```

## Usage

### Starting the Services

To start both the database and Odoo services:

```bash
docker-compose up
```

This will start the PostgreSQL database and launch Odoo with the configuration from `./config/odoo.conf`. Odoo will be accessible at `http://localhost:9045` (or the port specified in your `.env` file).

### Running Database in Background

If you want to run just the database in the background and have more control over the Odoo service:

```bash
# Start only the database in background
docker-compose up -d db

# Run Odoo manually (separate terminal)
docker-compose run --rm odoo
```

The `--rm` flag automatically removes the container once it exits, which helps keep your system clean by not leaving stopped containers behind.

### Running Database and Odoo Separately (Recommended for Development)

If you want to run the database in the background and Odoo in the foreground:

```bash
# 1. Start the database in background
docker-compose up -d db

# 2. Wait for a few seconds to ensure database is ready
sleep 10

# 3. Run Odoo in the foreground
docker-compose up odoo

# 4. When finished, stop Odoo with Ctrl+C
# The database will remain running in the background

# 5. To stop the database when completely done:
docker-compose down
```

This approach allows you to see Odoo logs in real-time while keeping your database running between sessions.

### Stopping Odoo Service (while keeping Database Running)

If you started with `docker-compose up` and press `Ctrl+C`, it will stop only the Odoo service while keeping the database running in the background. This is useful during development when you want to restart Odoo without losing your database state.

To stop just the Odoo service manually:
```bash
docker-compose stop odoo
```

To stop all services:
```bash
docker-compose down
```

### Checking Running Services

To see which containers are currently running:
```bash
docker-compose ps
```

## Database Management

### Creating a New Database

To create a new database, access the PostgreSQL container:

```bash
docker exec -it dev-docker-db-1 psql -U odoo -d postgres
```

Then run:
```sql
CREATE DATABASE "YOUR_DATABASE_NAME";
```

### Restoring a Database

To restore a database from a SQL dump file:

1. First, create the database if it doesn't exist:
```bash
docker exec -it dev-docker-db-1 psql -U odoo -d postgres
```
```sql
CREATE DATABASE "YOUR_DATABASE_NAME";
\q
```

2. Then restore the database from your SQL file:
```bash
docker exec -i dev-docker-db-1 psql -U odoo -d "YOUR_DATABASE_NAME" < /path/to/your/dump.sql
```

For example, using the database name from your setup:
```bash
docker exec -i dev-docker-db-1 psql -U odoo -d "DEV-WMSCORE" < /Users/wildanrustandy/Downloads/WMS2.sql
```

### Accessing Database

To access your database directly:
```bash
docker exec -it dev-docker-db-1 psql -U odoo -d YOUR_DATABASE_NAME
```

## Configuration

### Environment Variables

The `.env` file contains important configuration variables:

- `POSTGRES_DB`: PostgreSQL database name
- `POSTGRES_USER`: PostgreSQL user
- `POSTGRES_PASSWORD`: PostgreSQL password
- `DB_PORT`: PostgreSQL port
- `ODOO_DB_FILTER`: Regular expression for database filtering (used in odoo.conf)
- `ODOO_PORT`: Port where Odoo will be accessible
- `ODOO_PATH`: Path to your Odoo source code
- `ODOO_ADDONS`: Comma-separated list of addon paths
- `ODOO_DATA_DIR`: Directory for Odoo data

### Odoo Configuration

The `./config/odoo.conf` file contains the Odoo configuration:

- Database connection settings
- Database filter settings (dbfilter parameter)
- Addon paths
- Logging configuration
- Data directory

> **Note:** In Odoo 14 and later, database filtering is configured using the `dbfilter` parameter in `odoo.conf` rather than the command-line `--db_filter` option which was used in earlier versions.

### Database Filtering

In Odoo 14, database filtering is configured in `config/odoo.conf` using the `dbfilter` parameter. 
The value is a regular expression that determines which databases the Odoo instance will access.
Examples:
- `^odoo14 - Only match database named exactly "odoo14"
- `^DEV - Only match database named exactly "DEV"  
- `^%h - Match databases based on HTTP hostname
- `.*` - Match all databases

The filter pattern in `ODOO_DB_FILTER` from the `.env` file should be manually copied to the 
`dbfilter` parameter in `config/odoo.conf` to ensure proper database filtering.

### Environment Template Files

This repository includes template environment files for different setups, organized in the `env-template/` directory:
- `env-template/.env.template.odoo14` - Configuration for odoo14 environment
- `env-template/.env.template.equip` - Configuration for equip environment
- `env-template/.env.template.equip_prj` - Configuration for equip_prj environment

To set up your environment, use the switching script or copy the appropriate template file to `.env` and modify as needed.

## Troubleshooting

### Odoo Container Won't Start

Check the logs:
```bash
docker-compose logs odoo
```

### Database Connection Issues

Make sure the database container is running:
```bash
docker-compose ps
```

### Port Already in Use

If you get a port binding error, change the `ODOO_PORT` in `.env` to an available port.

## Stopping All Services

To stop all containers and remove them:
```bash
docker-compose down
```

To stop all containers and remove volumes (this will delete your database data):
```bash
docker-compose down -v
```

## Development Workflow

A recommended workflow for development:

1. Start the database in the background:
```bash
docker-compose up -d db
```

2. Run Odoo in the foreground for development:
```bash
docker-compose run --rm odoo
```
Note: This method does NOT expose ports to your host machine, so you won't be able to access the Odoo web interface. It's primarily useful for command-line operations.

To access the Odoo web interface, you should use:
```bash
docker-compose up odoo
```
This will automatically map the port as defined in the docker-compose.yml file.

3. When you need to restart Odoo, simply press `Ctrl+C` and run the command again

4. When done working, stop the database:
```bash
docker-compose down
```

This allows you to keep your database running between Odoo restarts while having the flexibility to modify Odoo code and restart as needed.

### Alternative Approaches:

**Option 1: Using `docker-compose up` (Recommended for web access)**
```bash
docker-compose up odoo
```
This will start both the database and Odoo services together and automatically map the port as defined in the docker-compose.yml file, making Odoo accessible via your web browser at `http://localhost:9045`. Pressing `Ctrl+C` will stop both services.

**Option 2: Using `docker-compose run` (For command-line operations)**
```bash
docker-compose run --rm odoo
```
Use this command for command-line operations or when you don't need web access to Odoo. Note that this method does NOT expose the port to your host machine, so Odoo web interface will not be accessible. The container will be removed after execution (`--rm` flag).

**Option 3: Using `docker-compose run` with manual port mapping (if you need web access)**
```bash
docker-compose run --rm -p ${ODOO_PORT}:8069 odoo
```
Use this command if you want to access the web interface with `docker-compose run`. Make sure the database is already running with `docker-compose up -d db` first.