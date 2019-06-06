//
//  TitleMenuNode.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 5/3/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class TitleMenuNode : SKNode, MenuNodeAnimation {
  weak var menuNavigationAnyObject: MenuNavigation?

  var singlePlayerButtonSKAControlSprite: TwoPaneButton!
  var multiPlayerButtonSKAControlSprite: TwoPaneButton!
  var titleTextSKShadowLabelNodeNode: ShadowLabelNode!
  var tutorialButtonSKAControlSprite: TwoPaneButton!

  var selectedButtonSKAControlSprite: TwoPaneButton?

  var sizeCGSizeValue: CGSize!

  var singlePlayerReferenceAnimationReference: AnimationReference!
  var multiPlayerReferenceAnimationReference: AnimationReference!
  var titleReferenceAnimationReference: AnimationReference!
  var tutorialReferenceAnimationReference: AnimationReference!


  func setup(sceneSize: CGSize) {
    self.sizeCGSizeValue = sceneSize

    titleTextSKShadowLabelNodeNode = childNode(withName: "rain-cat-logo") as! ShadowLabelNode
    titleTextSKShadowLabelNodeNode.text = "KITTENFEEDING"
    singlePlayerButtonSKAControlSprite = childNode(withName: "button-single-player") as! TwoPaneButton
    multiPlayerButtonSKAControlSprite = childNode(withName: "button-multi-player") as! TwoPaneButton
    tutorialButtonSKAControlSprite = childNode(withName: "button-tutorial") as! TwoPaneButton


    singlePlayerReferenceAnimationReference = AnimationReference(zeroPosition: singlePlayerButtonSKAControlSprite.position.x, offscreenLeft: -sizeCGSizeValue.width - singlePlayerButtonSKAControlSprite.position.x, offscreenRight: sizeCGSizeValue.width)

    multiPlayerReferenceAnimationReference = AnimationReference(zeroPosition: multiPlayerButtonSKAControlSprite.position.x, offscreenLeft: -sizeCGSizeValue.width - multiPlayerButtonSKAControlSprite.position.x, offscreenRight: sizeCGSizeValue.width)

    titleReferenceAnimationReference = AnimationReference(zeroPosition: titleTextSKShadowLabelNodeNode.position.x, offscreenLeft: -sizeCGSizeValue.width - titleTextSKShadowLabelNodeNode.position.x, offscreenRight: sizeCGSizeValue.width)

    tutorialReferenceAnimationReference = AnimationReference(zeroPosition: tutorialButtonSKAControlSprite.position.x, offscreenLeft: -sizeCGSizeValue.width - tutorialButtonSKAControlSprite.position.x, offscreenRight: sizeCGSizeValue.width)

    singlePlayerButtonSKAControlSprite.addTarget(self, selector: #selector(singlePlayerButtonClicked(_:)), forControlEvents: .TouchUpInside)
    multiPlayerButtonSKAControlSprite.addTarget(self, selector: #selector(multiplayerButtonClicked(_:)), forControlEvents: .TouchUpInside)
    tutorialButtonSKAControlSprite.addTarget(self, selector: #selector(tutorialButtonClicked), forControlEvents: .TouchUpInside)
  }

    @objc func singlePlayerButtonClicked(_ sender : TwoPaneButton) {
    if let menusinglePlayerButtonClicked = menuNavigationAnyObject {
      selectedButtonSKAControlSprite = singlePlayerButtonSKAControlSprite

      menusinglePlayerButtonClicked.menuToSinglePlayer()
    }

    tempDisableButton(duration: 1)
  }

    @objc func multiplayerButtonClicked(_ sender : TwoPaneButton) {
    if let menusinglePlayerButtonClicked = menuNavigationAnyObject {
      selectedButtonSKAControlSprite = multiPlayerButtonSKAControlSprite

      menusinglePlayerButtonClicked.menuToMultiplayer()
    }

    tempDisableButton(duration: 1)
  }

    @objc func tutorialButtonClicked() {
    if let menusinglePlayerButtonClicked = menuNavigationAnyObject {
      menusinglePlayerButtonClicked.navigateToTutorial()
    }
  }

  func getName() -> String {
    return "title"
  }

  func navigateInFromLeft(duration: TimeInterval) {
    var delayTimeInterval: TimeInterval = 0.05
    var waitTimeInterval: TimeInterval = 0.1

    if duration == 0 {
      delayTimeInterval = 0
      waitTimeInterval = 0
    }

    if let buttonSelectedButtonSKAControlSprite = selectedButtonSKAControlSprite {
      if singlePlayerButtonSKAControlSprite.isEqual(to: buttonSelectedButtonSKAControlSprite) {
        singlePlayerButtonSKAControlSprite.moveTo(x: singlePlayerReferenceAnimationReference.zeroPosition, duration: duration)
        multiPlayerButtonSKAControlSprite.moveTo(x: multiPlayerReferenceAnimationReference.zeroPosition, duration: duration, delay: delayTimeInterval)
        tutorialButtonSKAControlSprite.moveTo(x: tutorialReferenceAnimationReference.zeroPosition, duration: duration, delay: delayTimeInterval * 2)
      } else {
        multiPlayerButtonSKAControlSprite.moveTo(x: multiPlayerReferenceAnimationReference.zeroPosition, duration: duration)
        singlePlayerButtonSKAControlSprite.moveTo(x: singlePlayerReferenceAnimationReference.zeroPosition, duration: duration, delay: delayTimeInterval)
        tutorialButtonSKAControlSprite.moveTo(x: tutorialReferenceAnimationReference.zeroPosition, duration: duration, delay: delayTimeInterval * 2)
      }
    } else {
      multiPlayerButtonSKAControlSprite.moveTo(x: multiPlayerReferenceAnimationReference.zeroPosition, duration: duration)
      singlePlayerButtonSKAControlSprite.moveTo(x: singlePlayerReferenceAnimationReference.zeroPosition, duration: duration)
      tutorialButtonSKAControlSprite.moveTo(x: tutorialReferenceAnimationReference.zeroPosition, duration: duration)
    }

    titleTextSKShadowLabelNodeNode.run(SKAction.sequence([
      SKAction.wait(forDuration: waitTimeInterval),
      SKActionHelper.moveToEaseInOut(x: titleReferenceAnimationReference.zeroPosition, duration: duration)
      ]))

    selectedButtonSKAControlSprite = nil

    tempDisableButton(duration: duration)
  }

  func navigateInFromRight(duration: TimeInterval) {
    //Not implemented
  }

  func navigateOutToLeft(duration: TimeInterval) {
    var delayTimeInterval: TimeInterval = 0.05
    var waitTimeInterval: TimeInterval = 0.1

    if duration == 0 {
      delayTimeInterval = 0
      waitTimeInterval = 0
    }

    if let buttonSelectedButtonSKAControlSprite = selectedButtonSKAControlSprite {
      if singlePlayerButtonSKAControlSprite.isEqual(to: buttonSelectedButtonSKAControlSprite) {
        singlePlayerButtonSKAControlSprite.moveTo(x: singlePlayerReferenceAnimationReference.offscreenLeft, duration: duration)
        multiPlayerButtonSKAControlSprite.moveTo(x: multiPlayerReferenceAnimationReference.offscreenLeft, duration: duration, delay: delayTimeInterval)
        tutorialButtonSKAControlSprite.moveTo(x: tutorialReferenceAnimationReference.offscreenLeft, duration: duration, delay: delayTimeInterval * 2)
      } else {
        multiPlayerButtonSKAControlSprite.moveTo(x: multiPlayerReferenceAnimationReference.offscreenLeft, duration: duration)
        singlePlayerButtonSKAControlSprite.moveTo(x: singlePlayerReferenceAnimationReference.offscreenLeft, duration: duration, delay: delayTimeInterval)
        tutorialButtonSKAControlSprite.moveTo(x: tutorialReferenceAnimationReference.offscreenLeft, duration: duration, delay: delayTimeInterval * 2)
      }
    } else {
      multiPlayerButtonSKAControlSprite.moveTo(x: multiPlayerReferenceAnimationReference.offscreenLeft, duration: duration)
      singlePlayerButtonSKAControlSprite.moveTo(x: singlePlayerReferenceAnimationReference.offscreenLeft, duration: duration)
      tutorialButtonSKAControlSprite.moveTo(x: tutorialReferenceAnimationReference.offscreenLeft, duration: duration)
    }


    titleTextSKShadowLabelNodeNode.run(SKAction.sequence([
      SKAction.wait(forDuration: waitTimeInterval),
      SKActionHelper.moveToEaseInOut(x: titleReferenceAnimationReference.offscreenLeft, duration: duration)
      ]))

    tempDisableButton(duration: duration)
  }

  func navigateOutToRight(duration: TimeInterval) {}

  func tempDisableButton(duration : TimeInterval) {
    singlePlayerButtonSKAControlSprite.isUserInteractionEnabled = false
    multiPlayerButtonSKAControlSprite.isUserInteractionEnabled = false

    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
      self.singlePlayerButtonSKAControlSprite.isUserInteractionEnabled = true
      self.multiPlayerButtonSKAControlSprite.isUserInteractionEnabled = true
    }
  }
}
