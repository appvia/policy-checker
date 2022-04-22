FROM python:alpine
LABEL org.opencontainers.image.authors="info@appvia.io" \
      org.opencontainers.image.source="https://github.com/appvia/policy-checker" \
      org.opencontainers.image.vendor="Appvia Ltd"

# Set working directory
WORKDIR /workdir
ENV HOME /home/app

# Install required binaries
RUN apk add -U --no-cache \
    bash jq git

# Install checkov dependencies
RUN apk add --no-cache \
    gcc libc-dev libffi-dev

# Install checkov and update PATH
COPY requirements.txt ./
RUN pip install -r requirements.txt

# Copy entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

CMD entrypoint.sh
