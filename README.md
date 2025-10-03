# Odoo Development Docker Setup

This repository contains a Docker-based development environment for Odoo, with PostgreSQL database and configuration for local development.

## Prerequisites

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Setup

1. Clone this repository
2. Copy `.env.example` to `.env` and customize the values for your environment:
   ```bash
   cp .env.example .env
   ```
3. Update the `.env` file with your specific paths and settings
4. Ensure your Odoo source code is available at the path specified in `.env` (default is `/Users/wildanrustandy/dev/equip`)

> Note: The `.env` file is ignored by git for security purposes. Use `.env.example` as a template for setting up your own `.env` file.

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
- `^odoo14# Odoo Development Docker Setup

This repository contains a Docker-based development environment for Odoo, with PostgreSQL database and configuration for local development.

## Prerequisites

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Setup

1. Clone this repository
2. Copy `.env.example` to `.env` and customize the values for your environment:
   ```bash
   cp .env.example .env
   ```
3. Update the `.env` file with your specific paths and settings
4. Ensure your Odoo source code is available at the path specified in `.env` (default is `/Users/wildanrustandy/dev/equip`)

> Note: The `.env` file is ignored by git for security purposes. Use `.env.example` as a template for setting up your own `.env` file.

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

 - Only match database named exactly "odoo14"
- `^DEV# Odoo Development Docker Setup

This repository contains a Docker-based development environment for Odoo, with PostgreSQL database and configuration for local development.

## Prerequisites

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Setup

1. Clone this repository
2. Copy `.env.example` to `.env` and customize the values for your environment:
   ```bash
   cp .env.example .env
   ```
3. Update the `.env` file with your specific paths and settings
4. Ensure your Odoo source code is available at the path specified in `.env` (default is `/Users/wildanrustandy/dev/equip`)

> Note: The `.env` file is ignored by git for security purposes. Use `.env.example` as a template for setting up your own `.env` file.

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

 - Only match database named exactly "DEV"  
- `^%h# Odoo Development Docker Setup

This repository contains a Docker-based development environment for Odoo, with PostgreSQL database and configuration for local development.

## Prerequisites

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Setup

1. Clone this repository
2. Copy `.env.example` to `.env` and customize the values for your environment:
   ```bash
   cp .env.example .env
   ```
3. Update the `.env` file with your specific paths and settings
4. Ensure your Odoo source code is available at the path specified in `.env` (default is `/Users/wildanrustandy/dev/equip`)

> Note: The `.env` file is ignored by git for security purposes. Use `.env.example` as a template for setting up your own `.env` file.

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

 - Match databases based on HTTP hostname
- `.*` - Match all databases

The filter pattern in `ODOO_DB_FILTER` from the `.env` file should be manually copied to the 
`dbfilter` parameter in `config/odoo.conf` to ensure proper database filtering.

### Example Environment Files

This repository includes example environment files for different setups:
- `.env.example.odoo14` - Configuration for odoo14 environment
- `.env.example.equip` - Configuration for equip environment
- `.env.example.equip_prj` - Configuration for equip_prj environment

To set up your environment, copy the appropriate example file to `.env` and modify as needed.

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