//
//  AppDelegate.swift
//  SwiftDemo
//
//  Created by Raviteja Ghanta on 18/05/16.
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

import UIKit
import LoginRadiusSDK
import GoogleSignIn
import Google


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate
{

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let sdk:LoginRadiusSDK = LoginRadiusSDK.instance();
        sdk.applicationLaunched(options: launchOptions);
        
        
        if LoginRadiusSDK.sharedInstance().enableGoogleNativeInHosted
        {
            var configureError: NSError?
            GGLContext.sharedInstance().configureWithError(&configureError)
            assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        
            GIDSignIn.sharedInstance().delegate = self
        }

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
        return LoginRadiusSDK.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    
        if let err = error
        {
            print("Error: \(err.localizedDescription)")
        }
        else
        {
            let idToken: String = user.authentication.accessToken
            LoginRadiusManager.sharedInstance().nativeGoogleLogin(withAccessToken: idToken, completionHandler: {(_ success: Bool, _ error: Error?) -> Void in
                if success {
                    print("successfully logged in with google")
                    if let lrtoken = UserDefaults.standard.object(forKey: "lrAccessToken") as? String
                    {
                        NotificationCenter.default.post(name: Notification.Name("userAuthenticated"), object: nil, userInfo: ["token":lrtoken])
                    }
                }
                else {
                    print("Error: \(String(describing: error?.localizedDescription))")
                }
            })
        }
    }


}

