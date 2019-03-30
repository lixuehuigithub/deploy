安装frp文档：

frp是解决内网服务可以外网访问的代理软件。

注：安装frp前，应先安装beeboxes(web 服务)

一、脚本安装说明：
    1.修改frpc.conf配置文件中子域名：（子域名禁止使用beeboxes）
       #Fill in the customer English name here
	subdomain=test
    2.修改frpc.conf配置文件中是否开启https：true 开启，false :不开启
       # Whether to open HTTPS: true/false
       https=false
	3.修改frpc.conf配置文件中是否开启app域名外网映射：true,开启  false ：不开启
       #App maps to the external network via domain name，default true.
	   app_mapping=false

    4. 检查子域名修改是否正确：more frpc.conf ，检查无误后，执行下一步

    5. 进入/home/frp目录下，执行安装脚本：sh install_frp_client.sh 
        注：如脚本install_frp_client.sh 没有执行权限，先执行授权命令：#chmod +x install_frp_client.sh 
    6. 验证是否安装成功：浏览器访问设置的[子域名.face.beeboxes.com]，端口假设为：80,如浏览器地址栏输入：test.face.beeboxes.com,如正常访问，说明安装成功。                 
