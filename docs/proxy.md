## Set HTTP proxy
In case your build machine is located in a subnet that needs HTTP(s) Proxy to access external Internet,
you can set the following HTTP proxy
Example:
1. Set proxy in /etc/profile.d/proxy.sh or ~/.bashrc
```
export http_proxy="http://<domain>:<port>"
export https_proxy="https://<domain>:<port>"
export no_proxy="localhost"
```
2. Set proxy in /etc/apt/apt.conf
```
Acquire::http::Proxy "http://<domain>:<port>";
Acquire::https::Proxy "https://<domain>:<port>";
```
