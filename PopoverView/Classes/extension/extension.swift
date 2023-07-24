//
//  extension.swift
//  Pods-PopoverView_Example
//
//  Created by Vaibhav Jain on 19/07/23.
//

import Foundation

extension UIView {
    var left: CGFloat {
        get {
            return frame.origin.x
        } set {
            frame.origin.x = newValue
        }
    }
    
    var right: CGFloat {
        get {
            return frame.maxX
        } set {
            frame.origin.x = newValue - frame.width
        }
    }
    
    var top: CGFloat {
        get {
            return frame.origin.y
        } set {
            frame.origin.y = newValue
        }
    }
    
    var bottom: CGFloat {
        get {
            return frame.maxY
        } set {
            frame.origin.y = newValue - frame.height
        }
    }
    
    var width: CGFloat {
        get {
            return frame.width
        } set {
            frame.size.width = newValue
        }
    }
    
    var height: CGFloat {
        get {
            return frame.height
        } set {
            frame.size.height = newValue
        }
    }
    
    var size: CGSize {
        get {
            return frame.size
        } set {
            frame.size = newValue
        }
    }
    
    var centerX: CGFloat {
        get {
            return center.x
        } set {
            center.x = newValue
        }
    }
    
    var centerY: CGFloat {
        get {
            return center.y
        } set {
            center.y = newValue
        }
    }
    
    func getConvertedPoint(_ targetView: UIView, baseView: UIView?) -> CGPoint {
        var pnt = targetView.frame.origin
        if nil == targetView.superview {
            return pnt
        }
        var superView = targetView.superview
        while superView != baseView {
            pnt = superView!.convert(pnt, to: superView!.superview)
            if nil == superView!.superview {
                break
            } else {
                superView = superView!.superview
            }
        }
        return superView!.convert(pnt, to: baseView)
    }
}
extension StringProtocol where Index == String.Index {
    func index(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
}
