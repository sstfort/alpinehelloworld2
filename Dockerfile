FROM alpine:latest

# Install Python and dependencies
RUN apk add --no-cache --update python3 py3-pip bash

# Create virtual environment and install packages
RUN python3 -m venv /opt/venv && \
    . /opt/venv/bin/activate && \
    pip install --no-cache-dir -r /tmp/requirements.txt

# Set PATH to use the virtual environment
ENV PATH="/opt/venv/bin:$PATH"

# Copy the app
ADD ./webapp /webapp

# Set working directory
WORKDIR /webapp

# Run the application
CMD ["python", "app.py"]
