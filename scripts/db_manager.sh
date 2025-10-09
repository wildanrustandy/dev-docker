#!/bin/bash

# Script to manage databases in the dev-docker PostgreSQL container
# Can be called from anywhere using the universal dev_db function

# Function to display usage
usage() {
    echo "Usage: $0 <command> <database_name> [additional_parameters]"
    echo ""
    echo "Commands:"
    echo "  create     - Create a new database"
    echo "  drop       - Drop (delete) a database"
    echo "  list       - List all databases"
    echo "  backup     - Backup a database to SQL file"
    echo "  restore    - Restore a database from SQL file"
    echo ""
    echo "Examples:"
    echo "  $0 create 'MY_DATABASE'"
    echo "  $0 drop 'MY_DATABASE'"
    echo "  $0 list"
    echo "  $0 backup 'MY_DATABASE' '/path/to/backup.sql'"
    echo "  $0 restore 'MY_DATABASE' '/path/to/backup.sql'"
    echo ""
    echo "For global access, add this function to ~/.zshrc or ~/.bashrc:"
    echo "dev_db() { /Users/wildanrustandy/Dev/dev-docker/db_manager.sh \"\$@\"; }"
    exit 1
}

# Check if no arguments provided
if [ $# -lt 1 ]; then
    usage
fi

# Get the command
COMMAND="$1"

# Change to the dev-docker directory to ensure proper execution
cd /Users/wildanrustandy/Dev/dev-docker

case "$COMMAND" in
    create)
        if [ -z "$2" ]; then
            echo "Error: Database name is required"
            echo ""
            usage
        fi
        
        DB_NAME="$2"
        echo "Creating database: $DB_NAME"
        docker exec dev-docker-db-1 psql -U odoo -d postgres -c "CREATE DATABASE \"$DB_NAME\";"
        ;;
        
    drop)
        if [ -z "$2" ]; then
            echo "Error: Database name is required"
            echo ""
            usage
        fi
        
        DB_NAME="$2"
        echo "Dropping database: $DB_NAME"
        docker exec dev-docker-db-1 psql -U odoo -d postgres -c "DROP DATABASE \"$DB_NAME\";"
        ;;
        
    list)
        echo "Listing all databases:"
        docker exec dev-docker-db-1 psql -U odoo -d postgres -c "\l"
        ;;
        
    backup)
        if [ -z "$2" ] || [ -z "$3" ]; then
            echo "Error: Both database name and backup file path are required"
            echo ""
            usage
        fi
        
        DB_NAME="$2"
        BACKUP_FILE="$3"
        echo "Backing up database '$DB_NAME' to '$BACKUP_FILE'"
        docker exec dev-docker-db-1 pg_dump -U odoo "$DB_NAME" > "$BACKUP_FILE"
        ;;
        
    restore)
        if [ -z "$2" ] || [ -z "$3" ]; then
            echo "Error: Both database name and SQL file path are required"
            echo ""
            usage
        fi
        
        DB_NAME="$2"
        # Expand ~ to $HOME if present in the file path
        SQL_FILE="$(eval echo "$3")"
        
        # Check if file exists
        if [ ! -f "$SQL_FILE" ]; then
            echo "Error: SQL file '$SQL_FILE' does not exist"
            exit 1
        fi
        
        echo "Restoring database '$DB_NAME' from '$SQL_FILE'"
        # First create the database if it doesn't exist
        docker exec dev-docker-db-1 psql -U odoo -d postgres -c "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME';" | grep -q "$DB_NAME" || \
        docker exec dev-docker-db-1 psql -U odoo -d postgres -c "CREATE DATABASE \"$DB_NAME\";"
        
        # Then restore from SQL file
        docker exec -i dev-docker-db-1 psql -U odoo -d "$DB_NAME" < "$SQL_FILE"
        ;;
        
    *)
        echo "Error: Unknown command '$COMMAND'"
        echo ""
        usage
        ;;
esac