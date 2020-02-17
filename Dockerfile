from fedora:31

# To install the C++ broker and tools:
RUN dnf -y update \
    && dnf install -y qpid-proton-cpp-devel \
                      qpid-cpp-client-devel \
                      qpid-cpp-server \
                      qpid-tools \
    && dnf clean all

#ENV QPID_PORT=6000
#ENV QPID_MAX_CONNECTIONS=10
#ENV QPID_LOG_TO_FILE=/tmp/qpidd.log

EXPOSE 5672
COPY run.sh /tmp
CMD /tmp/run.sh
