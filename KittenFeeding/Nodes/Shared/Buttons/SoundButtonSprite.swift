//
//  SoundButton.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 5/3/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class SoundButtonSprite : SKSpriteNode {
  private let baseSpriteNode = SKSpriteNode(imageNamed: "speaker-base")
  private let lowSpriteNode = SKSpriteNode(imageNamed: "speaker-low")
  private let mediumSpriteNode = SKSpriteNode(imageNamed: "speaker-medium")
  private let highSpriteNode = SKSpriteNode(imageNamed: "speaker-high")

  private var soundOnOrNot = true

  init(size: CGSize) {
    super.init(texture: nil, color: .clear, size: size)
    configuration()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configuration()
  }

  func setMutedSoundButtonSpriteStatus() {
    lowSpriteNode.run(SKAction.moveTo(x: -size.width / 7, duration: 0.03))
    mediumSpriteNode.run(SKAction.moveTo(x: -size.width / 6, duration: 0.07))
    highSpriteNode.run(SKAction.moveTo(x: -size.width / 5, duration: 0.12))
  }

  func setPlayingSoundButtonSpriteStatus() {
    lowSpriteNode.run(SKAction.moveTo(x: 0, duration: 0.03))
    mediumSpriteNode.run(SKAction.moveTo(x: 0, duration: 0.1))
    highSpriteNode.run(SKAction.moveTo(x: 0, duration: 0.15))
  }

  func setPressedSoundButtonSpriteStatus() {
    let actionSKAction = SKAction.scale(to: 1, duration: 0.15)

    baseSpriteNode.run(actionSKAction)
    lowSpriteNode.run(actionSKAction)
    mediumSpriteNode.run(actionSKAction)
    highSpriteNode.run(actionSKAction)
  }

  func setReleased(toggleState : Bool) {
    let actionSKAction = SKAction.scale(to: 0.75, duration: 0.15)

    baseSpriteNode.run(actionSKAction)
    lowSpriteNode.run(actionSKAction)
    mediumSpriteNode.run(actionSKAction)
    highSpriteNode.run(actionSKAction)

    if toggleState {
      soundOnOrNot = !soundOnOrNot

      if soundOnOrNot {
        setPlayingSoundButtonSpriteStatus()
      } else {
        setMutedSoundButtonSpriteStatus()
      }
    }
  }

  private func configuration() {
    baseSpriteNode.zPosition = 0

    baseSpriteNode.setScale(0.75)
    lowSpriteNode.setScale(0.75)
    mediumSpriteNode.setScale(0.75)
    highSpriteNode.setScale(0.75)

    addChild(baseSpriteNode)
    addChild(lowSpriteNode)
    addChild(mediumSpriteNode)
    addChild(highSpriteNode)
  }
}
