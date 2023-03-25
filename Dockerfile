FROM debian:buster

RUN apt-get -y -q update \
    && apt-get -y -q install sudo nano git curl wget build-essential python3-pip python2 python2-dev

# Install python2-pip
RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output /tmp/get-pip.py \
    && python2 /tmp/get-pip.py \
    && python2 -m pip install distorm3 pycryptodome

RUN git clone https://github.com/volatilityfoundation/volatility /volatility/ \
    && cd /volatility/

RUN echo '#!/bin/bash\npython2 /volatility/vol.py ${@}' > /bin/volatility \
    && chmod +x /bin/volatility \
    && ln -s /bin/volatility /bin/volatility2

RUN mkdir -p /workspace/
VOLUME /workspace/
WORKDIR /workspace/

CMD /bin/bash
