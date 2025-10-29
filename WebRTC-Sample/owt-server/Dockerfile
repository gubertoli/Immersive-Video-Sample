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

RUN echo "Manually creating fixed SCLo repo files..." && \
    echo '[centos-sclo-sclo]' > /etc/yum.repos.d/CentOS-SCLo-scl.repo && \
    echo 'name=CentOS-7 - SCLo sclo' >> /etc/yum.repos.d/CentOS-SCLo-scl.repo && \
    echo '#mirrorlist=http://mirrorlist.centos.org/?arch=$basearch&release=7&repo=sclo-sclo' >> /etc/yum.repos.d/CentOS-SCLo-scl.repo && \
    echo 'baseurl=http://vault.centos.org/centos/7/sclo/x86_64/sclo/' >> /etc/yum.repos.d/CentOS-SCLo-scl.repo && \
    echo 'gpgcheck=1' >> /etc/yum.repos.d/CentOS-SCLo-scl.repo && \
    echo 'enabled=1' >> /etc/yum.repos.d/CentOS-SCLo-scl.repo && \
    echo 'gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo' >> /etc/yum.repos.d/CentOS-SCLo-scl.repo && \
    \
    echo '[centos-sclo-rh]' > /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo && \
    echo 'name=CentOS-7 - SCLo rh' >> /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo && \
    echo '#mirrorlist=http://mirrorlist.centos.org/?arch=$basearch&release=7&repo=sclo-rh' >> /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo && \
    echo 'baseurl=http://vault.centos.org/centos/7/sclo/x86_64/rh/' >> /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo && \
    echo 'gpgcheck=1' >> /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo && \
    echo 'enabled=1' >> /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo && \
    echo 'gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo' >> /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo && \
    \
    rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo && \
    yum clean all

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