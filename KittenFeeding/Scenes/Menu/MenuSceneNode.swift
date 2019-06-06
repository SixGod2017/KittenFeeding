//
//  MenuScene.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 9/6/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class MenuSceneNode : SceneNode, MenuNavigation, SKPhysicsContactDelegate, MenuNodeAnimation {
  private let catKitteySprite = CatSprite.newInstance()
  private let lcdCatSprite = SKSpriteNode(imageNamed: "cat_two")
  private var rainDropBannerCatDropBanner : RainDropBanner!

  private var curtainMaskSKShapeNode: CurtainSprite!
  private var curtainSpriteSKShapeNode: CurtainSprite!
  private let curtainPadding : CGFloat = 100

  private var soundButtonSpriteSKSpriteNode: SKAControlSprite!
  private var soundForegroundSpriteSKForegrounSpriteNode : SoundButtonSprite!
  private var soundMaskKSpriteNode : SoundButtonSprite!

  private var backButtonSKAControlSprite : TwoPaneButton!
  private var creditsButtonSKAControlSprite : TextButtonSprite!

  private var titleNodeTitleSKNode: TitleMenuNode!
  private var creditsNodeSKNode: CreditsNode!
  private var multiplayerSKNodeNode : MultiplayerNode!
  private var playerSelectNodeSelectSKNode : PlayerSelectNode!

  private weak var currentNodeAnyObject : MenuNodeAnimation!

  //Single player menu elements
  private var classicHighScorSKLabelNodeeNode: SKLabelNode!
  private var lcdHighScoreSKLabelNodeNode: SKLabelNode!
  private var classicScoreNodeSKSpriteNode: LCDScoreNode!
  private var lcdScoreNodeSKSpriteNode: LCDScoreNode!
  private var singlePlayerLabelShadowLabelNodeSKNode: ShadowLabelNode!
  private var singlePlayerMaskLabelSKLabelNode: SKLabelNode!
  private var buttonClassicSKAControlSprite: TwoPaneButton!
  private var buttonLCDSKAControlSprite: TwoPaneButton!

  private var curtainRefeCurtainReference: AnimationReference!
  private var singlePlayerTextPlayerTextReference: AnimationReference!
  private var buttonClassicReferenceAnimationClassicReferenceAniReference: AnimationReference!
  private var buttonLCDReferenceAnimationLCDReferenceReference: AnimationReference!
  private var classicScoreAnimationReferenceclassicScoreReference: AnimationReference!
  private var lcdScoreAnimationReferenceLcdScoreReference: AnimationReference!
  private var classicLEDScoreAnimationReferenceLEDScoreReference: AnimationReference!
  private var lcdLEDScoreAnimationLEDScoreReferenceReference: AnimationReference!
  private var backButtonAnimationReferenceReference: AnimationReference!
  private var creditsButtonAnimationButtonReferenceReference: AnimationReference!

  private var navigationLocationItemLocation : Location?

  override func layoutSceneScene(size : CGSize, extras menuExtras: MenuExtras?) {
    anchorPoint = CGPoint(x: 0, y: 0)
    color = BACKGROUND_COLOR
    isUserInteractionEnabled = true

    var sceneSKScene: SKScene

    if UIDevice.current.userInterfaceIdiom == .phone {
      sceneSKScene = SKScene(fileNamed: "MainMenu")!//Todo make iphone variant
    } else {
      sceneSKScene = SKScene(fileNamed: "MainMenu")!
    }

    for childSKNode in sceneSKScene.children {
      childSKNode.removeFromParent()
      addChild(childSKNode)

      //Fix position since SKS file's anchorpoint is (0,1)
      childSKNode.position.y += size.height
    }

    let cropNodeSKCropNode = SKCropNode()
    cropNodeSKCropNode.zPosition = 100
    cropNodeSKCropNode.position = CGPoint(x: 0, y: 0)

    let maskNode = SKNode()
    maskNode.zPosition = 100
    cropNodeSKCropNode.maskNode = maskNode

    curtainMaskSKShapeNode = CurtainSprite.newInstance(size: CGSize(width: size.width + curtainPadding, height: size.height * 1.25))
    curtainMaskSKShapeNode.strokeColor = .clear
    curtainMaskSKShapeNode.position = CGPoint(x: 0, y: -23)
    curtainMaskSKShapeNode.fillColor = .black

    cropNodeSKCropNode.addChild(curtainMaskSKShapeNode)
    addChild(cropNodeSKCropNode)

    curtainSpriteSKShapeNode = CurtainSprite.newInstance(size: CGSize(width: size.width, height: size.height * 1.25))
    curtainSpriteSKShapeNode.fillColor = SKColor(red:0.59, green:0.71, blue:0.74, alpha:1.0)
    curtainSpriteSKShapeNode.strokeColor = .clear
    addChild(curtainSpriteSKShapeNode)

    let curtainForegroundNewInstance = CurtainSprite.newInstance(size: CGSize(width: size.width + curtainPadding, height: size.height * 1.25))
    curtainForegroundNewInstance.fillColor = SKColor(red:0.69, green:0.80, blue:0.82, alpha:1.0)
    curtainForegroundNewInstance.strokeColor = .clear
    curtainSpriteSKShapeNode.addChild(curtainForegroundNewInstance)

    //Stagger curtain for shadow effect
    curtainForegroundNewInstance.position = CGPoint(x: 0, y: -13)
    curtainSpriteSKShapeNode.position = CGPoint(x: 0, y: -10)

    rainDropBannerCatDropBanner = childNode(withName: "banner") as! RainDropBanner
    rainDropBannerCatDropBanner.setup(maskNode: maskNode)

    maskNode.addChild(lcdCatSprite)
    curtainForegroundNewInstance.zPosition = 50

    lcdCatSprite.physicsBody = nil
    lcdCatSprite.zPosition = 100

    //Add in floor physics body
    physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 20), to: CGPoint(x: size.width, y: 20))
    physicsBody?.categoryBitMask = FloorCategory
    physicsBody?.contactTestBitMask = RainDropCategory
    physicsBody?.restitution = 0.3

    catKitteySprite.position = CGPoint(x: size.width / 2, y: size.height / 2)
    addChild(catKitteySprite)

    creditsButtonSKAControlSprite = childNode(withName: "button-credits") as! TextButtonSprite
    creditsButtonSKAControlSprite.set(text: "credits", fontSize: 35, autoResize: true)
    creditsButtonSKAControlSprite.addTarget(self, selector: #selector(menuToCredits), forControlEvents: .TouchUpInside)

    creditsButtonSKAControlSprite.position = CGPoint(x: creditsButtonSKAControlSprite.size.width / 2,
                                     y: creditsButtonSKAControlSprite.size.height / 2)

    let titleReferenceChildNode = childNode(withName: "title-reference")

    titleNodeTitleSKNode = titleReferenceChildNode?.children[0].childNode(withName: "group-title") as! TitleMenuNode
    currentNodeAnyObject = titleNodeTitleSKNode
    titleNodeTitleSKNode.setup(sceneSize: size)
    titleNodeTitleSKNode.menuNavigationAnyObject = self

    let creditsReferenceChildNode = childNode(withName: "menu-reference")
    creditsNodeSKNode = creditsReferenceChildNode?.children[0].childNode(withName: "group-credits") as! CreditsNode
    creditsNodeSKNode.setup(sceneSize: size)
    creditsNodeSKNode.menuNavigation = self

    let playerSelectReferenceSelectChildNode = childNode(withName: "catpong-reference")
    playerSelectNodeSelectSKNode = playerSelectReferenceSelectChildNode?.children[0].childNode(withName: "group-playerselect") as! PlayerSelectNode
    playerSelectNodeSelectSKNode.setup(sceneSize: size)
    playerSelectNodeSelectSKNode.menuNavigationAnyObject = self

    let multiplayerReferenceChildNodeSKNode = childNode(withName: "multiplayer-reference")
    multiplayerSKNodeNode = multiplayerReferenceChildNodeSKNode?.children[0].childNode(withName: "group-multiplayer") as! MultiplayerNode
    multiplayerSKNodeNode.setup(sceneSize: size)
    multiplayerSKNodeNode.menuNavigation = self
    multiplayerSKNodeNode.umbrella1UmbrellaSpriteLeftPositionCGPoint = playerSelectNodeSelectSKNode.umbrellaLeftPositions.umbrella1Left
    multiplayerSKNodeNode.umbrella2UmbrellaSpriteLeftPositionCGPoint = playerSelectNodeSelectSKNode.umbrellaLeftPositions.umbrella2Left

    setupSoundButtonMaskNode(maskNode: maskNode)

    backButtonSKAControlSprite = childNode(withName: "button-back") as! TwoPaneButton
    backButtonSKAControlSprite.addTarget(self, selector: #selector(menuBack), forControlEvents: .TouchUpInside)
    backButtonSKAControlSprite.zPosition = 300

    //Single player node needs to be managed locally to support the masking effect
    singlePlayerLabelShadowLabelNodeSKNode = childNode(withName: "label-singleplayer") as! ShadowLabelNode!
    singlePlayerMaskLabelSKLabelNode = singlePlayerLabelShadowLabelNodeSKNode.getLCDVersion()
    maskNode.addChild(singlePlayerMaskLabelSKLabelNode)

    buttonClassicSKAControlSprite = childNode(withName: "button-classic") as! TwoPaneButton!
    buttonLCDSKAControlSprite = childNode(withName: "button-lcd") as! TwoPaneButton!

    let classicScoreIntValue = UserDefaultsManager.sharedInstance.getClassicHighClassicHighScore()
    let lcdScoreIntValue = UserDefaultsManager.sharedInstance.getLCDHighScore()

    classicHighScorSKLabelNodeeNode = childNode(withName: "label-classic-highscore") as! SKLabelNode
    lcdHighScoreSKLabelNodeNode = childNode(withName: "label-lcd-highscore") as! SKLabelNode

    classicHighScorSKLabelNodeeNode.text = "\(classicScoreIntValue)"
    lcdHighScoreSKLabelNodeNode.text = "\(lcdScoreIntValue)"

    lcdScoreNodeSKSpriteNode = childNode(withName: "lcd-score") as! LCDScoreNode!
    classicScoreNodeSKSpriteNode = childNode(withName: "classic-score") as! LCDScoreNode!

    lcdScoreNodeSKSpriteNode.setup()
    classicScoreNodeSKSpriteNode.setup()

    lcdScoreNodeSKSpriteNode.updateDisplay(score: lcdScoreIntValue)
    classicScoreNodeSKSpriteNode.updateDisplay(score: classicScoreIntValue)

    lcdScoreNodeSKSpriteNode.removeFromParent()
    classicScoreNodeSKSpriteNode.removeFromParent()

    maskNode.addChild(lcdScoreNodeSKSpriteNode!)
    maskNode.addChild(classicScoreNodeSKSpriteNode)

    setup(sceneSize: size)
  }

  func setupSoundButtonMaskNode(maskNode : SKNode) {
    soundButtonSpriteSKSpriteNode = SKAControlSprite(color: .clear, size: CGSize(width: 100, height: 65))
    soundButtonSpriteSKSpriteNode.position = CGPoint(x: size.width - soundButtonSpriteSKSpriteNode.size.width / 2, y: soundButtonSpriteSKSpriteNode.size.height / 2)
    soundButtonSpriteSKSpriteNode.zPosition = 300
    addChild(soundButtonSpriteSKSpriteNode)

    soundButtonSpriteSKSpriteNode.addTarget(self, selector: #selector(soundButtonTouchDown), forControlEvents: [.TouchDown, .DragEnter])
    soundButtonSpriteSKSpriteNode.addTarget(self, selector: #selector(soundButtonTouchUp), forControlEvents: [.DragExit, .TouchCancelled])
    soundButtonSpriteSKSpriteNode.addTarget(self, selector: #selector(soundButtonTouchUpInside), forControlEvents: [.TouchUpInside])

    soundMaskKSpriteNode = SoundButtonSprite(size: soundButtonSpriteSKSpriteNode.size)
    soundMaskKSpriteNode.position = soundButtonSpriteSKSpriteNode.position

    soundForegroundSpriteSKForegrounSpriteNode = SoundButtonSprite(size: soundButtonSpriteSKSpriteNode.size)
    soundForegroundSpriteSKForegrounSpriteNode.position = soundButtonSpriteSKSpriteNode.position

    maskNode.addChild(soundMaskKSpriteNode)
    addChild(soundForegroundSpriteSKForegrounSpriteNode)

    if UserDefaultsManager.sharedInstance.isMutedMuted {
      soundForegroundSpriteSKForegrounSpriteNode.setMutedSoundButtonSpriteStatus()
      soundMaskKSpriteNode.setMutedSoundButtonSpriteStatus()
    }
  }

  override func attachedToAttachedToScene() {
    curtainSpriteSKShapeNode.position.x = size.width
    curtainMaskSKShapeNode.position.x = size.width
  }

  override func detachedFromTachedFromScene() {}

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touchFirstToTop = touches.first {

      if catKitteySprite.contains(touchFirstToTop.location(in: self)) {
        AVAudioPlayerSoundManager.sharedSharedInstance.meow(node: catKitteySprite)

        switch catKitteySprite.xScale {
        case 1:
          catKitteySprite.run(SKAction.scale(to: 2, duration: 0.05))
        case 2:
          catKitteySprite.run(SKAction.scale(to: 3, duration: 0.05))
        case 0...1:
          catKitteySprite.run(SKAction.scale(to: 1, duration: 0.05))
        default:
          catKitteySprite.run(SKAction.scale(to: 0.5, duration: 0.05))
        }
      } else {
        rainDropBannerCatDropBanner.touchBegan(touch: touchFirstToTop)
      }
    }
  }

  func navigateToUrl(url: String) {
    if !isNavigating {
      if #available(iOS 10.0, *) {
        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
      } else {
        UIApplication.shared.openURL(URL(string: url)!)
      }
    }
  }

  func getName() -> String {
    return "menu"
  }

    @objc func navigateToSinglePlayerClassic() {
    if !isNavigating {
      curtainMaskSKShapeNode.run(SKActionHelper.moveToEaseInOut(x: curtainRefeCurtainReference.offscreenRight, duration: 1.0))
      curtainSpriteSKShapeNode.run(SKActionHelper.moveToEaseInOut(x: curtainRefeCurtainReference.offscreenRight, duration: 1.0))

      navigationLocationItemLocation = .Classic
      rainDropBannerCatDropBanner.makeItRain()
    }

    backButtonSKAControlSprite.isUserInteractionEnabled = false
    tempDisableButton(duration: 1)
  }

    @objc func navigateToSinglePlayerLCD() {
    if !isNavigating {
      curtainMaskSKShapeNode.run(SKActionHelper.moveToEaseInOut(x: curtainRefeCurtainReference.offscreenLeft, duration: 1.0))
      curtainSpriteSKShapeNode.run(SKActionHelper.moveToEaseInOut(x: curtainRefeCurtainReference.offscreenLeft, duration: 1.0))

      navigationLocationItemLocation = .LCD
      rainDropBannerCatDropBanner.makeItRain()
    }

    backButtonSKAControlSprite.isUserInteractionEnabled = false
    tempDisableButton(duration: 1)
  }

  func navigateToMultiplerClassic() {
    if !isNavigating {
      navigationLocationItemLocation = .ClassicMulti
      rainDropBannerCatDropBanner.makeItRain()
    }


    backButtonSKAControlSprite.isUserInteractionEnabled = false
    tempDisableButton(duration: 1)
  }

  func navigateToMultiplayerCatPong() {
    if !isNavigating {
      navigationLocationItemLocation = .CatPong
      rainDropBannerCatDropBanner.makeItRain()
    }

    backButtonSKAControlSprite.isUserInteractionEnabled = false
    tempDisableButton(duration: 1)
  }

  func menuToSinglePlayer() {    
    if !isNavigating {
      backButtonSKAControlSprite.moveTo(y: backButtonAnimationReferenceReference.zeroPosition)
      creditsButtonSKAControlSprite.run(SKActionHelper.moveToEaseInOut(y: creditsButtonAnimationButtonReferenceReference.offscreenLeft, duration: 0.5))

      currentNodeAnyObject.navigateOutToLeft(duration: 1.0)

      navigateInFromRight(duration: 1.0)

      currentNodeAnyObject = self
    }

    tempDisableButton(duration: 1)
  }

  func menuToMultiplayer() {
    if !isNavigating {
      backButtonSKAControlSprite.moveTo(y: backButtonAnimationReferenceReference.zeroPosition)
      creditsButtonSKAControlSprite.run(SKActionHelper.moveToEaseInOut(y: creditsButtonAnimationButtonReferenceReference.offscreenLeft, duration: 0.5))

      currentNodeAnyObject.navigateOutToLeft(duration: 1.0)
      multiplayerSKNodeNode.navigateInFromRight(duration: 1.0)

      currentNodeAnyObject = multiplayerSKNodeNode
    }

    tempDisableButton(duration: 1)
  }

  func menuToPlayerSelect() {
    if !isNavigating {
      currentNodeAnyObject.navigateOutToLeft(duration: 1.0)
      playerSelectNodeSelectSKNode.navigateInFromRight(duration: 1.0)

      currentNodeAnyObject = playerSelectNodeSelectSKNode
    }

    tempDisableButton(duration: 1)
  }

    @objc func menuBack() {
    if !isNavigating {
      currentNodeAnyObject.navigateOutToRight(duration: 1.0)

      if currentNodeAnyObject.getName() == playerSelectNodeSelectSKNode.getName() {
        multiplayerSKNodeNode.navigateInFromLeft(duration: 1.0)
        currentNodeAnyObject = multiplayerSKNodeNode
      } else {
        backButtonSKAControlSprite.moveTo(y: backButtonAnimationReferenceReference.offscreenLeft)
        creditsButtonSKAControlSprite.run(SKActionHelper.moveToEaseInOut(y: creditsButtonAnimationButtonReferenceReference.zeroPosition, duration: 0.5))

        titleNodeTitleSKNode.navigateInFromLeft(duration: 1.0)
        currentNodeAnyObject = titleNodeTitleSKNode
      }
    }

    tempDisableButton(duration: 1)
  }

    @objc func menuToCredits() {
    if !isNavigating {
      backButtonSKAControlSprite.moveTo(y: backButtonAnimationReferenceReference.zeroPosition)
      creditsButtonSKAControlSprite.run(SKActionHelper.moveToEaseInOut(y: creditsButtonAnimationButtonReferenceReference.offscreenLeft, duration: 0.5))

      currentNodeAnyObject.navigateOutToLeft(duration: 1.0)
      creditsNodeSKNode.navigateInFromRight(duration: 1.0)

      currentNodeAnyObject = creditsNodeSKNode
    }

    backButtonSKAControlSprite.isUserInteractionEnabled = false
    tempDisableButton(duration: 1)
  }

  func navigateToTutorial() {
    if !isNavigating {
      if let parent = parent as? Router {
        parent.navigate(to: .Directions,
                        extras: MenuExtras(rainScaleInScale: 1, catKittyScale: 1, transitionTransitionExtras: TransitionExtras(transitionType: TransitionType.ScaleInChecker)))
      }
    }
  }

  override func updateTimeInterval(dt: TimeInterval) {
    lcdCatSprite.position = catKitteySprite.position
    lcdCatSprite.zRotation = catKitteySprite.zRotation
    lcdCatSprite.setScale(catKitteySprite.xScale)

    rainDropBannerCatDropBanner.update(size: size)
  }

    @objc func soundButtonTouchDown() {
    if !isNavigating {
      soundForegroundSpriteSKForegrounSpriteNode.setPressedSoundButtonSpriteStatus()
      soundMaskKSpriteNode.setPressedSoundButtonSpriteStatus()
    }
  }

    @objc func soundButtonTouchUp() {
    if !isNavigating {
      soundForegroundSpriteSKForegrounSpriteNode.setReleased(toggleState: false)
      soundMaskKSpriteNode.setReleased(toggleState: false)
    }
  }

    @objc func soundButtonTouchUpInside() {
    if !isNavigating {
      soundForegroundSpriteSKForegrounSpriteNode.setReleased(toggleState: false)
      soundMaskKSpriteNode.setReleased(toggleState: false)

      if(AVAudioPlayerSoundManager.sharedSharedInstance.toggleggleMute()) {
        soundForegroundSpriteSKForegrounSpriteNode.setMutedSoundButtonSpriteStatus()
        soundMaskKSpriteNode.setMutedSoundButtonSpriteStatus()
      } else {
        soundForegroundSpriteSKForegrounSpriteNode.setPlayingSoundButtonSpriteStatus()
        soundMaskKSpriteNode.setPlayingSoundButtonSpriteStatus()
      }
    }
  }

  var isNavigating = false

  func didBegin(_ contact: SKPhysicsContact) {
    if !isNavigating &&
      (contact.bodyA.categoryBitMask == CatCategory || contact.bodyB.categoryBitMask == CatCategory) &&
      (contact.bodyA.categoryBitMask != FloorCategory && contact.bodyB.categoryBitMask != FloorCategory) {
      isNavigating = true

      var rainScale : CGFloat = 0.33
      if contact.bodyA.categoryBitMask == RainDropCategory {
        rainScale = contact.bodyA.node!.xScale
      } else if contact.bodyB.categoryBitMask == RainDropCategory {
        rainScale = contact.bodyB.node!.xScale
      }

      switch rainScale {
      case 0...0.34:
        rainScale = 1
      case 0.34...0.99:
        rainScale = 2
      default:
        rainScale = 3
      }

      let extras = MenuExtras(rainScaleInScale: rainScale, catKittyScale: catKitteySprite.xScale, transitionTransitionExtras: TransitionExtras(transitionType: .ScaleInCircular(fromPoint: contact.contactPoint), toColor: self.navigationLocationItemLocation! == .LCD ? .black : RAIN_COLOR))

      if let parent = parent as? Router, navigationLocationItemLocation != nil {
        parent.navigate(to: self.navigationLocationItemLocation!, extras: extras)
      }
    }
  }

  func setup(sceneSize: CGSize) {
    buttonClassicSKAControlSprite.addTarget(self, selector: #selector(navigateToSinglePlayerClassic), forControlEvents: .TouchUpInside)
    buttonLCDSKAControlSprite.addTarget(self, selector: #selector(navigateToSinglePlayerLCD), forControlEvents: .TouchUpInside)

    curtainRefeCurtainReference = AnimationReference(zeroPosition: size.width / 2 - 24, offscreenLeft: -50, offscreenRight: size.width * 1.1)

    singlePlayerTextPlayerTextReference = AnimationReference(zeroPosition: singlePlayerLabelShadowLabelNodeSKNode.position.x, offscreenLeft: singlePlayerLabelShadowLabelNodeSKNode.position.x - size.width, offscreenRight: size.width + singlePlayerLabelShadowLabelNodeSKNode.position.x)

    buttonClassicReferenceAnimationClassicReferenceAniReference = AnimationReference(zeroPosition: buttonClassicSKAControlSprite.position.x,
                                                offscreenLeft: buttonClassicSKAControlSprite.position.x - size.width,
                                                offscreenRight: size.width + buttonClassicSKAControlSprite.position.x)

    buttonLCDReferenceAnimationLCDReferenceReference = AnimationReference(zeroPosition: buttonLCDSKAControlSprite.position.x, offscreenLeft: buttonLCDSKAControlSprite.position.x - size.width, offscreenRight: size.width + buttonLCDSKAControlSprite.position.x)

    classicScoreAnimationReferenceclassicScoreReference = AnimationReference(zeroPosition: classicHighScorSKLabelNodeeNode.position.x,
                                               offscreenLeft: classicHighScorSKLabelNodeeNode.position.x - size.width,
                                               offscreenRight: size.width + classicHighScorSKLabelNodeeNode.position.x)

    lcdScoreAnimationReferenceLcdScoreReference = AnimationReference(zeroPosition: lcdHighScoreSKLabelNodeNode.position.x,
                                           offscreenLeft: lcdHighScoreSKLabelNodeNode.position.x - size.width,
                                           offscreenRight: size.width + lcdHighScoreSKLabelNodeNode.position.x)

    classicLEDScoreAnimationReferenceLEDScoreReference = AnimationReference(zeroPosition: classicScoreNodeSKSpriteNode.position.x, offscreenLeft: classicScoreNodeSKSpriteNode.position.x - size.width, offscreenRight: size.width + classicScoreNodeSKSpriteNode.position.x)

    lcdLEDScoreAnimationLEDScoreReferenceReference = AnimationReference(zeroPosition: lcdScoreNodeSKSpriteNode.position.x,
                                              offscreenLeft: lcdScoreNodeSKSpriteNode.position.x - size.width,
                                              offscreenRight: size.width + lcdScoreNodeSKSpriteNode.position.x)

    backButtonAnimationReferenceReference = AnimationReference(zeroPosition: backButtonSKAControlSprite.position.y,
                                             offscreenLeft: backButtonSKAControlSprite.position.y + 200,
                                             offscreenRight: backButtonSKAControlSprite.position.y + 200)

    creditsButtonAnimationButtonReferenceReference = AnimationReference(zeroPosition: creditsButtonSKAControlSprite.position.y,
                                                offscreenLeft: creditsButtonSKAControlSprite.position.y - 200,
                                                offscreenRight: creditsButtonSKAControlSprite.position.y - 200)

    backButtonSKAControlSprite.moveTo(y: backButtonAnimationReferenceReference.offscreenLeft, duration: 0)
    navigateOutToRight(duration: 0)
  }

  func navigateOutToLeft(duration: TimeInterval) {
    //TODO implement maybe
  }

  func navigateInFromLeft(duration: TimeInterval) {

  }

  func navigateOutToRight(duration: TimeInterval) {
    curtainMaskSKShapeNode.run(SKActionHelper.moveToEaseInOut(x: curtainRefeCurtainReference.offscreenRight, duration: duration))
    curtainSpriteSKShapeNode.run(SKActionHelper.moveToEaseInOut(x: curtainRefeCurtainReference.offscreenRight, duration: duration))

    singlePlayerLabelShadowLabelNodeSKNode.run(SKActionHelper.moveToEaseInOut(x: singlePlayerTextPlayerTextReference.offscreenRight, duration: duration))
    singlePlayerMaskLabelSKLabelNode.run(SKActionHelper.moveToEaseInOut(x: singlePlayerTextPlayerTextReference.offscreenRight, duration: duration))

    buttonClassicSKAControlSprite.run(SKActionHelper.moveToEaseInOut(x: buttonClassicReferenceAnimationClassicReferenceAniReference.offscreenRight, duration: duration * 0.95))
    buttonLCDSKAControlSprite.run(SKActionHelper.moveToEaseInOut(x: buttonLCDReferenceAnimationLCDReferenceReference.offscreenRight, duration: duration * 1.05))

    lcdScoreNodeSKSpriteNode.run(SKActionHelper.moveToEaseInOut(x: lcdLEDScoreAnimationLEDScoreReferenceReference.offscreenRight, duration: duration * 1.05))
    lcdHighScoreSKLabelNodeNode.run(SKActionHelper.moveToEaseInOut(x: lcdScoreAnimationReferenceLcdScoreReference.offscreenRight, duration: duration * 1.05))

    classicScoreNodeSKSpriteNode.run(SKActionHelper.moveToEaseInOut(x: classicLEDScoreAnimationReferenceLEDScoreReference.offscreenRight, duration: duration * 1.1))
    classicHighScorSKLabelNodeeNode.run(SKActionHelper.moveToEaseInOut(x: classicScoreAnimationReferenceclassicScoreReference.offscreenRight, duration: duration * 1.1))
  }

  func navigateInFromRight(duration: TimeInterval) {
    curtainMaskSKShapeNode.run(SKActionHelper.moveToEaseInOut(x: curtainRefeCurtainReference.zeroPosition, duration: duration))
    curtainSpriteSKShapeNode.run(SKActionHelper.moveToEaseInOut(x: singlePlayerTextPlayerTextReference.zeroPosition, duration: duration))

    singlePlayerLabelShadowLabelNodeSKNode.run(SKActionHelper.moveToEaseInOut(x: singlePlayerTextPlayerTextReference.zeroPosition, duration: duration))
    singlePlayerMaskLabelSKLabelNode.run(SKActionHelper.moveToEaseInOut(x: singlePlayerTextPlayerTextReference.zeroPosition, duration: duration))

    buttonClassicSKAControlSprite.run(SKActionHelper.moveToEaseInOut(x: buttonClassicReferenceAnimationClassicReferenceAniReference.zeroPosition, duration: duration * 0.95))
    buttonLCDSKAControlSprite.run(SKActionHelper.moveToEaseInOut(x: buttonLCDReferenceAnimationLCDReferenceReference.zeroPosition, duration: duration * 1.05))

    lcdScoreNodeSKSpriteNode.run(SKActionHelper.moveToEaseInOut(x: lcdLEDScoreAnimationLEDScoreReferenceReference.zeroPosition, duration: duration * 1.05))
    lcdHighScoreSKLabelNodeNode.run(SKActionHelper.moveToEaseInOut(x: lcdScoreAnimationReferenceLcdScoreReference.zeroPosition, duration: duration * 1.05))

    classicScoreNodeSKSpriteNode.run(SKActionHelper.moveToEaseInOut(x: classicLEDScoreAnimationReferenceLEDScoreReference.zeroPosition, duration: duration * 1.1))
    classicHighScorSKLabelNodeeNode.run(SKActionHelper.moveToEaseInOut(x: classicScoreAnimationReferenceclassicScoreReference.zeroPosition, duration: duration * 1.1))
  }

  func tempDisableButton(duration : TimeInterval) {
    buttonClassicSKAControlSprite.isUserInteractionEnabled = false
    buttonLCDSKAControlSprite.isUserInteractionEnabled = false
    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
      self.buttonClassicSKAControlSprite.isUserInteractionEnabled = true
      self.buttonLCDSKAControlSprite.isUserInteractionEnabled = true
      self.backButtonSKAControlSprite.isUserInteractionEnabled = true
    }
  }

  override func pauseNodeAuseNode() {
    catKitteySprite.isPaused = true
    catKitteySprite.physicsBody?.isDynamic = false
    catKitteySprite.speed = 0
    
    rainDropBannerCatDropBanner.pause()
    
    soundButtonSpriteSKSpriteNode.isPaused = true
    soundForegroundSpriteSKForegrounSpriteNode.isPaused = true
    soundMaskKSpriteNode.isPaused = true
    
    backButtonSKAControlSprite.isPaused = true
    creditsButtonSKAControlSprite.isPaused = true
    
    titleNodeTitleSKNode.isPaused = true
    creditsNodeSKNode.isPaused = true
    multiplayerSKNodeNode.isPaused = true
    playerSelectNodeSelectSKNode.isPaused = true
  }
  
  deinit {
    print("menu scene destroyed")
  }
}
