//
//  KZLinkedConsole.swift
//
//  Created by Krzysztof Zabłocki on 05/12/15.
//  Copyright © 2015 pixle. All rights reserved.
//

import AppKit

var sharedPlugin: KZLinkedConsole?

class KZLinkedConsole: NSObject {

    internal struct Strings {
        static let linkedFileName = "KZLinkedFileName"
        static let linkedLine = "KZLinkedLine"
    }

    fileprivate var bundle: Bundle
    fileprivate let center = NotificationCenter.default

    override static func initialize() {
        swizzleMethods()
    }

    init(bundle: Bundle) {
        self.bundle = bundle

        super.init()
        center.addObserver(self, selector: NSSelectorFromString("didChange:"), name: NSNotification.Name(rawValue: "IDEControlGroupDidChangeNotificationName"), object: nil)
    }

    deinit {
        center.removeObserver(self)
    }

    func didChange(_ notification: Notification) {
        guard let consoleTextView = KZPluginHelper.consoleTextView(),
        let textStorage = consoleTextView.value(forKey: "textStorage") as? NSTextStorage else {
            return
        }
        consoleTextView.linkTextAttributes = [
            NSCursorAttributeName: NSCursor.pointingHand(),
            NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue
        ]
        textStorage.kz_isUsedInXcodeConsole = true
    }

    static func swizzleMethods() {
        guard let storageClass = NSClassFromString("NSTextStorage") as? NSObject.Type,
            let textViewClass = NSClassFromString("NSTextView") as? NSObject.Type else {
                return
        }
        
        do {
            try storageClass.jr_swizzleMethod(NSSelectorFromString("fixAttributesInRange:"), withMethod: NSSelectorFromString("kz_fixAttributesInRange:"))
            try textViewClass.jr_swizzleMethod(NSSelectorFromString("mouseDown:"), withMethod: NSSelectorFromString("kz_mouseDown:"))
        }
        catch {
            Swift.print("Swizzling failed")
        }
    }
}
