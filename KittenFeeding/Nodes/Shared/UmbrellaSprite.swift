//
//  UmbrellaSprite.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 8/30/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import Foundation
import SpriteKit

class UmbrellaSprite : SKSpriteNode, Palettable {
  private var umbrellaTopSKSpriteNode: SKSpriteNode!
  private var umbrellaBottomSKSpriteNode: SKSpriteNode!

  private var destinationCGPoint: CGPoint!
  private var easingCGFloat: CGFloat = 0.1
  public var minimumHeightCGFloat: CGFloat = 0

  private var isPingPongIsOrNot = false
  var clickAreaSKAControlSprite: SKAControlSprite?

  private(set) var paletteColorPalette: ColorPalette!

  public init() {
    super.init(texture: nil, color: .clear, size: .zero)
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    clickAreaSKAControlSprite = SKAControlSprite(texture: nil, color: .clear, size: .zero)
    clickAreaSKAControlSprite?.zPosition = 1000
    
    addChild(clickAreaSKAControlSprite!)
    clickAreaSKAControlSprite!.isUserInteractionEnabled = true

    if let playerNumberIntValue = userData?.value(forKey: "catpongplayer") as? Int {
      if playerNumberIntValue == 1 {
        configure(palette: ColorManager.sharedInstance.getColorPalette(UserDefaultsManager.sharedInstance.playerOneOneOnePalette))
      } else {
        configure(palette: ColorManager.sharedInstance.getColorPalette(UserDefaultsManager.sharedInstance.playerTwoTwoTwoTwoPalette))
      }
    } else {
      configure(palette: ColorManager.sharedInstance.getColorPalette(0))
    }
  }

  convenience init(palette: ColorPalette, pingPong : Bool = false) {
    self.init()

    configure(palette: palette, pingPong: pingPong)
  }

  private func configure(palette : ColorPalette, pingPong : Bool = false) {
    self.paletteColorPalette = palette
    isPingPongIsOrNot = pingPong

    let topSKSpriteNode = SKSpriteNode(imageNamed: "umbrellaTop")
    let bottomSKSpriteNode = SKSpriteNode(imageNamed: "umbrellaBottom")

    if pingPong {
      topSKSpriteNode.physicsBody = SKPhysicsBody(texture: topSKSpriteNode.texture!, size: topSKSpriteNode.size)
      anchorPoint = CGPoint(x: 1, y: 0.5)

      topSKSpriteNode.physicsBody?.mass = 500
    } else {
      let path = UIBezierPath()
      path.move(to: CGPoint(x: -topSKSpriteNode.size.width / 2, y: -topSKSpriteNode.size.height / 2))
      path.addLine(to: CGPoint(x: 0, y: topSKSpriteNode.size.height / 2))
      path.addLine(to: CGPoint(x: topSKSpriteNode.size.width / 2, y: -topSKSpriteNode.size.height / 2))
      path.addLine(to: CGPoint(x: topSKSpriteNode.size.width / 2 - 10, y: -topSKSpriteNode.size.height / 2))
      path.addLine(to: CGPoint(x: 0, y: topSKSpriteNode.size.height / 2 - 10))
      path.addLine(to: CGPoint(x: -topSKSpriteNode.size.width / 2 + 10, y: -topSKSpriteNode.size.height / 2))
      path.close()

      topSKSpriteNode.physicsBody = SKPhysicsBody(edgeLoopFrom: path.cgPath)
    }
    
    topSKSpriteNode.physicsBody?.isDynamic = false
    topSKSpriteNode.physicsBody?.categoryBitMask = UmbrellaCategory
    topSKSpriteNode.physicsBody?.contactTestBitMask = RainDropCategory
    topSKSpriteNode.physicsBody?.restitution = 0.9

    topSKSpriteNode.zPosition = 4
    bottomSKSpriteNode.zPosition = 2

    topSKSpriteNode.colorBlendFactor = 1
    bottomSKSpriteNode.colorBlendFactor = 1

    topSKSpriteNode.color = palette.umbrellaTopColor
    bottomSKSpriteNode.color = palette.umbrellaBottomColor

    if xScale > 0 {
      topSKSpriteNode.position.y = (topSKSpriteNode.size.height + bottomSKSpriteNode.size.height) / 2
    } else {
      topSKSpriteNode.position.y = (topSKSpriteNode.size.height + bottomSKSpriteNode.size.height) / 2 - 5
    }

    bottomSKSpriteNode.position.x -= bottomSKSpriteNode.size.width / 4

    addChild(topSKSpriteNode)
    addChild(bottomSKSpriteNode)

    umbrellaTopSKSpriteNode = topSKSpriteNode
    umbrellaBottomSKSpriteNode = bottomSKSpriteNode

    if clickAreaSKAControlSprite != nil {
      clickAreaSKAControlSprite?.size = CGSize(width: topSKSpriteNode.size.width, height: topSKSpriteNode.size.width)
      clickAreaSKAControlSprite?.position.y += 50
    }
  }

  public func updatePosition(point : CGPoint) {
    position = point
    destinationCGPoint = point
  }

  public func setDestination(destination : CGPoint) {
    self.destinationCGPoint = destination

    if destination.y < minimumHeightCGFloat {
      self.destinationCGPoint.y = minimumHeightCGFloat
    }

    let distanceToDistance = Distance(p1: self.destinationCGPoint, p2: self.position)

    if isPingPongIsOrNot {
      easingCGFloat = 0.3
    } else {
      if distanceToDistance > UIScreen.main.bounds.width / 2 {
        easingCGFloat = 0.04
      } else if distanceToDistance > UIScreen.main.bounds.width / 4 {
        easingCGFloat = 0.1
      } else {
        easingCGFloat = 0.15
      }

      if self.destinationCGPoint.y == minimumHeightCGFloat && position.y <= (minimumHeightCGFloat + 5) {
        easingCGFloat = max(easingCGFloat / 2, 0.04)
      }
    }
  }

  public func update(deltaTime : TimeInterval) {
    let distanceCGFloatValue = sqrt(pow((destinationCGPoint.x - position.x), 2) + pow((destinationCGPoint.y - position.y), 2))

    if(distanceCGFloatValue > 1) {
      let directionXCGFloatValue = (destinationCGPoint.x - position.x)
      let directionYCGFloatValue = (destinationCGPoint.y - position.y)

      position.x += directionXCGFloatValue * easingCGFloat
      position.y += directionYCGFloatValue * easingCGFloat
    } else {
      position = destinationCGPoint
    }
  }

  public func getVelocity() -> CGVector {
    return CGVector(dx: destinationCGPoint.x - position.x, dy: destinationCGPoint.y - position.y)
  }

  public func getHeight() -> CGFloat {
    return umbrellaTopSKSpriteNode.size.height + umbrellaBottomSKSpriteNode.size.height
  }

  public func updatePalette(palette: ColorPalette) {
    self.paletteColorPalette = palette

    umbrellaTopSKSpriteNode.run(ColorAction().colorTransitionAction(fromColor: umbrellaTopSKSpriteNode.color, toColor: palette.umbrellaTopColor, duration: colorChangeDuration))
    umbrellaBottomSKSpriteNode.run(ColorAction().colorTransitionAction(fromColor: umbrellaBottomSKSpriteNode.color, toColor: palette.umbrellaBottomColor, duration: colorChangeDuration))
  }

  public func updatePalette(palette : Int) {
    self.paletteColorPalette = ColorManager.sharedInstance.getColorPalette(palette)

    updatePalette(palette: self.paletteColorPalette)
  }

  func makeDynamic() {
    umbrellaTopSKSpriteNode.physicsBody = nil
    physicsBody = SKPhysicsBody(circleOfRadius: 15)
    physicsBody?.categoryBitMask = CatCategory
    physicsBody?.contactTestBitMask = WorldFrameCategory
    physicsBody?.density = 0.01
    physicsBody?.linearDamping = 1
    physicsBody?.isDynamic = true
    physicsBody?.allowsRotation = true

    zPosition = 0
    umbrellaTopSKSpriteNode.zPosition = 1
    umbrellaBottomSKSpriteNode.zPosition = 0
  }

  override func isEqual(_ object: Any?) -> Bool {
    return super.isEqual(object) || umbrellaTopSKSpriteNode.isEqual(object) || umbrellaBottomSKSpriteNode.isEqual(object)
  }
}
