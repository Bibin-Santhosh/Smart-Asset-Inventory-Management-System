FROM python:3.11-slim

WORKDIR /app

# Prevent Python cache & buffering
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Django required env vars
ENV DEBUG=False

ENV ALLOWED_HOSTS=*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Create static folder explicitly
RUN mkdir -p staticfiles

# Collect static files
RUN python manage.py collectstatic --noinput

CMD ["gunicorn", "asset_management.wsgi:application", "--bind", "0.0.0.0:8000"]
