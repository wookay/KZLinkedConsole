//
//  NSObject_Extension.swift
//
//  Created by Krzysztof Zabłocki on 05/12/15.
//  Copyright © 2015 pixle. All rights reserved.
//

import Foundation

extension NSObject {
    class func pluginDidLoad(_ bundle: Bundle) {
        let appName = Bundle.main.infoDictionary?["CFBundleName"] as? NSString
        if appName == "Xcode" {
        	if sharedPlugin == nil {
        		sharedPlugin = KZLinkedConsole(bundle: bundle)
        	}
        }
    }
}
