#!/bin/bash

#Menu

show_help() {
    echo "Usage: $0 -u user  -d database -o output -t table"
    echo "Usage: $0 -u root -d database -o output -t table"
    echo
    echo "Options:"
    echo "  -u, --user        Database username"
    echo "  -d, --database    Database name"
    echo "  -o, --output      Output file name"
    echo "  -t, --table       Database table name"
    echo "  -h, --help        Show this help message and exit"
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -u|--user) USER="$2"; shift ;;
        -p|--password) PASSWORD="$2"; shift ;;
        -d|--database) DATABASE="$2"; shift ;;
        -o|--output) OUTPUT_FILE="$2"; shift ;;
        -t|--table) SQL_table="$2"; shift ;;
        -h|--help|?) show_help; exit 0 ;;
        *) echo "Unknown parameter passed: $1"; show_help; exit 1 ;;
    esac
    shift
done


if [ -z "$USER" ] || [ -z "$DATABASE" ] || [ -z "$OUTPUT_FILE" ] || [ -z "$SQL_table" ]; then
    echo "Error: Missing required parameters."
    show_help
    exit 1
fi

SQL_QUERY="SELECT * FROM $SQL_table;"

if [ "$USER" == "root" ]; then
	sudo mysql -u "$USER" -D "$DATABASE" -e "$SQL_QUERY" --batch --silent | sed 's/\t/,/g' > "$OUTPUT_FILE".csv
else 	
	mysql -u "$USER" -p -D "$DATABASE" -e "$SQL_QUERY" --batch --silent | sed 's/\t/,/g' > "$OUTPUT_FILE".csv
fi

echo "Data exported to $OUTPUT_FILE"


