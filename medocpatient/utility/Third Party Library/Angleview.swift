//
//  Angleview.swift
//  medocpatient
//
//  Created by Nishikant Ashok UMBARKAR on 28/5/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
public class AngleView: UIView {
    
    @IBInspectable public var fillColor: UIColor = .blue { didSet { setNeedsLayout() } }
    
    var points: [CGPoint] = [
        .zero,
        CGPoint(x: 0, y: 1),
        CGPoint(x: 1, y: 0.5),
        CGPoint(x: 1, y: 0)
        ] { didSet { setNeedsLayout() } }
    /*.zero,
     CGPoint(x: 1, y: 0),
     CGPoint(x: 1, y: 1),
     CGPoint(x: 0, y: 0.5)*/
    /*.zero,
     CGPoint(x: 0, y: 1),
     CGPoint(x: 1, y: 0.5),
     CGPoint(x: 1, y: 0)*/
    private lazy var shapeLayer: CAShapeLayer = {
        let _shapeLayer = CAShapeLayer()
        self.layer.insertSublayer(_shapeLayer, at: 0)
        return _shapeLayer
    }()
    
    override public func layoutSubviews() {
        shapeLayer.fillColor = fillColor.cgColor
        
        guard points.count > 2 else {
            shapeLayer.path = nil
            return
        }
        
        let path = UIBezierPath()
        
        path.move(to: convert(relativePoint: points[0]))
        for point in points.dropFirst() {
            path.addLine(to: convert(relativePoint: point))
        }
        path.close()
        
        shapeLayer.path = path.cgPath
    }
    
    private func convert(relativePoint point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x * bounds.width + bounds.origin.x, y: point.y * bounds.height + bounds.origin.y)
    }
}
