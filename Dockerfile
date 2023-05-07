FROM debian:bullseye-slim


#deps
RUN sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apt-get update && apt-get install -y \
    git net-tools curl wget supervisor fluxbox xterm \
    x11vnc novnc xvfb xdotool \
    gnupg2 software-properties-common \
    ttf-wqy-microhei locales procps vim sudo git

#install wine
RUN dpkg --add-architecture i386 && apt-get full-upgrade -y \
    && wget -nc https://dl.winehq.org/wine-builds/winehq.key \
    && apt-key add winehq.key && add-apt-repository 'deb https://mirrors.tuna.tsinghua.edu.cn/wine-builds/debian/ bullseye main' \
    && apt-get update && apt-get install -y --install-recommends winehq-stable 


#app user
RUN useradd -m app && usermod -aG sudo app && echo 'app ALL=(ALL) NOPASSWD:ALL' >> //etc/sudoers \
    && sed -ie 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/g' /etc/locale.gen \
    && locale-gen \
    && apt-get clean && rm -rf /var/lib/apt/lists/* 
     


# Install Node.js 18
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs 
#envs
ENV DISPLAY_WIDTH=1280 \
    DISPLAY_HEIGHT=720 \
    DISPLAY=:0.0 \
    LANG=zh_CN.UTF-8 \
    LANGUAGE=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
    WINEPREFIX=/home/app/.wine \
    NPM_CONFIG_PREFIX=/home/app/.npm-global

#files
COPY root/ /

EXPOSE 8080



# Allow app user to install global npm packages
RUN mkdir /home/app/.npm-global \
    && chown -R app:app /home/app/.npm-global \
    && echo 'export PATH=$PATH:/home/app/.npm-global/bin' >> /home/app/.bashrc \
    && npm install pm2 -g

USER app
WORKDIR /home/app

RUN sudo chmod 777 /*.sh \
    && sudo chmod 777 /init/*.sh \
    && sudo chmod 777 /bin/inject-dll /bin/inject-monitor /bin/wechat-monitor /bin/wechat-start /bin/startbot


# init with GUI
RUN bash -c 'nohup /entrypoint.sh 2>&1 &' \
    && sleep 6 \
    &&  /init.sh \
    && sudo rm /tmp/.X0-lock \
    && (sudo chown -R app:app /drive_c && cp -r /drive_c/* /home/app/.wine/drive_c/ || true)



#settings
ENTRYPOINT ["/entrypoint.sh"]
