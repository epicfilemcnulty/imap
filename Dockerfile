FROM alpine:3.11 as builder
LABEL maintainer="vladimir@deviant.guru"

COPY scripts/builder.sh /root/
RUN /root/builder.sh
COPY apk/ /home/builder/
RUN chown -R builder /home/builder
USER builder
RUN cd /home/builder && abuild-keygen -a -n -i -q
RUN cd /home/builder/dovecot && abuild checksum && abuild -r

FROM alpine:3.11
LABEL maintainer="vladimir@deviant.guru"

RUN apk add --no-cache lua 
COPY --from=builder /home/builder/.abuild/vladimir@deviant.guru-*.rsa.pub /etc/apk/keys/
COPY --from=builder /home/builder/built/builder/x86_64/dovecot-2.3.10-r0.apk /root/
COPY entrypoint.sh /
RUN apk add --no-cache /root/dovecot-2.3.10-r0.apk && rm /root/dovecot-2.3.10-r0.apk
COPY users.lua /scripts/
ENTRYPOINT ["/entrypoint.sh"]
