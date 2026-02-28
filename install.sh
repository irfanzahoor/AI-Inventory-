#!/bin/bash

# AI Inventory Installation Script
# This script installs the required packages before installing the app

echo "🚀 AI Inventory Installation Script"
echo "======================================"

# Check if we're in a Frappe bench environment
if [ ! -f "apps/frappe/frappe/__init__.py" ]; then
    echo "❌ Error: This script must be run from the root of a Frappe bench directory"
    exit 1
fi

echo "📦 Installing Python packages..."

# Install packages using the bench environment
./env/bin/pip install --upgrade pip
./env/bin/pip install numpy>=1.21.0
./env/bin/pip install pandas>=1.3.0
./env/bin/pip install scikit-learn>=1.0.0
./env/bin/pip install matplotlib>=3.3.0
./env/bin/pip install scipy>=1.7.0

echo "✅ Package installation completed"

echo "📥 Installing AI Inventory app..."

# Get the app if not already present
if [ ! -d "apps/ai_inventory" ]; then
    echo "Downloading AI Inventory app..."
    bench get-app https://github.com/irfanzahoor/ai_inventory.git
fi

echo "💾 Installing app on site..."
echo "Please specify your site name:"
read -p "Site name (e.g., mysite.localhost): " SITE_NAME

if [ -z "$SITE_NAME" ]; then
    echo "❌ Site name is required"
    exit 1
fi

# Install app on site
bench --site $SITE_NAME install-app ai_inventory

echo "🔄 Running migrations..."
bench --site $SITE_NAME migrate

echo "🔥 Restarting services..."
bench restart

echo "🧹 Clearing cache..."
bench --site $SITE_NAME clear-cache

echo "✅ AI Inventory installation completed successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Log into your ERPNext site"
echo "2. Go to AI Inventory > AI Financial Settings"
echo "3. Configure your forecasting parameters"
echo "4. Run your first forecast sync"
echo ""
echo "📖 For detailed documentation, see: apps/ai_inventory/README.md"
