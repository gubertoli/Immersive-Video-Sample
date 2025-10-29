FROM centos:7.6.1810 AS builder

RUN cd /etc/yum.repos.d/ && \
    sed -i 's/mirrorlist/#mirrorlist/g' CentOS-Base.repo CentOS-CR.repo CentOS-Debuginfo.repo CentOS-fasttrack.repo CentOS-Media.repo CentOS-Sources.repo CentOS-Vault.repo CentOS-SCLo-scl.repo CentOS-SCLo-scl-rh.repo && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' CentOS-Base.repo CentOS-CR.repo CentOS-Debuginfo.repo CentOS-fasttrack.repo CentOS-Media.repo CentOS-Sources.repo CentOS-Vault.repo CentOS-SCLo-scl.repo CentOS-SCLo-scl-rh.repo && \
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

RUN curl -sL https://rpm.nodesource.com/setup_14.x | bash - && \
    yum install -y nodejs && \
    yum clean all

WORKDIR /build
COPY . .

RUN chmod +x scripts/*.sh

RUN ./scripts/install_owt_server.sh
RUN ./scripts/install_deps.sh
RUN ./scripts/build.js -t all
RUN ./scripts/pack.sh

FROM centos:7.6.1810

RUN cd /etc/yum.repos.d/ && \
    sed -i 's/mirrorlist/#mirrorlist/g' CentOS-Base.repo CentOS-CR.repo CentOS-Debuginfo.repo CentOS-fasttrack.repo CentOS-Media.repo CentOS-Sources.repo CentOS-Vault.repo CentOS-SCLo-scl.repo CentOS-SCLo-scl-rh.repo && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' CentOS-Base.repo CentOS-CR.repo CentOS-Debuginfo.repo CentOS-fasttrack.repo CentOS-Media.repo CentOS-Sources.repo CentOS-Vault.repo CentOS-SCLo-scl.repo CentOS-SCLo-scl-rh.repo && \
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