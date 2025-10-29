FROM centos:7.6.1810 AS builder

RUN cd /etc/yum.repos.d/ && \
    sed -i 's/mirrorlist/#mirrorlist/g' CentOS-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' CentOS-* && \
    yum clean all

RUN yum update -y && \
    yum install -y \
    epel-release \
    git \
    cmake \
    make \
    gcc \
    gcc-c++ \
    curl \
    which \
    unzip \
    sudo \
    python \
    && yum clean all

RUN echo "Installing centos-release-scl-rh..." && \
    yum install -y centos-release-scl-rh && \
    yum clean all

RUN echo "Contents of /etc/yum.repos.d/ after installing SCL release package:" && \
    ls -l /etc/yum.repos.d/

RUN echo "Applying EOL fix to SCLo RH repository..." && \
    cd /etc/yum.repos.d/ && \
    if [ -f CentOS-SCLo-scl-rh.repo ]; then \
        sed -i 's/mirrorlist/#mirrorlist/g' CentOS-SCLo-scl-rh.repo && \
        sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' CentOS-SCLo-scl-rh.repo && \
        echo "CentOS-SCLo-scl-rh.repo fixed." ; \
    else \
        echo "Warning: CentOS-SCLo-scl-rh.repo not found after installing centos-release-scl-rh." ; \
    fi && \
    if [ -f CentOS-SCLo-scl.repo ]; then \
        sed -i 's/mirrorlist/#mirrorlist/g' CentOS-SCLo-scl.repo && \
        sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' CentOS-SCLo-scl.repo && \
        echo "CentOS-SCLo-scl.repo fixed." ; \
    fi && \
    yum clean metadata && \
    yum clean all && \
    echo "SCLo repo EOL fix applied."

RUN echo "Importing SCLo GPG key..." && \
    if [ -f /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo ]; then \
        rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo && \
        echo "SCLo GPG key imported." ; \
    else \
        echo "Warning: SCLo GPG key file not found. Skipping import." ; \
    fi

RUN curl -sL https://rpm.nodesource.com/setup_14.x | bash - && \
    yum install -y nodejs && \
    yum clean all

WORKDIR /build
COPY . .

RUN chmod +x scripts/*.sh

RUN sed -i '/sudo yum install -y centos-release-scl/s/^/#/' ./scripts/install_owt_server.sh && \
    ./scripts/install_owt_server.sh

RUN ./scripts/install_deps.sh
RUN ./scripts/build.js -t all
RUN ./scripts/pack.sh

FROM centos:7.6.1810

RUN cd /etc/yum.repos.d/ && \
    sed -i 's/mirrorlist/#mirrorlist/g' CentOS-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' CentOS-* && \
    yum clean all

RUN yum update -y && \
    yum install -y epel-release && \
    yum clean all

RUN curl -sL https://rpm.nodesource.com/setup_14.x | bash - && \
    yum install -y nodejs && \
    yum clean all

WORKDIR /app

COPY --from=builder /build/dist ./dist

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

WORKDIR /app/dist

EXPOSE 8080 8443 3004 30000-30050/udp

ENTRYPOINT ["/app/entrypoint.sh"]