# 快速上手

请查看 `docker-compose.yml` 中定义的服务监听端口号，然后访问对应的地址即可。

默认监听 `127.0.0.1` 以避免靶机服务暴露在公开网络上，请根据自己的需求修改 `docker-compose.yml` 文件。

## WebGoat

当前 `docker-compose.yml` 中包含了 `WebGoat 7.1`、`WebGoat 8.0.0.M25` 和 `WebGoat 最新版` 的配置。

- `WebGoat 7` 和 `WebGoat 8.x` 的访问入口地址均为： `/WebGoat/attack` 而不是 `/` 。

## WebWolf

当前 `docker-compose.yml` 中包含了 2 个 `WebWolf` 的配置，访问地址均为： `/WebWolf`，区别在于 2 个服务的监听端口号不同，请以 `docker-compose.yml` 中定义为准。

- `WebGoat 最新版` 内置了 `WebWolf`，请使用 `WebGoat 最新版` 已注册用户身份和凭据访问。
- `WebGoat 8.0.0.M25` 外挂并连通了 `WebWolf` 容器，请使用 `WebGoat 8.0.0.M25` 已注册用户身份和凭据访问。

## 常见问题

1. 用同一个浏览器访问不同版本的 `WebGoat` 靶机服务时，可能会出现登录状态混乱的情况，建议使用不同的浏览器或者隐身模式访问不同的 `WebGoat` 靶机。如果已经出现登录状态混乱导致无法正常访问，请清除浏览器缓存、或打开开发者工具手动清理当前页面的所有 `Cookies` 或者使用隐身模式访问。
2. `docker ps` 显示容器状态为 `Up` 但是无法访问服务，可能是服务正在初始化中，请稍等片刻再尝试访问。
3. `WebGoat` 和 `WebWolf` 服务中的部分网页代码里存在链接硬编码问题，所以需要手动修改链接地址，例如：`http://127.0.0.1:9090/WebWolf/landing` 修改为 `http://192.168.56.105:9091/WebWolf/landing`。
4. 建议使用不同内核的浏览器访问靶机服务（`WebGoat`）和攻击服务（`WebWolf`），例如：`Google Chrome` 访问靶机服务，`Firefox` 访问攻击服务。
5. `docker logs` 查看容器日志，可能会有一些有用的信息。如果发现异常，且通过重启容器无法解决问题，请尝试删除容器并重新创建。`docker compose up -d --force-recreate` 可以彻底清除容器（包括容器内已有数据）并重新创建。

