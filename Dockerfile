FROM python:3.8-slim-bullseye

# Environment
ENV LANG C.UTF-8
ENV LC_ALL=C.UTF-8
ENV PYTHONUNBUFFERED=1

# Install system dependencies for Odoo 14
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3-dev \
    libxml2-dev \
    libxslt1-dev \
    libldap2-dev \
    libsasl2-dev \
    libpq-dev \
    libjpeg-dev \
    zlib1g-dev \
    libpng-dev \
    libffi-dev \
    libssl-dev \
    node-less \
    npm \
    git \
    libgl1 \
    libglib2.0-0 \
    tk \
    tcl \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /opt/odoo

# Copy only requirements first (better caching)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Expose Odoo port
EXPOSE 8069

# Default command → bisa override dari docker-compose
CMD ["./odoo-bin", "-c", "/etc/odoo/odoo.conf"]
