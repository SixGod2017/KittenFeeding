//
//  PingPongHud.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 9/19/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class PingPongHud : SKNode {
  weak var pingPongNavigation : PingPongNavigation?

  private var playerOneScoreNodeSKLabelNode = SKLabelNode(fontNamed: BASE_FONT_NAME)
  private var playerTwoScoreNodeSKLabelNode = SKLabelNode(fontNamed: BASE_FONT_NAME)
  private var messageNodeShadowLabelNode = ShadowLabelNode(fontNamed: BASE_FONT_NAME)

  private var quitButtonSKAControlSprite : TwoPaneButton!
  private var rematchButtonSKAControlSprite : TwoPaneButton!
  private var quitZeroPositionCGFloat: CGFloat = 0
  private var quitHidePositionCGFloat: CGFloat = 0

  private var showingRematchButtonIsOrNot = false

  private var showingQuitIsOrNot = true

  private(set) var playerOneScoreIntValue = 0
  private(set) var playerTwoScoreIntValue = 0

  private let highScoreColorSKColor = SKColor(red:1.00, green:1.00, blue:0.69, alpha:1.0)

  public func setup(size: CGSize) {
    addChild(playerOneScoreNodeSKLabelNode)
    addChild(playerTwoScoreNodeSKLabelNode)

    playerOneScoreNodeSKLabelNode.horizontalAlignmentMode = .center
    playerTwoScoreNodeSKLabelNode.horizontalAlignmentMode = .center

    playerOneScoreNodeSKLabelNode.fontSize = 50
    playerTwoScoreNodeSKLabelNode.fontSize = 50

    playerOneScoreNodeSKLabelNode.zPosition = 1000
    playerTwoScoreNodeSKLabelNode.zPosition = 1000

    playerOneScoreNodeSKLabelNode.position = CGPoint(x: size.width / 2 - 90, y: size.height * 0.9)
    playerTwoScoreNodeSKLabelNode.position = CGPoint(x: size.width / 2 + 90, y: size.height * 0.9)

    playerOneScoreNodeSKLabelNode.text = "\(playerOneScoreIntValue)"
    playerTwoScoreNodeSKLabelNode.text = "\(playerTwoScoreIntValue)"

    quitButtonSKAControlSprite = TwoPaneButton(text: "Quit", textSize: 20, size: CGSize(width: 95, height: 45))
    quitButtonSKAControlSprite.elevationCGFloat = 5

    let margin : CGFloat = 15
    quitZeroPositionCGFloat = quitButtonSKAControlSprite.size.height + margin
    quitZeroPositionCGFloat = -20
    quitButtonSKAControlSprite.position = CGPoint(x: size.width / 2 - quitButtonSKAControlSprite.size.width / 2, y: quitZeroPositionCGFloat)
    quitButtonSKAControlSprite.addTarget(self, selector: #selector(quitSelected), forControlEvents: .TouchUpInside)
    quitButtonSKAControlSprite.zPosition = 1000

    addChild(quitButtonSKAControlSprite)

    messageNodeShadowLabelNode.alpha = 0
    messageNodeShadowLabelNode.fontSize = 65
    messageNodeShadowLabelNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
    messageNodeShadowLabelNode.zPosition = 1000
    addChild(messageNodeShadowLabelNode)

    rematchButtonSKAControlSprite = TwoPaneButton(text: "Rematch?", textSize: 40, size: CGSize(width: 300, height: 70))
    rematchButtonSKAControlSprite.alpha = 0
    rematchButtonSKAControlSprite.addTarget(self, selector: #selector(rematchSelected), forControlEvents: .TouchUpInside)
    rematchButtonSKAControlSprite.position = CGPoint(x: size.width / 2 - rematchButtonSKAControlSprite.size.width / 2,
                                     y: rematchButtonSKAControlSprite.position.y - rematchButtonSKAControlSprite.size.height / 2 - margin * 2)
    rematchButtonSKAControlSprite.zPosition = 1000
    addChild(rematchButtonSKAControlSprite)
  }

  public func incrementPlayerOne() {
    showQuitButton()
    
    playerOneScoreIntValue += 1

    playerOneScoreNodeSKLabelNode.text = "\(playerOneScoreIntValue)"

    if playerOneScoreIntValue > playerTwoScoreIntValue {
      playerOneScoreNodeSKLabelNode.run(ColorAction().colorTransitionAction(fromColor: playerOneScoreNodeSKLabelNode.fontColor!, toColor: highScoreColorSKColor, duration: colorChangeDuration))
      playerOneScoreNodeSKLabelNode.run(SKAction.scale(to: 1.5, duration: 0.25))
    } else if playerTwoScoreIntValue <= playerOneScoreIntValue {
      playerTwoScoreNodeSKLabelNode.run(ColorAction().colorTransitionAction(fromColor: playerTwoScoreNodeSKLabelNode.fontColor!, toColor: SKColor.white, duration: colorChangeDuration))
      playerTwoScoreNodeSKLabelNode.run(SKAction.scale(to: 1.0, duration: 0.25))
    }
  }

  public func incrementPlayerTwo() {
    showQuitButton()

    playerTwoScoreIntValue += 1

    playerTwoScoreNodeSKLabelNode.text = "\(playerTwoScoreIntValue)"

    if playerTwoScoreIntValue > playerOneScoreIntValue {
      playerTwoScoreNodeSKLabelNode.run(ColorAction().colorTransitionAction(fromColor: playerTwoScoreNodeSKLabelNode.fontColor!, toColor: highScoreColorSKColor, duration: colorChangeDuration))
      playerTwoScoreNodeSKLabelNode.run(SKAction.scale(to: 1.5, duration: 0.25))
    } else if playerOneScoreIntValue <= playerTwoScoreIntValue {
      playerOneScoreNodeSKLabelNode.run(ColorAction().colorTransitionAction(fromColor: playerOneScoreNodeSKLabelNode.fontColor!, toColor: SKColor.white, duration: colorChangeDuration))
      playerOneScoreNodeSKLabelNode.run(SKAction.scale(to: 1.0, duration: 0.25))
    }
  }

    @objc func quitSelected() {
    if let nav = pingPongNavigation {
      nav.quitPressed()
    }
  }

    @objc func rematchSelected() {
    if let nav = pingPongNavigation {
      nav.restartPressed()
    }
  }

  func showQuitButton() {
    if !showingQuitIsOrNot {
      quitButtonSKAControlSprite.moveTo(y: quitZeroPositionCGFloat)
    }

    showingQuitIsOrNot = true
  }

  func hideQuitButton() {
    if showingQuitIsOrNot {
      quitButtonSKAControlSprite.moveTo(y: quitHidePositionCGFloat)
    }

    showingQuitIsOrNot = false
  }

  func showMessage(message : String) {
    showMessageIndefinitely(message: message)

    messageNodeShadowLabelNode.run(SKAction.fadeOut(withDuration: 2))
  }

  func showMessageIndefinitely(message : String) {
    messageNodeShadowLabelNode.text = message

    messageNodeShadowLabelNode.alpha = 1
  }

  func hideMessage() {
    messageNodeShadowLabelNode.run(SKAction.fadeOut(withDuration: 0.25))
  }

  func showRematchButton() {
    showingRematchButtonIsOrNot = true

    rematchButtonSKAControlSprite.alpha = 1
  }

  func hideRematchButton() {
    showingRematchButtonIsOrNot = false

    rematchButtonSKAControlSprite.alpha = 0
  }

  func resetScore() {
    playerOneScoreIntValue = 0
    playerTwoScoreIntValue = 0

    playerOneScoreNodeSKLabelNode.text = "\(playerOneScoreIntValue)"
    playerTwoScoreNodeSKLabelNode.text = "\(playerTwoScoreIntValue)"

    playerOneScoreNodeSKLabelNode.run(ColorAction().colorTransitionAction(fromColor: playerOneScoreNodeSKLabelNode.fontColor!, toColor: SKColor.white, duration: colorChangeDuration))
    playerOneScoreNodeSKLabelNode.run(SKAction.scale(to: 1.0, duration: 0.25))

    playerTwoScoreNodeSKLabelNode.run(ColorAction().colorTransitionAction(fromColor: playerTwoScoreNodeSKLabelNode.fontColor!, toColor: SKColor.white, duration: colorChangeDuration))
    playerTwoScoreNodeSKLabelNode.run(SKAction.scale(to: 1.0, duration: 0.25))
  }
}
