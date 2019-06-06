//
//  MultiplayerNode.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 5/10/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class MultiplayerNode : SKNode, MenuNodeAnimation {
  weak var menuNavigation : MenuNavigation?

  private var classicButtonTwoPaneButton: TwoPaneButton!
  private var catPongButtonTwoPaneButton: TwoPaneButton!
  private var classicHighSKLabelNodeScoreText : SKLabelNode!
  private var multiplayerTextShadowLabelNode: ShadowLabelNode!
  private var umbrella1UmbrellaSprite: UmbrellaSprite!
  private var umbrella2UmbrellaSprite: UmbrellaSprite!

  private var classicReferenceAnimationReference : AnimationReference!
  private var catPongReferenceAnimationReference : AnimationReference!
  private var classicHighScoreReferenceAnimationReference : AnimationReference!
  private var multiplayerReferenceAnimationReference : AnimationReference!
  private var umbrella1UmbrellaSpriteReferenceAnimationReference : AnimationReference!
  private var umbrella2UmbrellaSpriteReferenceAnimationReference : AnimationReference!

  var umbrella1UmbrellaSpriteLeftPositionCGPoint: CGPoint!
  var umbrella2UmbrellaSpriteLeftPositionCGPoint: CGPoint!

  private var umbrella1UmbrellaSpriteStartScaleCGFloatValue: CGFloat!
  private var umbrella2UmbrellaSpriteStartScaleCGFloatValue: CGFloat!

  private var umbrella1UmbrellaSpriteZeroYPositionCGFloatValue: CGFloat!
  private var umbrella2UmbrellaSpriteZeroYPositionCGFloatValue: CGFloat!

  private var umbrella1UmbrellaSpriteZeroAngleCGFloatValue: CGFloat!
  private var umbrella2UmbrellaSpriteZeroAngleCGFloatValue: CGFloat!

  private var selectedButtonSKAControlSprite: TwoPaneButton?

  private var player1ColorIndexIntValue = 0
  private var player2ColorIndexIntValue = 1

  func setup(sceneSize: CGSize) {
    classicButtonTwoPaneButton = childNode(withName: "button-multi-classic") as! TwoPaneButton!
    classicReferenceAnimationReference = AnimationReference(zeroPosition: classicButtonTwoPaneButton.position.x, offscreenLeft: -sceneSize.width, offscreenRight: sceneSize.width + classicButtonTwoPaneButton.position.x)

    catPongButtonTwoPaneButton = childNode(withName: "button-multi-cat-pong") as! TwoPaneButton!
    catPongReferenceAnimationReference = AnimationReference(zeroPosition: catPongButtonTwoPaneButton.position.x, offscreenLeft: -sceneSize.width, offscreenRight: sceneSize.width + catPongButtonTwoPaneButton.position.x)

    multiplayerTextShadowLabelNode = childNode(withName: "label-multiplayer") as! ShadowLabelNode!
    multiplayerReferenceAnimationReference = AnimationReference(zeroPosition: multiplayerTextShadowLabelNode.position.x, offscreenLeft: -sceneSize.width * 1.2 - multiplayerTextShadowLabelNode.position.x, offscreenRight: sceneSize.width * 1.2 + multiplayerTextShadowLabelNode.position.x)

    classicHighSKLabelNodeScoreText = childNode(withName: "label-multi-classic-highscore") as! SKLabelNode!
    classicHighScoreReferenceAnimationReference = AnimationReference(zeroPosition: classicHighSKLabelNodeScoreText.position.x, offscreenLeft: -sceneSize.width, offscreenRight: sceneSize.width + classicHighSKLabelNodeScoreText.position.x)
    classicHighSKLabelNodeScoreText.text = "\(UserDefaultsManager.sharedInstance.getClassicMultiplayerHighScore())"

    umbrella1UmbrellaSprite = childNode(withName: "umbrella-1") as! UmbrellaSprite!
    umbrella1UmbrellaSpriteReferenceAnimationReference = AnimationReference(zeroPosition: umbrella1UmbrellaSprite.position.x, offscreenLeft: -sceneSize.width, offscreenRight: sceneSize.width + umbrella1UmbrellaSprite.position.x)

    umbrella2UmbrellaSprite = childNode(withName: "umbrella-2") as! UmbrellaSprite!
    umbrella2UmbrellaSpriteReferenceAnimationReference = AnimationReference(zeroPosition: umbrella2UmbrellaSprite.position.x, offscreenLeft: -sceneSize.width, offscreenRight: sceneSize.width + umbrella2UmbrellaSprite.position.x)

    player1ColorIndexIntValue = UserDefaultsManager.sharedInstance.playerOneOneOnePalette
    player2ColorIndexIntValue = UserDefaultsManager.sharedInstance.playerTwoTwoTwoTwoPalette

    umbrella1UmbrellaSprite.updatePalette(palette: player1ColorIndexIntValue)
    umbrella2UmbrellaSprite.updatePalette(palette: player2ColorIndexIntValue)

    umbrella1UmbrellaSpriteZeroYPositionCGFloatValue = umbrella1UmbrellaSprite.position.y
    umbrella2UmbrellaSpriteZeroYPositionCGFloatValue = umbrella2UmbrellaSprite.position.y

    umbrella1UmbrellaSpriteStartScaleCGFloatValue = umbrella1UmbrellaSprite.yScale
    umbrella2UmbrellaSpriteStartScaleCGFloatValue = umbrella2UmbrellaSprite.yScale

    umbrella1UmbrellaSpriteZeroAngleCGFloatValue = umbrella1UmbrellaSprite.zRotation
    umbrella2UmbrellaSpriteZeroAngleCGFloatValue = umbrella2UmbrellaSprite.zRotation

    umbrella1UmbrellaSprite.clickAreaSKAControlSprite!.name = "umbrella1UmbrellaSprite"
    umbrella2UmbrellaSprite.clickAreaSKAControlSprite!.name = "umbrella2UmbrellaSprite"

    umbrella1UmbrellaSprite.clickAreaSKAControlSprite?.addTarget(self, selector: #selector(umbrellaTapped(_:)), forControlEvents: .TouchUpInside)
    umbrella2UmbrellaSprite.clickAreaSKAControlSprite?.addTarget(self, selector: #selector(umbrellaTapped(_:)), forControlEvents: .TouchUpInside)

    classicButtonTwoPaneButton.addTarget(self, selector: #selector(navigateToClassic), forControlEvents: .TouchUpInside)
    catPongButtonTwoPaneButton.addTarget(self, selector: #selector(navigateToCatPong), forControlEvents: .TouchUpInside)

    navigateOutToRight(duration: 0.0)
  }

  func getName() -> String {
    return "multiplayer"
  }

    @objc func umbrellaTapped(_ sender : UmbrellaSprite) {
    if sender.name == umbrella1UmbrellaSprite.clickAreaSKAControlSprite!.name {
      player1ColorIndexIntValue = ColorManager.sharedInstance.getNextColorPaletteIndex(player1ColorIndexIntValue)
      umbrella1UmbrellaSprite.updatePalette(palette: ColorManager.sharedInstance.getColorPalette(player1ColorIndexIntValue))

      UserDefaultsManager.sharedInstance.updatePlayerOneOneOnePalette(palette: player1ColorIndexIntValue)
    } else {
      player2ColorIndexIntValue = ColorManager.sharedInstance.getNextColorPaletteIndex(player2ColorIndexIntValue)
      umbrella2UmbrellaSprite.updatePalette(palette: ColorManager.sharedInstance.getColorPalette(player2ColorIndexIntValue))

      UserDefaultsManager.sharedInstance.updatePlayerTwoTwoTwoTwoPalette(palette: player2ColorIndexIntValue)
    }
  }

  public func playerOnePalette() -> ColorPalette {
    return ColorManager.sharedInstance.getColorPalette(player1ColorIndexIntValue)
  }

  public func playerTwoPalette() -> ColorPalette {
    return ColorManager.sharedInstance.getColorPalette(player2ColorIndexIntValue)
  }

  func navigateInFromRight(duration: TimeInterval) {
    classicButtonTwoPaneButton.moveTo(x: classicReferenceAnimationReference.zeroPosition, duration: duration)
    catPongButtonTwoPaneButton.moveTo(x: catPongReferenceAnimationReference.zeroPosition, duration: duration)

    multiplayerTextShadowLabelNode.run(SKActionHelper.moveToEaseInOut(x: multiplayerReferenceAnimationReference.zeroPosition, duration: duration))
    classicHighSKLabelNodeScoreText.run(SKActionHelper.moveToEaseInOut(x: classicHighScoreReferenceAnimationReference.zeroPosition, duration: duration * 1.05))
    umbrella1UmbrellaSprite.run(SKActionHelper.moveToEaseInOut(x: umbrella1UmbrellaSpriteReferenceAnimationReference.zeroPosition, duration: duration * 1.1))
    umbrella2UmbrellaSprite.run(SKActionHelper.moveToEaseInOut(x: umbrella2UmbrellaSpriteReferenceAnimationReference.zeroPosition, duration: duration * 1.15))

    tempDisableButton(duration: duration)
  }

  func navigateOutToRight(duration: TimeInterval) {
    umbrella1UmbrellaSprite.clickAreaSKAControlSprite?.isUserInteractionEnabled = false
    umbrella2UmbrellaSprite.clickAreaSKAControlSprite?.isUserInteractionEnabled = false

    selectedButtonSKAControlSprite = nil

    classicButtonTwoPaneButton.moveTo(x: classicReferenceAnimationReference.offscreenRight, duration: duration)
    catPongButtonTwoPaneButton.moveTo(x: catPongReferenceAnimationReference.offscreenRight, duration: duration)

    multiplayerTextShadowLabelNode.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.1),
      SKActionHelper.moveToEaseInOut(x: multiplayerReferenceAnimationReference.offscreenRight, duration: duration)
      ]))

    classicHighSKLabelNodeScoreText.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.1),
      SKActionHelper.moveToEaseInOut(x: classicHighScoreReferenceAnimationReference.offscreenRight, duration: duration)
      ]))

    umbrella1UmbrellaSprite.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.1),
      SKActionHelper.moveToEaseInOut(x: umbrella1UmbrellaSpriteReferenceAnimationReference.offscreenRight, duration: duration)
      ]))

    umbrella2UmbrellaSprite.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.1),
      SKActionHelper.moveToEaseInOut(x: umbrella2UmbrellaSpriteReferenceAnimationReference.offscreenRight, duration: duration)
      ]))

    tempDisableButton(duration: duration)
  }

  func navigateInFromLeft(duration: TimeInterval) {
    umbrella1UmbrellaSprite.clickAreaSKAControlSprite?.isUserInteractionEnabled = false
    umbrella2UmbrellaSprite.clickAreaSKAControlSprite?.isUserInteractionEnabled = false

    classicButtonTwoPaneButton.moveTo(x: classicReferenceAnimationReference.zeroPosition, duration: duration)
    catPongButtonTwoPaneButton.moveTo(x: catPongReferenceAnimationReference.zeroPosition, duration: duration)

    multiplayerTextShadowLabelNode.run(SKActionHelper.moveToEaseInOut(x: multiplayerReferenceAnimationReference.zeroPosition, duration: duration))
    classicHighSKLabelNodeScoreText.run(SKActionHelper.moveToEaseInOut(x: classicHighScoreReferenceAnimationReference.zeroPosition, duration: duration * 1.05))

    umbrella1UmbrellaSprite.run(SKAction.group([
      SKActionHelper.rotateToEaseInOut(angle: umbrella1UmbrellaSpriteZeroAngleCGFloatValue, duration: duration),
      SKAction.scaleX(to: -umbrella1UmbrellaSpriteStartScaleCGFloatValue, duration: duration),
      SKAction.scaleY(to: umbrella1UmbrellaSpriteStartScaleCGFloatValue, duration: duration),
      SKAction.move(to: CGPoint(x: umbrella1UmbrellaSpriteReferenceAnimationReference.zeroPosition, y: umbrella1UmbrellaSpriteZeroYPositionCGFloatValue), duration: duration)

      ]))

    umbrella2UmbrellaSprite.run(SKAction.group([
      SKActionHelper.rotateToEaseInOut(angle: umbrella2UmbrellaSpriteZeroAngleCGFloatValue, duration: duration),
      SKAction.scale(to: umbrella2UmbrellaSpriteStartScaleCGFloatValue, duration: duration),
      SKAction.move(to: CGPoint(x: umbrella2UmbrellaSpriteReferenceAnimationReference.zeroPosition, y: umbrella2UmbrellaSpriteZeroYPositionCGFloatValue), duration: duration)
      ]))

    tempDisableButton(duration: duration)
  }

  func navigateOutToLeft(duration: TimeInterval) {
    umbrella1UmbrellaSprite.clickAreaSKAControlSprite?.isUserInteractionEnabled = true
    umbrella2UmbrellaSprite.clickAreaSKAControlSprite?.isUserInteractionEnabled = true

    classicButtonTwoPaneButton.moveTo(x: classicReferenceAnimationReference.offscreenLeft, duration: duration)
    catPongButtonTwoPaneButton.moveTo(x: catPongReferenceAnimationReference.offscreenLeft, duration: duration)

    multiplayerTextShadowLabelNode.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.1),
      SKActionHelper.moveToEaseInOut(x: multiplayerReferenceAnimationReference.offscreenLeft, duration: duration)
      ]))

    classicHighSKLabelNodeScoreText.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.1),
      SKActionHelper.moveToEaseInOut(x: classicHighScoreReferenceAnimationReference.offscreenLeft, duration: duration)
      ]))

    umbrella1UmbrellaSprite.run(SKAction.group([
      SKActionHelper.rotateToEaseInOut(angle: 0, duration: duration * 0.8),
      SKAction.scaleX(to: -1, duration: duration * 0.5),
      SKAction.scaleY(to: 1, duration: duration * 0.5),
      SKActionHelper.moveToEasInOut(point: umbrella1UmbrellaSpriteLeftPositionCGPoint, duration: duration * 0.9)
      ]))

    umbrella2UmbrellaSprite.run(SKAction.group([
      SKActionHelper.rotateToEaseInOut(angle: 0, duration: duration * 0.8),
      SKAction.scale(to: 1, duration: duration * 0.5),
      SKActionHelper.moveToEasInOut(point: umbrella2UmbrellaSpriteLeftPositionCGPoint, duration: duration * 0.9)
      ]))

    tempDisableButton(duration: duration)
  }

    @objc func navigateToClassic() {
    if let navmenuNavigation = menuNavigation {
      navmenuNavigation.navigateToMultiplerClassic()
    }

    tempDisableButton(duration: 1)
  }
  
    @objc func navigateToCatPong() {
    if let navmenuNavigation = menuNavigation {
      navmenuNavigation.menuToPlayerSelect()
    }

    tempDisableButton(duration: 1)
  }

  func tempDisableButton(duration : TimeInterval) {
    classicButtonTwoPaneButton.isUserInteractionEnabled = false
    catPongButtonTwoPaneButton.isUserInteractionEnabled = false

    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
      self.classicButtonTwoPaneButton.isUserInteractionEnabled = true
      self.catPongButtonTwoPaneButton.isUserInteractionEnabled = true
    }
  }
}
