//
//  DefinitionsView.swift
//  Sprek
//
//  Created by Eli Yazdi on 8/10/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import UIKit

class DefinitionsView: UITableView {

    override func draw(_ rect: CGRect) {
        let kArrowHeight: CGFloat = 30
        let context: CGContext? = UIGraphicsGetCurrentContext()
        let fillPath = UIBezierPath()
        fillPath.move(to: CGPoint(x: 0, y: bounds.origin.y + kArrowHeight))
        fillPath.addLine(to: CGPoint(x: bounds.size.width / 2 - (kArrowHeight / 2), y: kArrowHeight))
        fillPath.addLine(to: CGPoint(x: bounds.size.width / 2, y: 0))
        fillPath.addLine(to: CGPoint(x: bounds.size.width / 2 + (kArrowHeight / 2), y: kArrowHeight))
        fillPath.addLine(to: CGPoint(x: bounds.size.width, y: kArrowHeight))
        fillPath.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height))
        fillPath.addLine(to: CGPoint(x: 0, y: bounds.size.height))
        fillPath.close()
        context?.addPath(fillPath.cgPath)
        context?.setFillColor(UIColor.green.cgColor)
        context?.fillPath()
    }

}
