# syntax=docker/dockerfile:1
FROM mikefarah/yq:4.30.4 as yq

FROM alpine

RUN apk --update --no-cache add fzf

COPY --from=yq /usr/bin/yq /usr/bin/yq
COPY marker /dev/null

ADD select.sh /select.sh

ADD index.yaml /index.yaml

CMD ["/select.sh"]