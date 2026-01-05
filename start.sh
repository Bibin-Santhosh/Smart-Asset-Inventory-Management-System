#!/usr/bin/env bash
set -o errexit

echo "Running migrations..."
python manage.py migrate --noinput

echo "Starting Gunicorn..."
gunicorn asset_management.wsgi:application
