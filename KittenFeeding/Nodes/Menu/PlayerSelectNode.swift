//
//  PlayerSelectNode.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 9/20/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class PlayerSelectNode : SKNode, MenuNodeAnimation {
  weak var menuNavigationAnyObject: MenuNavigation?

  private var startButtonSKAControlSprite: TwoPaneButton!

  private var catPongLabelSKNode: ShadowLabelNode!

  private var umbrella1SKSpriteNode: UmbrellaSprite!
  private var umbrella2SKSpriteNode: UmbrellaSprite!

  private var umbrella1ReferenceSKSpriteNode: AnimationReference!
  private var umbrella2ReferenceSKSpriteNode: AnimationReference!
  private var catPongLabelReferenceSKSpriteNode: AnimationReference!
  private var buttonStartReferenceSKSpriteNode: AnimationReference!

  private(set) var umbrellaLeftPositions : (umbrella1Left : CGPoint, umbrella2Left : CGPoint)!

  public func setup(sceneSize: CGSize) {
    umbrella1SKSpriteNode = childNode(withName: "umbrella1") as! UmbrellaSprite
    umbrella2SKSpriteNode = childNode(withName: "umbrella2") as! UmbrellaSprite

    startButtonSKAControlSprite = childNode(withName: "button-catpong-start") as! TwoPaneButton
    startButtonSKAControlSprite.addTarget(self, selector: #selector(startCatPong), forControlEvents: .TouchUpInside)

    catPongLabelSKNode = childNode(withName: "label-catpong") as! ShadowLabelNode

    umbrella1ReferenceSKSpriteNode = AnimationReference(zeroPosition: umbrella1SKSpriteNode.position.x,
                                          offscreenLeft: umbrella1SKSpriteNode.position.x - sceneSize.width,
                                          offscreenRight: sceneSize.width + umbrella1SKSpriteNode.position.x)

    umbrella2ReferenceSKSpriteNode = AnimationReference(zeroPosition: umbrella2SKSpriteNode.position.x,
                                            offscreenLeft: umbrella2SKSpriteNode.position.x - sceneSize.width,
                                            offscreenRight: sceneSize.width + umbrella2SKSpriteNode.position.x)

    catPongLabelReferenceSKSpriteNode = AnimationReference(zeroPosition: catPongLabelSKNode.position.x,
                                            offscreenLeft: catPongLabelSKNode.position.x - sceneSize.width,
                                            offscreenRight: sceneSize.width + catPongLabelSKNode.position.x)

    buttonStartReferenceSKSpriteNode = AnimationReference(zeroPosition: startButtonSKAControlSprite.position.x,
                                            offscreenLeft: startButtonSKAControlSprite.position.x - sceneSize.width,
                                            offscreenRight: sceneSize.width + startButtonSKAControlSprite.position.x)

    umbrellaLeftPositions = (umbrella1Left: umbrella1SKSpriteNode.position, umbrella2Left: umbrella2SKSpriteNode.position)

    navigateOutToRight(duration: 0)
  }

  func getName() -> String {
    return "playerSelect"
  }

  private func handleAlpha(node : SKNode, highlighted : Bool) {
    if highlighted {
      node.run(SKAction.fadeAlpha(to: 0.75, duration: 0.15))
    } else {
      node.run(SKAction.fadeAlpha(to: 1.0, duration: 0.15))
    }
  }

    @objc func startCatPong() {
    if let menu = menuNavigationAnyObject {
      menu.navigateToMultiplayerCatPong()
    }
  }

  func navigateOutToLeft(duration: TimeInterval) {

  }

  func navigateInFromLeft(duration: TimeInterval) {

  }

  func navigateOutToRight(duration: TimeInterval) {
    umbrella1SKSpriteNode.run(SKActionHelper.moveToEaseInOut(x: umbrella1ReferenceSKSpriteNode.offscreenRight, duration: duration))
    umbrella2SKSpriteNode.run(SKActionHelper.moveToEaseInOut(x: umbrella2ReferenceSKSpriteNode.offscreenRight, duration: duration))
    catPongLabelSKNode.run(SKActionHelper.moveToEaseInOut(x: catPongLabelReferenceSKSpriteNode.offscreenRight, duration: duration))
    startButtonSKAControlSprite.moveTo(x: buttonStartReferenceSKSpriteNode.offscreenRight, duration: duration)

    tempDisableButton(duration: 1)
  }

  func navigateInFromRight(duration: TimeInterval) {
    //umbrella1.run(SKActionHelper.moveToEaseInOut(x: umbrella1Reference.zeroPosition, duration: duration))
    //umbrella2.run(SKActionHelper.moveToEaseInOut(x: umbrella2Reference.zeroPosition, duration: duration))
    catPongLabelSKNode.run(SKActionHelper.moveToEaseInOut(x: catPongLabelReferenceSKSpriteNode.zeroPosition, duration: duration * 0.9))
    startButtonSKAControlSprite.moveTo(x: buttonStartReferenceSKSpriteNode.zeroPosition, duration: duration)

    tempDisableButton(duration: 1)
  }

  func tempDisableButton(duration : TimeInterval) {
    startButtonSKAControlSprite.isUserInteractionEnabled = false

    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
      self.startButtonSKAControlSprite.isUserInteractionEnabled = true
    }
  }
}
