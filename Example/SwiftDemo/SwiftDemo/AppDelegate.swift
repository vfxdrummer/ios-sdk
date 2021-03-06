//
//  AppDelegate.swift
//  SwiftDemo
//
//  Created by LoginRadius Development Team on 18/05/16.
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

import UIKit
import LoginRadiusSDK

/* Google Native SignIn
import GoogleSignIn
import Google
*/

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
/* Google Native SignIn
, GIDSignInDelegate
*/
{

    var window: UIWindow?
    
    // This is up to the customer to configure their app to enable native social logins.
    static var useGoogleNative:Bool = false
    static var useTwitterNative:Bool = false
    static var useFacebookNative:Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let sdk:LoginRadiusSDK = LoginRadiusSDK.instance();
        sdk.applicationLaunched(options: launchOptions);

        /* Google Native SignIn
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
    
        GIDSignIn.sharedInstance().delegate = self
        */

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool
    {
        var canOpen = false
        
        /* Google Native SignIn
        canOpen = (canOpen || GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation]))
        */
        
    
        canOpen = (canOpen || LoginRadiusSDK.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation]))
    
        return canOpen
    }

    /* Google Native SignIn
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    
        if let err = error
        {
            print("Error: \(err.localizedDescription)")
        }
        else
        {
            let idToken: String = user.authentication.accessToken

            LoginRadiusSocialLoginManager.sharedInstance().nativeGoogleLogin(withAccessToken: idToken, completionHandler: {( data ,  error) -> Void in
                NotificationCenter.default.post(name: Notification.Name("userAuthenticatedFromNativeGoogle"), object: nil, userInfo: ["data":data as Any,"error":error as Any])

            })
        }
    }
    */


}

