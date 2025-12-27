#!/bin/bash
# Install dependencies and run Python seed script

set -e

DB_URL="${1:-postgresql://neondb_owner:npg_92QkaxuXfnRB@ep-odd-dream-ah5ij0pt-pooler.c-3.us-east-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require}"
TPU="${2:-8}"
COUNT="${3:-10000}"

echo "=========================================="
echo "Installing Python dependencies..."
echo "=========================================="

# Try to install via apt first
sudo apt-get update -qq 2>/dev/null || true
sudo apt-get install -y python3-pip 2>/dev/null || echo "apt-get unavailable, trying pip directly"

# Install Python packages
pip3 install --quiet faker psycopg2-binary 2>/dev/null || \
python3 -m pip install --quiet faker psycopg2-binary 2>/dev/null || \
python3 -m pip install faker psycopg2-binary

echo ""
echo "=========================================="
echo "Running database seed script..."
echo "=========================================="
echo "  Database: ${DB_URL:0:50}..."
echo "  Transactions per user: $TPU"
echo "  Total users: $COUNT"
echo ""

python3 scripts/seed_faker_10k.py "$DB_URL" --tpu "$TPU" --count "$COUNT"

echo ""
echo "=========================================="
echo "✓ Seeding complete!"
echo "=========================================="
