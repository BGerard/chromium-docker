FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 unzip libgbm-dev \
    && apt-get install -y gconf-service libasound2 libatk1.0-0 libc6 \
        libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 \
        libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 \
        libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 \
        libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 \
        libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates \
        fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget dbus dbus-x11 \
    && rm -rf /var/lib/apt/lists/*

ADD  chrome.zip /tmp/chromium.zip

RUN unzip /tmp/chromium.zip -d /opt
COPY context/entrypoint.sh /opt/entrypoint.sh

RUN groupadd -r chromiumuser && useradd -r -g chromiumuser -G audio,video chromiumuser \
        && chown -R chromiumuser:chromiumuser /opt \
        && mkdir /home/chromiumuser \
        && chown -R chromiumuser:chromiumuser /home/chromiumuser

COPY context/dbus-system.conf /tmp/dbus-system.conf
RUN mkdir /var/run/dbus/ && \
    chown -R chromiumuser:chromiumuser /var/run/dbus/


USER chromiumuser
RUN chmod +x /opt/entrypoint.sh
ENTRYPOINT ["/opt/entrypoint.sh"]