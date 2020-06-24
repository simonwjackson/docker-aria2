FROM alpine
MAINTAINER Simon W. Jackson <hello@simonwjackson.io>
ENV RPC_LISTEN_PORT=6800
ENV RPC_SECRET=
ENV PUID=1000
ENV PGID=1000

EXPOSE $RPC_LISTEN_PORT

RUN apk add \
			--update \
			--no-cache \
			aria2 \
  && \
  rm -rf \
    /var/cache/apk/* && \
  addgroup \
    -g ${PGID} \
    aria2 && \
  adduser \
    -D \
    -H \
    -g '' \
    -u ${PUID} \
    -G aria2 \
    aria2 && \
  mkdir -p /downloads && \
	chmod 755 /downloads && \
  chown aria2:aria2 /downloads && \ 
	mkdir -p /session && \
  touch /session/aria2 && \ 
  chown -R aria2:aria2 /session && \
  chmod 755 /session && \
  chmod 644 /session/aria2 && \
	mkdir -p /cache && \
  chown -R aria2:aria2 /cache && \
  chmod 755 /cache

USER aria2
VOLUME /downloads
VOLUME /cache
VOLUME /session 
ENTRYPOINT aria2c \
	--dir=/downloads \
	--log-level=error \
	--enable-rpc=true \
	--rpc-secret=${RPC_SECRET} \
	--rpc-listen-port=${RPC_LISTEN_PORT} \
	--rpc-listen-all=true \
	--rpc-allow-origin-all=true \
	--disable-ipv6=true \
	--save-session=/session/aria2 \
	--input-file=/session/aria2 \
  --dht-file-path=/cache/dht.dat \
	$@ \ 
	> /dev/stdout \
	2 > /dev/stderr

