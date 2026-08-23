FROM rclone/rclone:1.75.0

RUN apk add --no-cache bash su-exec tini

COPY entrypoint.sh /usr/local/bin/gdrive-entrypoint
COPY filters.conf /etc/gdrive/filters.conf

ENTRYPOINT ["/sbin/tini", "-g", "--", "/usr/local/bin/gdrive-entrypoint"]
CMD ["service"]
