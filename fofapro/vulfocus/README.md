## 纯净版 Kali 初始化基础环境

```bash
# ref: https://www.kali.org/docs/containers/installing-docker-on-kali/#installing-docker-ce-on-kali-linux
# 注意以下内容复制粘贴自上述 ref 链接，版本若有更新，请优先参考 ref 链接
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" | sudo tee /etc/apt/sources.list.d/docker.list 

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io jq

# 将当前用户添加到 docker 用户组，免 sudo 执行 docker 相关指令
# 重新登录 shell 生效
sudo usermod -a -G docker ${USER}

# 切换到 root 用户
sudo su -

# 使用国内 Docker Hub 镜像源（可选步骤）
# 国内 Docker Hub 镜像源可用性随时可能变化，请自测可用性
cat <<EOF > /etc/docker/daemon.json
{
  "registry-mirrors": [
    "https://docker.1ms.run",
    "https://docker.chenby.cn",
    "https://dockerhub.icu"
  ]
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

## 手动创建并导入测试场景

由于上游 `fofapro/vulfocus` 因不明原因下架了所有场景，感谢 [@Xuyan-cmd](https://github.com/Xuyan-cmd) 给 [B站视频教程：网络安全(2021) 综合实验](https://www.bilibili.com/video/BV1p3411x7da) 手动打了一个补丁：按照视频教程里使用的网络环境，手动重建了靶标网络场景。

1. 在 `vulfocus` 的本地管理页面的左侧导航菜单里依次找到并点击：`场景管理`、`环境编排管理`。
2. 在主窗口中点击 `添加场景` ，选择 `创建编排模式` 。上传 `DMZ.zip` 场景文件，点击 `保存` 。
3. 查看并使用 `download_dmz_imgs.sh` 下载 `DMZ.zip` 场景中使用到的镜像。
4. 在 `镜像管理` 页面，通过【添加】按钮，手动将 `DMZ.zip` 场景中使用到的镜像导入到 `vulfocus` 的本地镜像数据库中，确保 `DMZ.zip` 中用到的镜像的状态都是 **已导入** 。
5. 返回 `环境编排管理` 页面，点击刚才创建成功的场景缩略图上的 `发布` 按钮。此时，系统可能会提示 `正在下载`，稍后再返回该页面查看场景状态，直到状态变为 `已发布` 。如果状态一直是 `正在下载` ，请检查是否有镜像未导入成功。
6. 发布成功后，通过左侧导航菜单里的 `场景` 找到刚才发布成功的场景缩略图，点击后进入场景详情页面，点击 `启动场景` 。
7. 注意访问地址不是场景详情页面上显示的，请自行替换为 `vulfocus管理页面的访问IP:场景详情页面上显示的端口号` 。

## 常用的 docker 排错命令

```bash
# 查看当前安装的 docker 使用的是否 docker 官方维护的社区版
apt policy docker-ce

# 查看当前安装的 docker 是否 Linux 发行版维护的版本（不推荐使用该版本）
apt policy docker.io

# 检查 docker 版本号
docker version

# 检查 docker 启用的镜像源等重要运行时配置信息
docker info

# 查看容器内报错信息
# 通常配合 管道操作符和 grep 一起使用，以便快速定位报错信息
docker logs <container_name>

# 查看所有容器
docker ps -a
```

## FAQ

**以下内容仅供参考，具体问题具体分析。如果没有遇到相关问题，请不要盲目使用以下方法进行操作。**

1. vulfocus 管理页面无法访问？

请检查容器内的报错信息，可能是因为容器内部的服务未正常启动导致的。可以通过 `docker logs <vulfocus 容器名>` 查看容器内的日志信息。

目前已知对于 `docker-ce 28.0.1` 版本，`vulfocus` 容器内的 `redis-server` 服务无法正常启动，可以通过以下方式解决：

```bash
# redis-server 服务无法正常启动的报错信息如下
# redis.exceptions.ConnectionError: Error 111 connecting to 127.0.0.1:6379. Connection refused.

# 假设 vulfocus 容器名为 vulfocus-vul-focus-1
docker exec -it vulfocus-vul-focus-1 redis-server

```


2. `DMZ.zip` 场景中部分容器无法正常启动？

目前已知在 `kali 2024.2` 版本中，`DMZ.zip` 场景中的 `weblogic` 漏洞靶标容器无法正常启动，报错信息如下：

```
library initialization failed - unable to allocate file descriptor table - out of memoryAborted (core dumped)
```

可以将以下配置代码片段添加到 `/etc/docker/daemon.json` 。

```json
"default-ulimits": {
    "nofile": {
        "Name": "nofile",
        "Hard": 64000,
        "Soft": 64000
    }
}
```

然后重启 docker 服务。

```bash
sudo systemctl restart docker
```

除此之外，如果使用 `docker.io` 可能会遇到容器启动报错 `IP 地址分配冲突` 错误，请卸载 `docker.io` ，改用 `docker-ce` 。具体安装方法请参考 [Installing Docker on Kali Linux](https://www.kali.org/docs/containers/installing-docker-on-kali/#installing-docker-ce-on-kali-linux)  里的 `Installing docker-ce on Kali Linux` 一节安装方法。

3. 如果 `docker-compose.yml` 中定义的 `vulfocus` 镜像无法访问或无法下载。

请 `git clone https://github.com/c4pr1c3/vulfocus.git` 到本地，进入 `vulfocus` 目录，执行以下命令：

```bash
docker build -t c4pr1c3/vulfocus:v0.3 .
```

