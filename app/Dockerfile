FROM nikolaik/python-nodejs:python3.10-nodejs21

# Set the working directory
WORKDIR /app

# Copy your application code to the container
COPY . .

RUN ls -a /app
RUN ls -a .
# Install bash
RUN apt-get update && apt-get install -y bash

# Install dependencies
RUN cd frontend && npm install && cd ..

# Install Python dependencies
RUN cd backend && python3 -m pip install -r requirements.txt && cd ..

# Start your application
CMD ["/bin/bash", "-c", "source start-prod.sh"]