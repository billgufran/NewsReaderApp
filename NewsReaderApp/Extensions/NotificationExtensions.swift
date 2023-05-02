//
//  NotificationExtensions.swift
//  NewsReaderApp
//
//  Created by Muhammad Fikri Bill Gufran on 2/5/23.
//

import Foundation

extension NSNotification.Name {
    static let addReadingList: NSNotification.Name = NSNotification.Name(rawValue: "kAddReadingList")
    static let deleteReadingList: NSNotification.Name = NSNotification.Name(rawValue: "kDeleteReadingList")
}
