# Wechat-Service
```shell
docker run -it  --name wechat-service --rm  \
    -e TARGET_AUTO_RESTART="yes" \
    -e TARGET_CMD=wechat-start \
    -e VNC_PASSWORD=password \
    -p 8080:8080 -p 5555:5555 -p 5900:5900 \
    --add-host=dldir1.qq.com:127.0.0.1 \
    wechat-box:latest
```