
import Foundation

class CustomVersion{
    class func isLastVersion() -> Bool {
        let infoDictionary = NSBundle.mainBundle().infoDictionary
        
        let currentAppVersion = infoDictionary!["CFBundleShortVersionString"] as! String
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        let appVersion = userDefault.stringForKey("appVersion")
        
        if appVersion == nil || appVersion != currentAppVersion {
            userDefault.setValue(currentAppVersion, forKey: "appVersion")
            return true
        }else{
            return false
        }
    }
}
