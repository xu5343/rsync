#!/bin/bash

# 禁用有问题的仓库
yum-config-manager --disable mratwork-ius-archive mratwork-mariadb

# 查找并注释掉包含 iuscommunity 和 mratwork-mariadb 的配置
for repo in /etc/yum.repos.d/*.repo; do
  sed -i '/iuscommunity/s/^/#/' "$repo"
  sed -i '/mratwork-mariadb/s/^/#/' "$repo"
done

# 确保 CentOS Base Repo 指向有效镜像
cat <<EOL > /etc/yum.repos.d/CentOS-Base.repo
[base]
name=CentOS-\$releasever - Base - mirrors.aliyun.com
baseurl=http://mirrors.aliyun.com/centos/\$releasever/os/\$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7

[updates]
name=CentOS-\$releasever - Updates - mirrors.aliyun.com
baseurl=http://mirrors.aliyun.com/centos/\$releasever/updates/\$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7

[extras]
name=CentOS-\$releasever - Extras - mirrors.aliyun.com
baseurl=http://mirrors.aliyun.com/centos/\$releasever/extras/\$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
EOL

# 清理缓存并重新生成缓存
yum clean all
yum makecache

# 使用 yum 配置管理器确保无问题仓库被启用
yum-config-manager --enable base updates extras

# 提示用户成功完成操作
echo "仓库配置修复完成。你现在可以尝试安装软件包了。"

# 测试安装软件包
yum install -y rsync epel-release sshpass parallel
