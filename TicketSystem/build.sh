#!/usr/bin/env bash
# Build script for Render.com (runs on Linux - PostgreSQL available here)

set -o errexit   # exit on error

pip install -r requirements.txt
pip install psycopg2-binary   # Install PostgreSQL driver only on Render (Linux)

python manage.py collectstatic --no-input
python manage.py makemigrations
python manage.py migrate

# Create admin superuser automatically
python manage.py shell -c "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.filter(username='admin').exists() or User.objects.create_superuser('admin', 'admin@example.com', 'admin')"
