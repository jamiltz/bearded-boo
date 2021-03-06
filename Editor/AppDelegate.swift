import UIKit
import AVFoundation

let kFBAppId = "789449301118942"

let kSyncGatewayWebSocketSupport = false
typealias CBLDoc = CBLDocument

let kGreenColor = UIColor(hue:0.405, saturation:0.716, brightness:0.663, alpha: 1)
let kRedColor = UIColor(hue:0.980, saturation:0.861, brightness:0.816, alpha: 1)
let kBlueColor = UIColor(hue:0.587, saturation:1.000, brightness:1.000, alpha: 1)
let kCardSelectedColor = UIColor(hue:0.591, saturation:0.457, brightness:0.996, alpha: 1)
let kBlueIconColor = UIColor(hue:0.596, saturation:0.675, brightness:0.976, alpha: 1)
let kGrayColor = UIColor(hue:0.000, saturation:0.000, brightness:0.745, alpha: 1)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backgroundSessionCompletionHandler: (() -> ())?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // only for debugging
//        NSUserDefaults.standardUserDefaults().removeObjectForKey("user_id")
        
        let shouldSkipLogin = CouchbaseManager.shared.currentUserId
        
        if shouldSkipLogin != nil {
//            let sb = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//            window?.rootViewController = sb.instantiateViewControllerWithIdentifier("NavVC") as UINavigationController
        }
        
        let notificationSettings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
//        let profile = Profile.profileInDatabase(shouldSkipLogin!)
        
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)

        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        var characterSet: NSCharacterSet = NSCharacterSet(charactersInString: "<>")
        
        var deviceTokenString: String = (deviceToken.description as NSString)
            .stringByTrimmingCharactersInSet(characterSet)
            .stringByReplacingOccurrencesOfString(" " , withString: "") as String
        
        println(deviceTokenString)
        
        if let id = CouchbaseManager.shared.currentUserId {
            if let profile = Profile.profileInDatabase(id) {
                profile.device_token = deviceTokenString
                if profile.save(nil) {
                    println("device token saved")
                }
            }
        }
        
    }
    
    // can stay here
    func applicationDidBecomeActive(application: UIApplication) {
        FBAppCall.handleDidBecomeActive()
    }
    
    // can stay here
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
    }
    
    func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void) {
        self.backgroundSessionCompletionHandler = completionHandler
        VideoDownloader.shared()
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

