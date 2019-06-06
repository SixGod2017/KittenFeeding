//
//  CreditsNode.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 9/20/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class CreditsNode : SKNode, MenuNodeAnimation {
  weak var menuNavigation : MenuNavigation?

  var marcButtonCreditLabelButtonSprite: CreditLabelButtonSprite!
  var jeffButtonCreditLabelButtonSprite: CreditLabelButtonSprite!
  var bensoundButtonCreditLabelButtonSprite: CreditLabelButtonSprite!
  var cathrynButtonCreditLabelButtonSprite: CreditLabelButtonSprite!
  var morganButtonCreditLabelButtonSprite: CreditLabelButtonSprite!
  var lauraButtonCreditLabelButtonSprite: CreditLabelButtonSprite!
  var logoButtonLogoButtonSprite: LogoButtonSprite!

  var developmentLabelSKLabelNode: SKLabelNode!
  var designLabelSKLabelNode: SKLabelNode!
  var musicLabelSKLabelNode: SKLabelNode!

  var developReferenceAnimationReference: AnimationReference!
  var designReferenceAnimationReference: AnimationReference!
  var musicReferenceAnimationReference: AnimationReference!
  var logoReferenceAnimationReference: AnimationReference!

  var developLabelReferenceAnimationReference: AnimationReference!
  var musicLabelReferenceAnimationReference: AnimationReference!
  var designLabelReferenceAnimationReference: AnimationReference!

    @objc func creditButtonDitButtonClicked(_ sender : CreditLabelButtonSprite) {
    menuNavigation?.navigateToUrl(url: sender.getUrlToStringValue()!)
  }

    @objc func logoClicked(_ sender : LogoButtonSprite) {
        menuNavigation?.navigateToUrl(url: sender.getUrlToSting()!)
  }

  func getName() -> String {
    return "credits"
  }

  func setup(sceneSize: CGSize) {
    marcButtonCreditLabelButtonSprite = childNode(withName: "button-marc") as! CreditLabelButtonSprite
    marcButtonCreditLabelButtonSprite.addTarget(self, selector: #selector(creditButtonDitButtonClicked(_:)), forControlEvents: .TouchUpInside)

    jeffButtonCreditLabelButtonSprite = childNode(withName: "button-jeff") as! CreditLabelButtonSprite
    jeffButtonCreditLabelButtonSprite.addTarget(self, selector: #selector(creditButtonDitButtonClicked(_:)), forControlEvents: .TouchUpInside)

    bensoundButtonCreditLabelButtonSprite = childNode(withName: "button-bensound") as! CreditLabelButtonSprite
    bensoundButtonCreditLabelButtonSprite.addTarget(self, selector: #selector(creditButtonDitButtonClicked(_:)), forControlEvents: .TouchUpInside)

    cathrynButtonCreditLabelButtonSprite = childNode(withName: "button-cathryn") as! CreditLabelButtonSprite
    cathrynButtonCreditLabelButtonSprite.addTarget(self, selector: #selector(creditButtonDitButtonClicked(_:)), forControlEvents: .TouchUpInside)

    morganButtonCreditLabelButtonSprite = childNode(withName: "button-morgan") as! CreditLabelButtonSprite
    morganButtonCreditLabelButtonSprite.addTarget(self, selector: #selector(creditButtonDitButtonClicked(_:)), forControlEvents: .TouchUpInside)

    lauraButtonCreditLabelButtonSprite = childNode(withName: "button-laura") as! CreditLabelButtonSprite
    lauraButtonCreditLabelButtonSprite.addTarget(self, selector: #selector(creditButtonDitButtonClicked(_:)), forControlEvents: .TouchUpInside)

    logoButtonLogoButtonSprite = childNode(withName: "button-logo") as! LogoButtonSprite
    logoButtonLogoButtonSprite.addTarget(self, selector: #selector(logoClicked(_:)), forControlEvents: .TouchUpInside)

    developmentLabelSKLabelNode = childNode(withName: "label-development") as! SKLabelNode
    designLabelSKLabelNode = childNode(withName: "label-design") as! SKLabelNode
    musicLabelSKLabelNode = childNode(withName: "label-music") as! SKLabelNode

    developReferenceAnimationReference = AnimationReference(zeroPosition: marcButtonCreditLabelButtonSprite.position.x, offscreenLeft: marcButtonCreditLabelButtonSprite.position.x - sceneSize.width, offscreenRight: sceneSize.width + marcButtonCreditLabelButtonSprite.position.x)

    designReferenceAnimationReference = AnimationReference(zeroPosition: morganButtonCreditLabelButtonSprite.position.x, offscreenLeft: morganButtonCreditLabelButtonSprite.position.x - sceneSize.width, offscreenRight: sceneSize.width + morganButtonCreditLabelButtonSprite.position.x)

    musicReferenceAnimationReference = AnimationReference(zeroPosition: jeffButtonCreditLabelButtonSprite.position.x, offscreenLeft: jeffButtonCreditLabelButtonSprite.position.x - sceneSize.width, offscreenRight: sceneSize.width + jeffButtonCreditLabelButtonSprite.position.x)

    developLabelReferenceAnimationReference = AnimationReference(zeroPosition: developmentLabelSKLabelNode.position.x, offscreenLeft: developmentLabelSKLabelNode.position.x - sceneSize.width, offscreenRight: sceneSize.width + developmentLabelSKLabelNode.position.x)

    designLabelReferenceAnimationReference = AnimationReference(zeroPosition: designLabelSKLabelNode.position.x, offscreenLeft: designLabelSKLabelNode.position.x - sceneSize.width, offscreenRight: sceneSize.width + designLabelSKLabelNode.position.x)

    musicLabelReferenceAnimationReference = AnimationReference(zeroPosition: musicLabelSKLabelNode.position.x, offscreenLeft: musicLabelSKLabelNode.position.x - sceneSize.width, offscreenRight: sceneSize.width + musicLabelSKLabelNode.position.x)

    logoReferenceAnimationReference = AnimationReference(zeroPosition: logoButtonLogoButtonSprite.position.x, offscreenLeft: logoButtonLogoButtonSprite.position.x - sceneSize.width, offscreenRight: sceneSize.width + logoButtonLogoButtonSprite.position.x)

    navigateOutToRight(duration: 0)
  }

  func navigateOutToLeft(duration: TimeInterval) { }

  func navigateInFromLeft(duration: TimeInterval) { }

  func navigateOutToRight(duration: TimeInterval) {
    logoButtonLogoButtonSprite.run(SKActionHelper.moveToEaseInOut(x: logoReferenceAnimationReference.offscreenRight, duration: duration * 0.9))

    developmentLabelSKLabelNode.run(SKActionHelper.moveToEaseInOut(x: developLabelReferenceAnimationReference.offscreenRight, duration: duration * 1.05))
    marcButtonCreditLabelButtonSprite.run(SKActionHelper.moveToEaseInOut(x: developReferenceAnimationReference.offscreenRight, duration: duration))

    musicLabelSKLabelNode.run(SKActionHelper.moveToEaseInOut(x: musicLabelReferenceAnimationReference.offscreenRight, duration: duration * 1.05))
    jeffButtonCreditLabelButtonSprite.run(SKActionHelper.moveToEaseInOut(x: musicReferenceAnimationReference.offscreenRight, duration: duration))
    bensoundButtonCreditLabelButtonSprite.run(SKActionHelper.moveToEaseInOut(x: musicReferenceAnimationReference.offscreenRight, duration: duration * 0.95))

    designLabelSKLabelNode.run(SKActionHelper.moveToEaseInOut(x: designLabelReferenceAnimationReference.offscreenRight, duration: duration * 1.05))
    cathrynButtonCreditLabelButtonSprite.run(SKActionHelper.moveToEaseInOut(x: designReferenceAnimationReference.offscreenRight, duration: duration))
    morganButtonCreditLabelButtonSprite.run(SKActionHelper.moveToEaseInOut(x: designReferenceAnimationReference.offscreenRight, duration: duration * 0.95))
    lauraButtonCreditLabelButtonSprite.run(SKActionHelper.moveToEaseInOut(x: designReferenceAnimationReference.offscreenRight, duration: duration * 0.9))

    tempDisableButton(duration: duration)
  }
  
  func navigateInFromRight(duration: TimeInterval) {
    logoButtonLogoButtonSprite.run(SKActionHelper.moveToEaseInOut(x: logoReferenceAnimationReference.zeroPosition, duration: duration * 0.9))

    developmentLabelSKLabelNode.run(SKActionHelper.moveToEaseInOut(x: developLabelReferenceAnimationReference.zeroPosition, duration: duration * 0.95))
    marcButtonCreditLabelButtonSprite.run(SKActionHelper.moveToEaseInOut(x: developReferenceAnimationReference.zeroPosition, duration: duration))

    musicLabelSKLabelNode.run(SKActionHelper.moveToEaseInOut(x: musicLabelReferenceAnimationReference.zeroPosition, duration: duration * 0.95))
    jeffButtonCreditLabelButtonSprite.run(SKActionHelper.moveToEaseInOut(x: musicReferenceAnimationReference.zeroPosition, duration: duration))
    bensoundButtonCreditLabelButtonSprite.run(SKActionHelper.moveToEaseInOut(x: musicReferenceAnimationReference.zeroPosition, duration: duration * 1.05))

    designLabelSKLabelNode.run(SKActionHelper.moveToEaseInOut(x: designLabelReferenceAnimationReference.zeroPosition, duration: duration * 0.95))
    cathrynButtonCreditLabelButtonSprite.run(SKActionHelper.moveToEaseInOut(x: designReferenceAnimationReference.zeroPosition, duration: duration))
    morganButtonCreditLabelButtonSprite.run(SKActionHelper.moveToEaseInOut(x: designReferenceAnimationReference.zeroPosition, duration: duration * 1.05))
    lauraButtonCreditLabelButtonSprite.run(SKActionHelper.moveToEaseInOut(x: designReferenceAnimationReference.zeroPosition, duration: duration * 1.1))

    tempDisableButton(duration: duration)
  }

  func tempDisableButton(duration : TimeInterval) {
    logoButtonLogoButtonSprite.isUserInteractionEnabled = false
    marcButtonCreditLabelButtonSprite.isUserInteractionEnabled = false
    jeffButtonCreditLabelButtonSprite.isUserInteractionEnabled = false
    bensoundButtonCreditLabelButtonSprite.isUserInteractionEnabled = false
    cathrynButtonCreditLabelButtonSprite.isUserInteractionEnabled = false
    morganButtonCreditLabelButtonSprite.isUserInteractionEnabled = false
    lauraButtonCreditLabelButtonSprite.isUserInteractionEnabled = false

    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
      self.logoButtonLogoButtonSprite.isUserInteractionEnabled = true
      self.marcButtonCreditLabelButtonSprite.isUserInteractionEnabled = true
      self.jeffButtonCreditLabelButtonSprite.isUserInteractionEnabled = true
      self.bensoundButtonCreditLabelButtonSprite.isUserInteractionEnabled = true
      self.cathrynButtonCreditLabelButtonSprite.isUserInteractionEnabled = true
      self.morganButtonCreditLabelButtonSprite.isUserInteractionEnabled = true
      self.lauraButtonCreditLabelButtonSprite.isUserInteractionEnabled = true
    }
  }
}
