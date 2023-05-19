FROM alpine:3.18
LABEL maintainer="Thomas GUIRRIEC <thomas@guirriec.frr>"
COPY apk_packages /
ENV USERNAME='grype'
ENV UID=1000
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN xargs -a /apk_packages apk add --no-cache --update \
    && useradd -l -m -u ${UID} -U -s /bin/sh ${USERNAME} \
    && curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin \
    && chown -R ${USERNAME}:${USERNAME} /usr/local/bin/grype \
    && rm -rf \
         /tmp/* \
         /root/.cache/*
USER ${USERNAME}
HEALTHCHECK CMD grype version || exit 1
ENTRYPOINT ["/bin/sh", "-c", "sleep infinity"]
