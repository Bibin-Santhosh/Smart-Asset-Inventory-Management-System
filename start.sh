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
    except Exception:
        print("Database not ready, waiting...")
        time.sleep(3)
EOF

echo "Running migrations..."
python manage.py migrate --noinput

echo "Ensuring admin user and password..."

python manage.py shell << 'EOF'
from django.contrib.auth import get_user_model
import os

User = get_user_model()

username = os.environ.get("DJANGO_SUPERUSER_USERNAME")
email = os.environ.get("DJANGO_SUPERUSER_EMAIL")
password = os.environ.get("DJANGO_SUPERUSER_PASSWORD")

user, created = User.objects.get_or_create(
    username=username,
    defaults={"email": email}
)

user.is_staff = True
user.is_superuser = True
user.set_password(password)
user.save()

print("Admin user ready")
EOF

echo "Starting Gunicorn..."
gunicorn asset_management.wsgi:application
