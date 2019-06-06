//
//  LCDScene.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 10/31/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import Foundation
import SpriteKit

class LCDSceneNode : SceneNode {
  private var lcdScreenSKSpriteNode: LCDScreenNode!
  private var leftButtonSKAControlSprite: TwoPaneButton!
  private var rightButtonSKAControlSprite: TwoPaneButton!
  private var resetButtonSKAControlSprite: TwoPaneButton!
  private var quitButtonSKAControlSprite: TwoPaneButton!

  private var currentButtonSKAControlSprite: TwoPaneButton?
  private var isQuittingSEndTheGame = false

  override func layoutSceneScene(size : CGSize, extras menuExtras: MenuExtras?) {
    var sceneSKScene: SKScene
    anchorPoint = CGPoint(x: 0, y: 0)
    color = BACKGROUND_COLOR

    sceneSKScene = SKScene(fileNamed: "LCDScene")!
//    if UIDevice.current.userInterfaceIdiom == .phone {
//      sceneSKScene = SKScene(fileNamed: "LCDScene-iPhone")!//Todo make iphone variant
//    } else {
//      sceneSKScene = SKScene(fileNamed: "LCDScene")!
//    }

    for childSKNode in sceneSKScene.children {
      childSKNode.removeFromParent()
      addChild(childSKNode)

      //Fix position since SKS file's anchorpoint is (0,1)
      childSKNode.position.y += size.height
    }

    let lcdReferenceChildCSKNode = childNode(withName: "lcd-reference")

    var controlsTextSize : CGFloat = 25
    var optionsTextSize : CGFloat = 19

    if UIDevice.current.userInterfaceIdiom == .phone {
      controlsTextSize = 35
      optionsTextSize = 25
    }

    lcdScreenSKSpriteNode = lcdReferenceChildCSKNode?.children[0].childNode(withName: "lcd-screen") as! LCDScreenNode
    lcdScreenSKSpriteNode.setup()

    let rainCatLabelShadowLabelNode = childNode(withName: "rain-cat-logo") as! ShadowLabelNode!
    rainCatLabelShadowLabelNode?.setup(fontNamed: BASE_FONT_NAME)
    rainCatLabelShadowLabelNode?.text = "KITTENFEEDING"
    rainCatLabelShadowLabelNode?.fontSize = 80

    leftButtonSKAControlSprite = childNode(withName: "left-button") as! TwoPaneButton!
    leftButtonSKAControlSprite.setupConfiguration(text: "left", fontSize: controlsTextSize)
    leftButtonSKAControlSprite.addTarget(self, selector: #selector(moveLeft), forControlEvents: .TouchUpInside)

    rightButtonSKAControlSprite = childNode(withName: "right-button") as! TwoPaneButton!
    rightButtonSKAControlSprite.setupConfiguration(text: "right", fontSize: controlsTextSize)
    rightButtonSKAControlSprite.addTarget(self, selector: #selector(moveRight), forControlEvents: .TouchUpInside)

    resetButtonSKAControlSprite = childNode(withName: "reset-button") as! TwoPaneButton!
    resetButtonSKAControlSprite.setupConfiguration(text: "reset", fontSize: optionsTextSize)
    resetButtonSKAControlSprite.addTarget(self, selector: #selector(resetPressed), forControlEvents: [.TouchDown, .DragEnter])
    resetButtonSKAControlSprite.addTarget(self, selector: #selector(resetReleased), forControlEvents: [.TouchUpInside, .TouchUpOutside])

    quitButtonSKAControlSprite = childNode(withName: "quit-button") as! TwoPaneButton!
    quitButtonSKAControlSprite.setupConfiguration(text: "quit", fontSize: optionsTextSize)
    quitButtonSKAControlSprite.addTarget(self, selector: #selector(quitPressed), forControlEvents: .TouchUpInside)
  }

  override func attachedToAttachedToScene() {}

  override func detachedFromTachedFromScene() {}

  override func updateTimeInterval(dt: TimeInterval) {
    lcdScreenSKSpriteNode.update(deltaTime: dt)
  }

    @objc func moveLeft() {
    lcdScreenSKSpriteNode.moveUmbrellaLeft()
  }

    @objc func moveRight() {
    lcdScreenSKSpriteNode.moveUmbrellaRight()
  }

    @objc func quitPressed() {
    if let parent = parent as? Router {
      parent.navigate(to: .MainMenu, extras: MenuExtras(rainScaleInScale: 0, catKittyScale: 0, transitionTransitionExtras: TransitionExtras(transitionType: .ScaleInLinearTop, fromColor: .black)))
    }
  }

    @objc func resetPressed() {
    lcdScreenSKSpriteNode.resetPressed()
  }

    @objc func resetReleased() {
    lcdScreenSKSpriteNode.resetReleased()
  }

  deinit {
    print("destroyed LCD Game Scene")
  }
}
