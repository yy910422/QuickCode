**集成了一些常用的第三方插件，使用方便，快速入门**

1. Alamofire
用HttpRequest对Alamofire进行了二次封装。首先实现HttpProtocol的协议方法。
```
class ViewController: HttpProtocol {
var eHttp = HttpRequest()
func didResponse(result: NSDictionary) {
print(result)
}
}
```
在需要进行网络数据请求的地方，添加如下代码即可：

```
//这是我本机的一个测试地址
let url = "http://172.16.10.86:8080/jeecms/webService/getAppChannelList/getAppChannelList"
eHttp.delegate = self
let params = ["channelId":"123"]
eHttp.Get(url, parameters: params)
```