import Foundation

//普通网络请求协议
protocol HttpProtocol{
    func didResponse(result:NSDictionary)
}

class HttpRequest: NSObject {
    var delegate:HttpProtocol?
    
      //MARK:尚未完成封装
    enum HttpRequestErrorType:ErrorType {
        case 服务器没有响应
    }
    
    //MARK:get网络请求
    func Get(url:String,parameters:[String:NSObject]) {
        //let par = ["a":"b"]
      request(.GET, url, parameters: parameters, encoding: ParameterEncoding.URLEncodedInURL, headers: nil).responseJSON { (response) -> Void in
            guard let _ = response.response else{
                return
            }
        print(response.data)
            self.delegate?.didResponse(response.result.value as! NSDictionary)
        }
        
    }
    
    func Post(url:String,parameters:[String:NSObject]){
        request(.POST, url, parameters: parameters, encoding: ParameterEncoding.URLEncodedInURL, headers: nil).responseJSON { (response) -> Void in
            guard let _ = response.response else{
                return
            }
            self.delegate?.didResponse(response.result.value as! NSDictionary)
        }
    }


}