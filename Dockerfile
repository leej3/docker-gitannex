#
# compile git annex from source
#

FROM fedora:23

# change the work dir
WORKDIR /

# setup respository for stack, install stack, cabal and build requirements
# download annex sourc and compile
# install git-annex in PATH
# cleanup
RUN curl -sSL -o /etc/yum.repos.d/fpco.repo https://s3.amazonaws.com/download.fpcomplete.com/fedora/23/fpco.repo && \
    dnf install -y cabal-install stack zlib-devel ncurses-devel git findutils && \
    mkdir /build && \
    cabal update && cabal unpack git-annex && cd git-annex* && \
    stack setup && stack install git-annex && \
    mv /root/.local/bin/git-annex /usr/local/bin && \
    rm -rf /root/.local; rm -rf /build; rm -f /etc/yum.repos.d/fpco.repo && \
    dnf remove -y cabal-install stack zlib-devel ncurses-devel; dnf autoremove -y

# Execute git-annex on exec
ENTRYPOINT ["/usr/local/bin/git-annex"]
