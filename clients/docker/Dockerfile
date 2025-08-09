FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    borgbackup \
    socat \
    gnupg2 \
    pass \
    git \
    ca-certificates \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /data

COPY keygen.conf /tmp/keygen.conf

RUN gpg --batch --generate-key /tmp/keygen.conf && \
    GPG_FPR=$(gpg --list-keys --with-colons | awk -F: '/^pub/ { print $5; exit }') && \
    pass init "$GPG_FPR" && \
    echo "your_password_for_borg_repository" | pass insert -m -f path/to/your/pass/password/for/borgbackup/repo && \
    rm -f /tmp/keygen.conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]