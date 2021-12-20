## 纯净版 Kali 初始化基础环境

```bash
sudo apt update && sudo apt install -y docker.io docker-compose jq

# 将当前用户添加到 docker 用户组，免 sudo 执行 docker 相关指令
# 重新登录 shell 生效
sudo usermod -a -G docker ${USER}

# 切换到 root 用户
sudo su -

# 使用中科大 Docker Hub 镜像源
cat <<EOF > /etc/docker/daemon.json
{
  "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn/"]
}
EOF

# 重启 docker 守护进程
systemctl restart docker

# 提前拉取 vulfocus 镜像
docker pull vulfocus/vulfocus:latest
```

## 快速上手

对 [fofapro/vulfocus](https://github.com/fofapro/vulfocus) 提供傻瓜式二次封装，启动方式简化为

1. `bash start.sh`
2. 选择对外提供访问 `vulfocus-web` 的 IP
3. 打开浏览器访问 admin / admin
4. 【镜像管理】-【镜像管理】-【一键同步】
5. 搜索感兴趣的漏洞镜像-【下载】
6. 镜像下载完毕后，【首页】，随时可以【启动】镜像开始漏洞攻防实验了

**Tested only on**

- Kali Rolling 2021.2
- Kali Rolling 2021.4


