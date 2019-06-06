//
//  LogoScene.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 9/16/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class LogoScene : SceneNode {

  let backgroundSpriteBackgroundSSKSpriteNode = SKSpriteNode()
  let maskNodeSKMaskCropNode = SKCropNode()
  let circleNodeSKShapeNode = SKShapeNode(circleOfRadius: 20)

  let t23LogoSKSpriteLogoNode = SKSpriteNode()

  var logoFramesSKTextureArr = [SKTexture]()

  override func layoutSceneScene(size : CGSize, extras menuExtras: MenuExtras?) {
    if !UserDefaultsManager.sharedInstance.isMutedMuted {
      AVAudioPlayerSoundManager.sharedSharedInstance.startAudioPlayerPlaying()
    }

    //We can fix pulling a large number of assets if we do the mask animation ourselves
    //TODO: Need to figure out correct speed / easing and clean this up
    for logoImageNameIndex in 0...89 {
      let textureLogoImageName = String(format: "Logo_000%02d", logoImageNameIndex)
      logoFramesSKTextureArr.append(SKTexture(imageNamed: textureLogoImageName))
    }

    let backgroundNodeSKSpriteNode = SKSpriteNode(color: SKColor(red:0.18, green:0.20, blue:0.22, alpha:1.0), size: size)
    addChild(backgroundNodeSKSpriteNode)

    circleNodeSKShapeNode.setScale(0)

    maskNodeSKMaskCropNode.maskNode = circleNodeSKShapeNode

    backgroundSpriteBackgroundSSKSpriteNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
    addChild(backgroundSpriteBackgroundSSKSpriteNode)

    circleNodeSKShapeNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
    circleNodeSKShapeNode.fillColor = SKColor(red:0.18, green:0.20, blue:0.22, alpha:1.0)
    circleNodeSKShapeNode.lineWidth = 0

    let textureImageSKTexture = SKTexture(imageNamed: "loony")

    backgroundSpriteBackgroundSSKSpriteNode.size.width = size.height / textureImageSKTexture.size().height * textureImageSKTexture.size().width
    backgroundSpriteBackgroundSSKSpriteNode.size.height = size.height

    backgroundSpriteBackgroundSSKSpriteNode.texture = texture

    circleNodeSKShapeNode.zPosition = 1
    addChild(circleNodeSKShapeNode)

    t23LogoSKSpriteLogoNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
    t23LogoSKSpriteLogoNode.zPosition = 2
    addChild(t23LogoSKSpriteLogoNode)
  }

  override func attachedToAttachedToScene() {
    circleNodeSKShapeNode.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.1),
      SKAction.scale(to: 100, duration: 0.8)
      ]))

    t23LogoSKSpriteLogoNode.run(SKAction.sequence([
      SKAction.wait(forDuration: 0.6),
      SKAction.animate(with: logoFramesSKTextureArr, timePerFrame: 0.03, resize: true, restore: false),
      SKAction.wait(forDuration: 1)
      ]))

    DispatchQueue.main.asyncAfter(deadline: .now() + 2.7) {
      if let parent = self.parent as? Router {
        parent.navigate(to: .MainMenu, extras: MenuExtras(rainScaleInScale: 0, catKittyScale: 0, transitionTransitionExtras: TransitionExtras(transitionType: .ScaleInLinearTop, fromColor: SKColor(red:0.18, green:0.20, blue:0.22, alpha:1.0), toColor: BACKGROUND_COLOR)))
      }
    }

    if !UserDefaultsManager.sharedInstance.isMutedMuted {
      run(SKAction.sequence([
        SKAction.wait(forDuration: 2.6),
        SKAction.playSoundFileNamed("cat_meow_3", waitForCompletion: true)
        ]))
    }
  }

  override func detachedFromTachedFromScene() {}
  
  deinit {
    print("logo scene destroyed")
  }
}
