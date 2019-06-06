//
//  DirectionsNode.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 6/29/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class DirectionsSceneNode : SceneNode, SKPhysicsContactDelegate {

  private var backButtonSKAControlSprite: TwoPaneButton!
  private var singleClassicButtonTwoPaneButtonSKAControlSprite: TwoPaneButton!
  private var lcdButtonTwoPaneButtonSKAControlSprite: TwoPaneButton!
  private var multiClassicButtonSKAControlSprite: TwoPaneButton!
  private var catPongButtonKACoTwoPaneButtonntrolSprite: TwoPaneButton!

  private var nextButtonTextButtonSprite: TextButtonSprite!
  private var previousButtonSKAControlSprite: TextButtonSprite!

  private var directionsGroupSKNode: SKNode!
  private var catPongGroupInstructionsNode: InstructionsNode!
  private var lcdGroupInstructionsNode: InstructionsNode!
  private var classicSingleGroupInstructionsNode: InstructionsNode!
  private var classicMultiGroupInstructionsNode: InstructionsNode!

  private var currentNodeSKNode: SKNode!

  override func layoutSceneScene(size: CGSize, extras: MenuExtras?) {
    var worldFrameBounds = frame
    worldFrameBounds.origin.y -= frame.size.height * 2
    worldFrameBounds.size.height += frame.size.height * 4
    worldFrameBounds.size.width += frame.size.width

    self.physicsBody = SKPhysicsBody(edgeLoopFrom: worldFrameBounds)
    self.physicsBody?.categoryBitMask = WorldFrameCategory

    if let gravityManager = parent as? WorldManager {
      gravityManager.updateGravity(vector: CGVector(dx: 0, dy: -2))
    }

    anchorPoint = CGPoint(x: 0, y: 0)
    color = BACKGROUND_COLOR
    isUserInteractionEnabled = true

    var scene : SKScene

    if UIDevice.current.userInterfaceIdiom == .phone {
      scene = SKScene(fileNamed: "DirectionsScene")!//Todo make iphone variant
    } else {
      scene = SKScene(fileNamed: "DirectionsScene")!
    }

    for child in scene.children {
      child.removeFromParent()
      addChild(child)

      //Fix position since SKS file's anchorpoint is (0,1)
      child.position.y += size.height
    }

    directionsGroupSKNode = childNode(withName: "group-directions-menu")
    catPongGroupInstructionsNode = childNode(withName: "group-cat-pong") as! InstructionsNode
    lcdGroupInstructionsNode = childNode(withName: "group-lcd") as! InstructionsNode
    classicMultiGroupInstructionsNode = childNode(withName: "group-classic-multi") as! InstructionsNode
    classicSingleGroupInstructionsNode = childNode(withName: "group-classic-single") as! InstructionsNode

    catPongGroupInstructionsNode.position.x = size.width
    lcdGroupInstructionsNode.position.x = size.width
    classicMultiGroupInstructionsNode.position.x = size.width
    classicSingleGroupInstructionsNode.position.x = size.width

    currentNodeSKNode = directionsGroupSKNode

    backButtonSKAControlSprite = childNode(withName: "button-back") as! TwoPaneButton
    backButtonSKAControlSprite.addTarget(self, selector: #selector(backClicked), forControlEvents: .TouchUpInside)

    singleClassicButtonTwoPaneButtonSKAControlSprite = directionsGroupSKNode.childNode(withName: "button-single-classic") as! TwoPaneButton
    singleClassicButtonTwoPaneButtonSKAControlSprite.addTarget(self, selector: #selector(directionsButtonClicked(_:)), forControlEvents: .TouchUpInside)

    lcdButtonTwoPaneButtonSKAControlSprite = directionsGroupSKNode.childNode(withName: "button-lcd") as! TwoPaneButton
    lcdButtonTwoPaneButtonSKAControlSprite.addTarget(self, selector: #selector(directionsButtonClicked(_:)), forControlEvents: .TouchUpInside)

    multiClassicButtonSKAControlSprite = directionsGroupSKNode.childNode(withName: "button-multi-classic") as! TwoPaneButton
    multiClassicButtonSKAControlSprite.addTarget(self, selector: #selector(directionsButtonClicked(_:)), forControlEvents: .TouchUpInside)

    catPongButtonKACoTwoPaneButtonntrolSprite = directionsGroupSKNode.childNode(withName: "button-cat-pong") as! TwoPaneButton
    catPongButtonKACoTwoPaneButtonntrolSprite.addTarget(self, selector: #selector(directionsButtonClicked(_:)), forControlEvents: .TouchUpInside)

    nextButtonTextButtonSprite = childNode(withName: "button-right") as! TextButtonSprite
    nextButtonTextButtonSprite.set(text: ">", fontSize: 150, autoResize: false)
    nextButtonTextButtonSprite.addTarget(self, selector: #selector(nextButtonClicked), forControlEvents: .TouchUpInside)

    previousButtonSKAControlSprite = childNode(withName: "button-left") as! TextButtonSprite
    previousButtonSKAControlSprite.set(text: "<", fontSize: 150, autoResize: false)
    previousButtonSKAControlSprite.addTarget(self, selector: #selector(previousButtonClicked), forControlEvents: .TouchUpInside)


    updateSideButtons()
  }

  override func attachedToAttachedToScene() {}

  override func detachedFromTachedFromScene() {}

  let spawnRate : TimeInterval = 0.25
  var currentSpawnTime : TimeInterval = 0

  override func updateTimeInterval(dt : TimeInterval) {
    currentSpawnTime += dt

    if currentSpawnTime > spawnRate {
      currentSpawnTime = 0

      spawnRaindrop()

      if Int(arc4random_uniform(20)) == 0 {
        spawnCat()
      }

      if Int(arc4random_uniform(50)) == 0 {
        spawnUmbrella()
      }
    }
  }

  func spawnCat() {
    let cat = CatSprite.newInstance()
    cat.position = getSpawnLocation()
    cat.zPosition = 0

    addChild(cat)
  }

  func spawnUmbrella() {
    let umbrella = UmbrellaSprite(palette: ColorManager.sharedInstance.getRandomPalette())
    umbrella.position = getSpawnLocation()
    umbrella.makeDynamic()

    addChild(umbrella)
  }

  func spawnRaindrop() {
    let rainDrop = RainDropSprite(scale: 2)
    rainDrop.position = CGPoint(x: size.width / 2, y:  size.height / 2)
    rainDrop.addPhysics()
    rainDrop.zPosition = 0

    rainDrop.position = getSpawnLocation()

    rainDrop.physicsBody?.linearDamping = CGFloat(arc4random()).truncatingRemainder(dividingBy: 100) / 100

    addChild(rainDrop)
  }

  func getSpawnLocation() -> CGPoint {
    var randomPosition = CGFloat(arc4random())
    randomPosition = randomPosition.truncatingRemainder(dividingBy: size.width)
    return CGPoint(x: randomPosition, y: size.height * 1.5)
  }

    @objc func nextButtonClicked() {
    if let instructionNode = currentNodeSKNode as? InstructionsNode {
      instructionNode.slideForwards()

      updateSideButtons()
    }
  }

    @objc func previousButtonClicked() {
    if let instructionNode = currentNodeSKNode as? InstructionsNode {
      instructionNode.slideBackwards()

      updateSideButtons()
    }
  }

  func navigateToScene() {


    if let parent = parent as? Router {
      var location : Location? = nil

      if currentNodeSKNode == classicSingleGroupInstructionsNode {
        location = .Classic
      } else if currentNodeSKNode == classicMultiGroupInstructionsNode {
        location = .ClassicMulti
      } else if currentNodeSKNode == lcdGroupInstructionsNode {
        location = .LCD
      } else if currentNodeSKNode == catPongGroupInstructionsNode {
        location = .CatPong
      }

      if let location = location {
        let extras = MenuExtras(rainScaleInScale: 1, catKittyScale: 1, transitionTransitionExtras: TransitionExtras(transitionType: .ScaleInCircular(fromPoint: CGPoint()), toColor: location == .LCD ? .black : RAIN_COLOR))

        parent.navigate(to: location, extras: extras)
      }

    }
  }

    @objc func backClicked() {
    if currentNodeSKNode == directionsGroupSKNode {
      if let parent = (parent as? Router) {
        parent.navigate(to: .MainMenu, extras: MenuExtras(rainScaleInScale: 0, catKittyScale: 0, transitionTransitionExtras: TransitionExtras(transitionType: .ScaleInLinearTop)))
      }
    } else {
      //show back in menu
      currentNodeSKNode.run(SKAction.group([
        SKAction.fadeAlpha(to: 0, duration: 0.5),
        SKActionHelper.moveToEaseInOut(x: size.width, duration: 0.55)
        ]))


      directionsGroupSKNode.run(SKAction.group([
        SKAction.fadeAlpha(to: 1, duration: 0.5),
        SKActionHelper.moveToEaseInOut(x: 0, duration: 0.55)
        ]))

      if let instructions = currentNodeSKNode as? InstructionsNode {
        instructions.hideNode()
      }

      currentNodeSKNode = directionsGroupSKNode

      updateSideButtons()
    }
  }

    @objc func directionsButtonClicked(_ sender: TwoPaneButton) {
    if sender == singleClassicButtonTwoPaneButtonSKAControlSprite {
      currentNodeSKNode = classicSingleGroupInstructionsNode
    } else if sender == lcdButtonTwoPaneButtonSKAControlSprite {
      currentNodeSKNode = lcdGroupInstructionsNode
    } else if sender == multiClassicButtonSKAControlSprite {
      currentNodeSKNode = classicMultiGroupInstructionsNode
    } else if sender == catPongButtonKACoTwoPaneButtonntrolSprite {
      currentNodeSKNode = catPongGroupInstructionsNode
    }

    (currentNodeSKNode as! InstructionsNode).showNode()
    currentNodeSKNode.run(SKAction.group([
      SKAction.fadeAlpha(to: 1, duration: 0.5),
      SKActionHelper.moveToEaseInOut(x: 0, duration: 0.55)
      ]))


    directionsGroupSKNode.run(SKAction.group([
      SKAction.fadeAlpha(to: 0, duration: 0.5),
      SKActionHelper.moveToEaseInOut(x: -size.width / 2, duration: 0.55)
      ]))

    updateSideButtons()
  }

  func updateSideButtons() {
    if let instructionNodeInstructionsNode = currentNodeSKNode as? InstructionsNode {
      nextButtonTextButtonSprite.alpha = instructionNodeInstructionsNode.hasNext() ? 1 : 0
      previousButtonSKAControlSprite.alpha = instructionNodeInstructionsNode.hasPrevious() ? 1 : 0
    } else {
      nextButtonTextButtonSprite.alpha  = 0
      previousButtonSKAControlSprite.alpha = 0
    }
  }

  func didBegin(_ contact: SKPhysicsContact) {
    if contact.bodyA.categoryBitMask == WorldFrameCategory {
      contact.bodyB.node?.removeFromParent()
    } else {
      contact.bodyA.node?.removeFromParent()
    }
  }
  
  deinit {
    print("directions scene is gone")
  }
}
