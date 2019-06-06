//
//  CurtainSprite.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 5/2/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class CurtainSprite : SKShapeNode {

  public static func newInstance(size: CGSize) -> CurtainSprite {
    let pathUIBezierPath = UIBezierPath()
    pathUIBezierPath.move(to: CGPoint())
    pathUIBezierPath.addLine(to: CGPoint(x: size.width, y: 0))
    pathUIBezierPath.addLine(to: CGPoint(x: size.width, y: size.height))
    pathUIBezierPath.addLine(to: CGPoint(x: 0, y: size.height))

    let spikeCountIntValue = 15

    let spikeDepthCGFloatValue = size.height / CGFloat(spikeCountIntValue)

    for i in 0...(spikeCountIntValue + 1) {
      let height = spikeDepthCGFloatValue * CGFloat(i)

      pathUIBezierPath.addLine(to: CGPoint(x: spikeDepthCGFloatValue * 0.45, y: size.height - height))
      pathUIBezierPath.addLine(to: CGPoint(x: 0, y: size.height - height - spikeDepthCGFloatValue / 2))
    }

    return CurtainSprite(path: pathUIBezierPath.cgPath)
  }
}
