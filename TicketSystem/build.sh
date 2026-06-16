#!/usr/bin/env bash
# Build script for Render.com (runs on Linux - PostgreSQL available here)

set -o errexit   # exit on error

pip install -r requirements.txt
pip install psycopg2-binary   # Install PostgreSQL driver only on Render (Linux)

python manage.py collectstatic --no-input
python manage.py migrate
