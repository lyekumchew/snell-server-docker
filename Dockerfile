FROM jeanblanchard/alpine-glibc:latest

LABEL maintainer="AUTUMN"

RUN apk add --update libstdc++ \
	&& apk add --no-cache --virtual .build-deps curl \
	# download the latest version release
	&& curl -s https://api.github.com/repos/surge-networks/snell/releases/latest | grep "browser_download_url" | \
		grep "linux-amd64" | cut -d '"' -f 4 | xargs -n 1 curl -sSL -O \
    && unzip *.zip && mv snell-server /usr/local/bin/ \
	&& chmod +x /usr/local/bin/snell-server \
	&& apk del .build-deps \
	&& rm -rf /var/cache/apk/* \
    && rm -rf *.zip

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT /docker-entrypoint.sh
