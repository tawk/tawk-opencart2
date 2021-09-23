FROM bitnami/opencart:2.3.0-2-r0

ENV OPENCART_ROOT_DIR=/opt/bitnami/opencart

# Copy setup script
ADD setup.sh /tmp/build/setup.sh

# RUN setup
RUN chmod +x /tmp/build/setup.sh
RUN /tmp/build/setup.sh
