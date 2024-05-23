# Set environment variables
source .env
# Activate virtual environment
# source venv/bin/activate

# Run frontend
cd frontend
npm run build
cd ..

# Run backend
cd backend
port=80
python3 -m quart --app main:app run --port "$port" --host "0.0.0.0" --reload