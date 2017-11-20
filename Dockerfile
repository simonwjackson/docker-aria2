FROM alpine:edge

LABEL maintainer "Dean Camera <http://www.fourwalledcubicle.com>"

RUN mkdir -p /conf && \
	mkdir -p /conf-copy && \
	mkdir -p /data && \
	apk add --no-cache tzdata bash aria2 darkhttpd

RUN \
 mkdir -p \
	/aria2-ng && \
 ng_tag=$(curl -sX GET  "https://api.github.com/repos/mayswind/AriaNg/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]') && \
 curl -o /aria2-ng.tar.gz -L https://github.com/mayswind/AriaNg/releases/download/${ng_tag}/aria-ng-${ng_tag}.tar.gz && \
 tar xf /aria2-ng.tar.gz -C /aria2-ng --strip-components=1 && \

ADD files/start.sh /conf-copy/start.sh
ADD files/aria2.conf /conf-copy/aria2.conf

RUN chmod +x /conf-copy/start.sh

WORKDIR /

VOLUME ["/data"]
VOLUME ["/conf"]

EXPOSE 6800
EXPOSE 80

CMD ["/conf-copy/start.sh"]
