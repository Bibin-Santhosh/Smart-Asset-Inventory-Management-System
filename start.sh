#!/usr/bin/env bash
set -o errexit

echo "Waiting for database to be ready..."

python - << 'EOF'
import time
import psycopg2
import os

db_url = os.environ.get("DATABASE_URL")

while True:
    try:
        psycopg2.connect(db_url)
        print("Database is ready!")
        break
    except Exception as e:
        print("Database not ready, waiting...")
        time.sleep(3)
EOF

echo "Running migrations..."
python manage.py migrate --noinput

echo "Starting Gunicorn..."
gunicorn asset_management.wsgi:application