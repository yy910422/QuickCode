import Foundation

//普通网络请求协议
@objc protocol HttpProtocol{
    func didResponse(result:NSDictionary)
    optional func didResponseByNSData(result:NSData)
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
    
    func getResponseByNSData(method:Method,url:String,parameters:[String:NSObject]){
        request(method, url, parameters: parameters, encoding: ParameterEncoding.URLEncodedInURL, headers: nil).responseJSON { (response) -> Void in
            guard let _ = response.data else{
                return
            }
        self.delegate?.didResponseByNSData!(response.data!)
        }
    }


}