//
//  AppDelegate.swift
//  Runner
//
//  Created by Dev, Rishabh on 14/08/2019.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
        ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

