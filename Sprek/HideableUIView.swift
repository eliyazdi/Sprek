//
//  HideableUIView.swift
//  Albert Bori, modified for Swift 3 by Eli Yazdi
//
//  Created by Albert Bori on 5/19/15.
//  Copyright (c) 2015 Albert Bori under the MIT license.
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

private var hideableUIViewConstraintsKey: UInt8 = 0

extension UIView {
    
    private var _parentConstraintsReference: [AnyObject]! {
        get {
            return objc_getAssociatedObject(self, &hideableUIViewConstraintsKey) as? [AnyObject] ?? []
        }
        set {
            objc_setAssociatedObject(self,
                                     &hideableUIViewConstraintsKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func hideView() {
        self.isHidden = true
        
        if let parentView = self.superview, _parentConstraintsReference.count == 0 {
            //get the constraints that involve this view to re-add them when the view is shown
                for parentConstraint in parentView.constraints {
                    if parentConstraint.firstItem === self || parentConstraint.secondItem === self {
                        _parentConstraintsReference.append(parentConstraint)
                    }
                }
            parentView.removeConstraints(_parentConstraintsReference as! [NSLayoutConstraint])
        }
    }
    
    func showView() {
        //reapply any previously existing constraints
        if let parentView = self.superview {
            parentView.addConstraints(_parentConstraintsReference as! [NSLayoutConstraint])
        }
        
        _parentConstraintsReference = []
        self.isHidden = false
    }
}
