//
//  SwiftEncryptionsPlugin.swift
//  Runner
//
//  Created by Dev, Rishabh on 14/08/2019.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import Flutter
import UIKit

public class SwiftEncryptionsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "encryptions", binaryMessenger: registrar.messenger())
        let instance = SwiftEncryptionsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result("iOS " + UIDevice.current.systemVersion)
    }
}

