//
//  PopoverViewDelegate.swift
//  RBCCompanion
//
//  Created by Vaibhav Jain on 06/07/23.
//  Copyright © 2023 Mayuri Patil. All rights reserved.
//

import Foundation

public protocol iOSPopoverViewDelegate: AnyObject {
    func popoverView(_ popver: iOSPopoverView, index: Int, selectedText: String, sourceIndex: Int)
    func popoverViewDismiss(index: Int)
}
