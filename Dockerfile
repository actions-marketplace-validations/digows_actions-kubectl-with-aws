FROM alpine:3.10.2
MAINTAINER Serhiy Mitrovtsiy <mitrovtsiy@ukr.net>

ARG KUBE_VERSION="1.19.0"

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh && \
    apk add --no-cache --update openssl curl ca-certificates && \
    curl -L https://storage.googleapis.com/kubernetes-release/release/v$KUBE_VERSION/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    rm -rf /var/cache/apk/*

RUN if [ -z "$AWS_ACCESS_KEY_ID" ]; 
    then
        echo "No $AWS_ACCESS_KEY_ID was set. Ignoring AWS CLI.";
    else
        apk add --no-cache \
        python3 \
        py3-pip \
        && pip3 install --upgrade pip \
        && pip3 install awscli \
        && rm -rf /var/cache/apk/* ;
    fi

ENTRYPOINT ["/entrypoint.sh"]
CMD ["cluster-info"]
