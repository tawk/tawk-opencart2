FROM bitnami/opencart:2.3.0-2-r0

ENV OPENCART_ROOT_DIR=/opt/bitnami/opencart

# Copy setup script
ADD ./assets/setup.sh /tmp/setup.sh

# RUN setup
RUN chmod +x /tmp/setup.sh
RUN /tmp/setup.sh

# Copy plugin files
COPY ./bin/tawkto/admin/controller/extension /opt/bitnami/opencart/admin/controller/extension
COPY ./bin/tawkto/admin/language/english/extension /opt/bitnami/opencart/admin/language/en-gb/extension
COPY ./bin/tawkto/admin/view /opt/bitnami/opencart/admin/view
COPY --chown=daemon:daemon ./bin/tawkto/catalog/controller/extension /opt/bitnami/opencart/catalog/controller/extension
COPY --chown=daemon:daemon ./bin/tawkto/catalog/view/theme/default /opt/bitnami/opencart/catalog/view/theme/default
