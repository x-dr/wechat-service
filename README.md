# Wechat-Service
```shell
docker run -it  --name wechat-service --rm  \
    -e TARGET_AUTO_RESTART="yes" \
    -e TARGET_CMD=wechat-start \
    -e VNC_PASSWORD=password \
    -p 8080:8080 -p 5555:5555 -p 5900:5900 \
    --add-host=dldir1.qq.com:127.0.0.1 \
    gindex/wechat-box:latest
```

# Wechat-Service-Bot

```shell
docker run -itd  --name wechat-service  \
    -e TARGET_AUTO_RESTART="yes" \
    -e TARGET_WECHAT_BOT="yes" \
    -e UPDATE_WECHAT_BOT="yes" \
    -e OPENAI_API_KEY="sk-xxxxxxxxxxx" \
    -e PROXY_API="https://api.openai.com/v1" \
    -e SERVER_HOST='127.0.0.1:5555' \
    -e TARGET_CMD=wechat-start \
    -e VNC_PASSWORD=password \
    -p 8080:8080 -p 5555:5555 -p 5900:5900 \
    --add-host=dldir1.qq.com:127.0.0.1 \
    gindex/wechat-box:latest
```


### 感谢

[@cixingguangming55555](https://github.com/cixingguangming55555/wechat-bot)

[@ChisBread](https://github.com/ChisBread/wechat-service)
