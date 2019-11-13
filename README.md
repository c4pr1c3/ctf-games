使用 `docker-compose` 一键搭建「漏洞练习环境」。

**注意检查 docker-compose.yml 中定义的各个容器服务的监听端口** ，如果遇到端口占用冲突报错可以自行修改监听端口为其他本机可用端口。

```bash
# 一次获取所有文件（包括所有子模块管理的文件）
git clone https://github.com/c4pr1c3/ctf-games.git --recursive

cd ctf-games

# （可选）单独更新子模块
git submodule init && git submodule update

# 启动 webgoat 系列服务
cd owasp/webgoat/ && docker-compose up -d

# 启动 juice-shop 及 shake-logger 服务
cd ../../owasp/juice-shop/ && docker-compose up -d
```

