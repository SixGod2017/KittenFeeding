//
//  RainDropSprite.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 5/24/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class RainDropSprite : SKSpriteNode {
  var scaleCGFloat: CGFloat!

  convenience init(scale: CGFloat) {
    var rainDropTextureSKTexture: SKTexture

    switch scale {
    case 2:
      rainDropTextureSKTexture = SKTexture(imageNamed: "medium_rain_drop")
    case 3:
      rainDropTextureSKTexture = SKTexture(imageNamed: "large_rain_drop")
    default:
      rainDropTextureSKTexture = SKTexture(imageNamed: "rain_drop")
    }

    self.init(texture: rainDropTextureSKTexture, color: RAIN_COLOR, size: rainDropTextureSKTexture.size())
    colorBlendFactor = 1
    self.scaleCGFloat = scale
  }

  override init(texture: SKTexture?, color: UIColor, size: CGSize) {
    super.init(texture: texture, color: color, size: size)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    texture = SKTexture(imageNamed: "rain_drop")
    colorBlendFactor = 1
    color = RAIN_COLOR
  }

  func addPhysics() {
    physicsBody = SKPhysicsBody(texture: texture!, size: size)
    physicsBody?.categoryBitMask = RainDropCategory
    physicsBody?.contactTestBitMask = WorldFrameCategory
    physicsBody?.density = 0.5
  }
}
