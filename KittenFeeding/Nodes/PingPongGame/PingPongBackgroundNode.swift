//
//  PingPongBackgroundNode.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 9/19/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class PingPongBackgroundNode : SKNode {
  public func setup(frame : CGRect, deadZone : CGFloat, playerOnePalette : ColorPalette, playerTwoPalette : ColorPalette) {
    let leftGroundSKShapeNode = SKShapeNode(rect: CGRect(origin: CGPoint(), size: CGSize(width: 30, height: frame.height)))
    leftGroundSKShapeNode.fillColor = playerOnePalette.groundColor
    leftGroundSKShapeNode.strokeColor = SKColor.clear
    leftGroundSKShapeNode.zPosition = 1
    addChild(leftGroundSKShapeNode)

    let rightGroundSKShapeNode = SKShapeNode(rect: CGRect(origin: CGPoint(x: frame.width - 30, y: 0), size: CGSize(width: 30, height: frame.height)))
    rightGroundSKShapeNode.fillColor = playerTwoPalette.groundColor
    rightGroundSKShapeNode.strokeColor = SKColor.clear
    rightGroundSKShapeNode.zPosition = 1
    addChild(rightGroundSKShapeNode)

    let leftLineSKShapeNode = SKShapeNode(rect: CGRect(origin: CGPoint(), size: CGSize(width: 2.5, height: frame.height)))
    leftLineSKShapeNode.fillColor = SKColor.white
    leftLineSKShapeNode.position = CGPoint(x: frame.midX - deadZone - 65, y: 0)
    leftLineSKShapeNode.zPosition = 1
    addChild(leftLineSKShapeNode)

    let midLineSKShapeNode = SKShapeNode(rect: CGRect(origin: CGPoint(), size: CGSize(width: 5, height: frame.height)))
    midLineSKShapeNode.fillColor = SKColor.white
    midLineSKShapeNode.position = CGPoint(x: frame.midX - 2.5, y: 0)
    midLineSKShapeNode.zPosition = 1
    addChild(midLineSKShapeNode)

    let rightLineSKShapeNode = SKShapeNode(rect: CGRect(origin: CGPoint(), size: CGSize(width: 2.5, height: frame.height)))
    rightLineSKShapeNode.fillColor = SKColor.white
    rightLineSKShapeNode.position = CGPoint(x: frame.midX + deadZone + 65, y: 0)
    rightLineSKShapeNode.zPosition = 1
    addChild(rightLineSKShapeNode)

    let circleShapeSKShapeNode = SKShapeNode(circleOfRadius: 75)
    circleShapeSKShapeNode.fillColor = SKColor(red:0.38, green:0.60, blue:0.65, alpha:1.0)
    circleShapeSKShapeNode.position = CGPoint(x: frame.midX, y: frame.midY)
    circleShapeSKShapeNode.lineWidth = 5
    circleShapeSKShapeNode.zPosition = 1
    addChild(circleShapeSKShapeNode)
  }
}
