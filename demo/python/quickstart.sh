#!/bin/bash
# Quick start script for BESTSELLER AI Demo

set -e

echo "🚀 BESTSELLER AI Demo - Quick Start"
echo "===================================="
echo ""

# Check Python version
echo "📋 Checking Python version..."
python3 --version

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo ""
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
else
    echo ""
    echo "✅ Virtual environment already exists"
fi

# Activate virtual environment
echo ""
echo "🔧 Activating virtual environment..."
source venv/bin/activate

# Install dependencies
echo ""
echo "📥 Installing dependencies..."
echo "This may take a few minutes on first run..."
pip install --upgrade pip > /dev/null 2>&1
pip install -r requirements.txt

# Check if .env exists
if [ ! -f ".env" ]; then
    echo ""
    echo "⚙️  Creating .env file from example..."
    cp .env.example .env
    echo ""
    echo "⚠️  IMPORTANT: Edit .env file with your Azure OpenAI credentials!"
    echo "   The chat endpoint will not work without valid credentials."
    echo ""
fi

# Run tests
echo ""
echo "🧪 Running tests..."
python3 test_data.py

# Show example usage
echo ""
echo "📖 Example Usage:"
echo ""
python3 example_usage.py

echo ""
echo "✅ Setup complete!"
echo ""
echo "To start the server, run:"
echo "  source venv/bin/activate"
echo "  python3 main.py"
echo ""
echo "Then visit:"
echo "  http://localhost:8000/docs (API documentation)"
echo "  http://localhost:8000/health (health check)"
echo ""
