#!/bin/bash
# Tomcat 自动化部署脚本（CentOS Stream 9 + JDK8u491 + Tomcat8.5.100）
# 必须以 root 执行
set -e

# ================== 基础配置 ==================
JDK_PKG="jdk-8u491-linux-x64.tar.gz"
TOMCAT_VER="8.5.100"
INSTALL_DIR="/export/server"
JDK_HOME="${INSTALL_DIR}/jdk"
TOMCAT_HOME="${INSTALL_DIR}/tomcat8"

echo -e "\n==================== 开始部署 ====================\n"

# 1. 创建统一安装目录
echo "1. 创建安装目录：${INSTALL_DIR}"
mkdir -p ${INSTALL_DIR}

# 2. 检查 JDK 包是否存在
if [ ! -f "/home/${JDK_PKG}" ]; then
	    echo "错误：请先将 ${JDK_PKG} 上传到 /home 目录！"
	        exit 1
fi

# 3. 解压 JDK
echo "2. 解压 JDK 到 ${INSTALL_DIR}"
tar -zxf /home/${JDK_PKG} -C ${INSTALL_DIR}

# 4. 创建 JDK 软链接
echo "3. 创建 JDK 软链接"
ln -s ${INSTALL_DIR}/jdk1.8.0_491 ${JDK_HOME}

# 5. 配置 JDK 环境变量
echo "4. 配置 JDK 环境变量"
cat > /etc/profile.d/jdk.sh << EOF
export JAVA_HOME=${JDK_HOME}
export PATH=\$PATH:\$JAVA_HOME/bin
EOF
source /etc/profile.d/jdk.sh
echo "JDK 版本："
java -version

# 6. 创建 tomcat 用户
echo -e "\n5. 创建 tomcat 用户"
id tomcat >/dev/null 2>&1 || useradd tomcat

# 7. 下载/解压 Tomcat
echo "6. 部署 Tomcat ${TOMCAT_VER}"
cd /home/tomcat
if [ ! -f "apache-tomcat-${TOMCAT_VER}.tar.gz" ]; then
	    wget https://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VER}/bin/apache-tomcat-${TOMCAT_VER}.tar.gz
fi
tar -zxf apache-tomcat-${TOMCAT_VER}.tar.gz -C ${INSTALL_DIR}

# 8. 创建 Tomcat 软链接
echo "7. 创建 Tomcat 软链接"
ln -s ${INSTALL_DIR}/apache-tomcat-${TOMCAT_VER} ${TOMCAT_HOME}

# 9. 授权给 tomcat 用户
echo "8. 修改目录权限"
chown -R tomcat:tomcat ${INSTALL_DIR}/apache-tomcat-${TOMCAT_VER}
chown -R tomcat:tomcat ${TOMCAT_HOME}

# 10. 防火墙放行 8080
echo "9. 放行 8080 端口"
systemctl start firewalld
firewall-cmd --add-port=8080/tcp --permanent
firewall-cmd --reload

# 11. 启动 Tomcat
echo -e "\n10. 启动 Tomcat"
su - tomcat -c "${TOMCAT_HOME}/bin/startup.sh"

# 12. 完成提示
echo -e "\n==================== 部署成功 ===================="
echo "访问地址：http://服务器IP:8080"
echo "查看端口：netstat -anp | grep 8080"
echo "关闭命令：su - tomcat -c \"${TOMCAT_HOME}/bin/shutdown.sh\""
