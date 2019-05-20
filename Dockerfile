ARG PYTHON_VERSION=3
FROM python:$PYTHON_VERSION

# update image
RUN set -ex \
    && apt-get update \
    && apt-get upgrade --yes \
    && apt-get install --yes --no-install-recommends \
        git

# install tools
WORKDIR /tmp
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# setup git
COPY configs/gitconfig /etc/gitconfig

# setup cookiecutter
ENV COOKIECUTTER_CONFIG=/etc/cookiecutter.yaml
COPY configs/cookiecutter.yaml /etc/cookiecutter.yaml
COPY cookies /usr/local/share/cookies

# setup invoke
COPY configs/invoke.yaml /etc/invoke.yaml
COPY tasks /usr/local/share/invoke/tasks

# setup entry point
WORKDIR /usr/local/src
ENTRYPOINT [ "/usr/local/bin/invoke"]
CMD ["--list"]
