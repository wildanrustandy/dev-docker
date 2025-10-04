#!/bin/bash

# Fungsi untuk mengakses semua perintah database dari luar direktori project

# Fungsi untuk membuat database
dev_db_create() {
    cd /Users/wildanrustandy/Dev/dev-docker && docker exec dev-docker-db-1 psql -U odoo -d postgres -c "CREATE DATABASE \"$1\";"
}

# Fungsi untuk menghapus database
dev_db_drop() {
    cd /Users/wildanrustandy/Dev/dev-docker && docker exec dev-docker-db-1 psql -U odoo -d postgres -c "DROP DATABASE \"$1\";"
}

# Fungsi untuk melihat daftar database
dev_db_list() {
    cd /Users/wildanrustandy/Dev/dev-docker && docker exec dev-docker-db-1 psql -U odoo -d postgres -c "\l"
}

# Fungsi untuk melakukan backup database
dev_db_backup() {
    cd /Users/wildanrustandy/Dev/dev-docker && docker exec dev-docker-db-1 pg_dump -U odoo "$1" > "$2"
}

# Fungsi untuk melakukan restore database
dev_db_restore() {
    # Expand ~ to $HOME if present in the file path
    local sql_file="$(eval echo "$2")"
    
    # Check if file exists
    if [ ! -f "$sql_file" ]; then
        echo "Error: SQL file '$sql_file' does not exist"
        return 1
    fi
    
    cd /Users/wildanrustandy/Dev/dev-docker && docker exec dev-docker-db-1 psql -U odoo -d postgres -c "SELECT 1 FROM pg_database WHERE datname = '$1';" | grep -q "$1" || \
    docker exec dev-docker-db-1 psql -U odoo -d postgres -c "CREATE DATABASE \"$1\";"
    
    cd /Users/wildanrustandy/Dev/dev-docker && docker exec -i dev-docker-db-1 psql -U odoo -d "$1" < "$sql_file"
}

# Instruksi penggunaan:
# Tambahkan baris berikut ke ~/.zshrc atau ~/.bashrc:
# source /Users/wildanrustandy/Dev/dev-docker/db_functions.sh
#
# Kemudian kamu bisa menggunakan perintah:
# dev_db_create 'NAMA_DATABASE'     # Membuat database baru
# dev_db_drop 'NAMA_DATABASE'       # Menghapus database
# dev_db_list                       # Melihat daftar database
# dev_db_backup 'NAMA_DATABASE' '/path/ke/file.sql'   # Backup database
# dev_db_restore 'NAMA_DATABASE' '/path/ke/file.sql'  # Restore database