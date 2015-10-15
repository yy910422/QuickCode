# **集成了一些常用的第三方插件，使用方便，快速入门**
### 其中Objective-C部分大多数类库，出自StrongX大神视频中，大家可以去网站学习原汁原味：http://www.hcxy.me/course/48
####一、swift部分
##### 1. Alamofire
##### 用HttpRequest对Alamofire进行了二次封装。首先实现HttpProtocol的协议方法。
```swift
class ViewController: HttpProtocol {
	var eHttp = HttpRequest()
	func didResponse(result: NSDictionary) {
		print(result)
	}
}
```
#####在需要进行网络数据请求的地方，添加如下代码即可：

```swift
//这是我本机的一个测试地址
let url = "http://172.16.10.86:8080/jeecms/webService/getAppChannelList/getAppChannelList"
eHttp.delegate = self
let params = ["channelId":"123"]
eHttp.Get(url, parameters: params)
```
#####2、Siren
#####App检查版本更新的库，可自定义提示语言，支持多国语言。使用时添加到Appdelegate下的didFinishLaunchingWithOptions中即可，代码如下：
```swift
let siren = Siren.sharedInstance
        // Required
        siren.appID = "376771144" // For this example, we're using the iTunes Connect App (https://itunes.apple.com/us/app/itunes-connect/id376771144?mt=8)
        // Optional - Defaults to .Option
        //        siren.alertType = .Option // or .Force, .Skip, .None
         // Optional - Can set differentiated Alerts for Major, Minor, Patch, and Revision Updates (Must be called AFTER siren.alertType, if you are using siren.alertType)
         // Optional
        siren.delegate = self
        // Optional
        siren.debugEnabled = true;
        siren.majorUpdateAlertType = .Option
        siren.minorUpdateAlertType = .Option
        siren.patchUpdateAlertType = .Option
        siren.revisionUpdateAlertType = .Option
        //设置提示语言格式为中文
        siren.forceLanguageLocalization = SirenLanguageType.ChineseSimplified
        // Optional - Sets all messages to appear in Spanish. Siren supports many other languages, not just English and Spanish.
        //        siren.forceLanguageLocalization = .Spanish
        // Required
        siren.checkVersion(.Immediately)
    }
 ```
#####3、SweetAlert
#####非常好看的AlertView提示框，使用方法如下：
 ```swift
 SweetAlert().showAlert("这是标题", subTitle: "swift移动架构设计demo", style: AlertStyle.Warning)
 ```
#####4、IQKeyboardManagerSwift
#####这是一个全局的键盘事件监听的第三方库，swift编写（现在swift的开源库越来越多了～～），这个要感谢QQ群：小波说雨燕（8477435）的某位群友提供的帖子（但是忘记是哪位帅哥了！！！），这个也是全局的单例模式，在任何一个地方设置都会全局有效，一般写到AppDeleage里就可以了，使用方法如下：
```swift
   let manager = IQKeyboardManager.sharedManager()
        manager.enable = true
        manager.shouldResignOnTouchOutside = true
        manager.shouldToolbarUsesTextFieldTintColor = true
        manager.enableAutoToolbar = true
```
#####5、SWXMLHash
#####这是一个swift解析XML的类库，使用起来比较简单，但是真的要一层层的剥剥剥，代码如下：
```swift
let xml = SWXMLHash.parse(result)
        print(xml["soap:Envelope"]["soap:Body"]["ns1:getAppContentListResponse"]["return"].element!)
```
#####6、CustomTools
#####啊哈哈，这个是我自己写的，里面有个CustomVersion类，用来判断当前版本是否是最新版本的，很简单，就不贴代码啦
