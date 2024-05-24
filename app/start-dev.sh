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
pip3 install -r requirements.txt
port=50505
host=localhost
python3 -m quart --app main:app run --port "$port" --host "$host" --reload