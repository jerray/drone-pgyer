FROM alpine:3.9

ENV JQ_URL="https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64"

RUN apk add --no-cache curl \
    && curl -L -o /bin/jq $JQ_URL \
    && chmod +x /bin/jq

ADD script.sh /bin/script.sh
ENTRYPOINT /bin/script.sh
