## 纯净版 Kali 初始化基础环境

```bash
sudo apt update && sudo apt install -y docker.io docker-compose jq

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
    "https://docker.mirrors.sjtug.sjtu.edu.cn/",
    "https://mirror.baidubce.com/",
    "https://dockerproxy.com/"
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
2. 在主窗口中点击 `添加场景` ，选择 `创建编排模式` 。
3. 在打开的拓扑编辑页面，点击 `上传` 按钮，选择当前目录下的 `DMZ.zip` 上传。
4. 返回 `环境编排管理` 页面，点击刚才创建成功的场景缩略图上的 `发布` 按钮。
5. 发布成功后，通过左侧导航菜单里的 `场景` 找到刚才发布成功的场景缩略图，点击后进入场景详情页面，点击 `启动场景` 。
6. 注意访问地址不是场景详情页面上显示的，请自行替换为 `vulfocus管理页面的访问IP:场景详情页面上显示的端口号` 。

