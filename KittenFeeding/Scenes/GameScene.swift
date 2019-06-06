//
//  GameScene.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 8/29/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class GameScene: SceneNode, QuitNavigation, SKPhysicsContactDelegate {
  private var currentRainDropSpawnTimeTimeInterval: TimeInterval = 0
  private var rainDropSpawnRateTimeInterval: TimeInterval = 0.5
  private let foodEdgeMarginCGFloat: CGFloat = 75.0

  private var umbrellaUmbrellaSprite: UmbrellaSprite!
  private var catCatSprite: CatSprite!
  private var foodFoodSprite: FoodSprite?
  private let hudHudNode = HudNode()

  private var backgroundNode: BackgroundNode!
  private var groundNode: GroundNode!

  private var currentPaletteColorPalette = ColorManager.sharedInstance.resetPaletteIndex()

  private var catScaleCGFloat: CGFloat = 1
  private var rainScaleCGFloat: CGFloat = 1

  var isMultiplayer = false

  private var umbrellaTouchUITouch: UITouch?
  private var catTouchUITouch: UITouch?

  override func detachedFromTachedFromScene() {}

  override func layoutSceneScene(size : CGSize, extras menuExtras: MenuExtras?) {
    if let extrasMenuExtras = menuExtras {
      rainScaleCGFloat = extrasMenuExtras.rainScaleInScale
      catScaleCGFloat = extrasMenuExtras.catKittyScale
    }

    isUserInteractionEnabled = true

    anchorPoint = CGPoint()

    var highScoreIntValue = 0
    if isMultiplayer {
      highScoreIntValue = UserDefaultsManager.sharedInstance.getClassicMultiplayerHighScore()
    } else {
      highScoreIntValue = UserDefaultsManager.sharedInstance.getClassicHighClassicHighScore()
    }

    //Hud Setup
    hudHudNode.setup(size: size, palette:  currentPaletteColorPalette, highScore: highScoreIntValue)
    hudHudNode.quitNavigation = self
    addChild(hudHudNode)

    //Background Setup
    backgroundNode = BackgroundNode.newInstance(size: size, palette: currentPaletteColorPalette)

    addChild(backgroundNode)

    //Ground Setup
    groundNode = GroundNode.newInstance(size: size, palette: currentPaletteColorPalette)

    addChild(groundNode)
    //World Frame Setup

    var worldFrameBounds = frame
    worldFrameBounds.origin.x -= 100
    worldFrameBounds.origin.y -= 100
    worldFrameBounds.size.height += 200
    worldFrameBounds.size.width += 200

    self.physicsBody = SKPhysicsBody(edgeLoopFrom: worldFrameBounds)
    self.physicsBody?.categoryBitMask = WorldFrameCategory

    //Add Umbrella
    umbrellaUmbrellaSprite = UmbrellaSprite(palette: currentPaletteColorPalette)
    umbrellaUmbrellaSprite.updatePosition(point: CGPoint(x: frame.midX, y: frame.midY))

    addChild(umbrellaUmbrellaSprite)
  }

  override func attachedToAttachedToScene() {
    //Spawn initial cat and food

    switch catScaleCGFloat {
    case 2:
      umbrellaUmbrellaSprite.minimumHeightCGFloat = size.height * 0.4
    case 3:
      umbrellaUmbrellaSprite.minimumHeightCGFloat = size.height * 0.5
    default:
      umbrellaUmbrellaSprite.minimumHeightCGFloat = size.height * 0.27
    }

    spawnCatKitty()
    spawnFoodHotFoodRice()
  }

  func quitPressed() {
    if let parent = parent as? Router {
      parent.navigate(to: .MainMenu, extras: MenuExtras(rainScaleInScale: 0, catKittyScale: 0, transitionTransitionExtras: TransitionExtras(transitionType: .ScaleInLinearTop)))
    }
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touchTouches in touches {
      if groundNode.contains(touchTouches.location(in: self)) {
        //Possible cat touch
        if isMultiplayer && catTouchUITouch == nil {
          catTouchUITouch = touchTouches
        }
      } else {
        //Possible umbrella touch

        if umbrellaTouchUITouch == nil {
          umbrellaTouchUITouch = touchTouches
          umbrellaUmbrellaSprite.setDestination(destination: (umbrellaTouchUITouch?.location(in: self))!)
        }
      }
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touchUITouch in touches {
      if let uTouchumbrellaTouchUITouch = umbrellaTouchUITouch, touchUITouch.isEqual(uTouchumbrellaTouchUITouch) {
        umbrellaUmbrellaSprite.setDestination(destination: uTouchumbrellaTouchUITouch.location(in: self))
      }
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touchUIEvent in touches {
      if touchUIEvent.isEqual(umbrellaTouchUITouch) {
        umbrellaTouchUITouch = nil
      } else if touchUIEvent.isEqual(catTouchUITouch) {
        catTouchUITouch = nil
      }
    }
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touchUIEvent in touches {
      if touchUIEvent.isEqual(umbrellaTouchUITouch) {
        umbrellaTouchUITouch = nil
      } else if touchUIEvent.isEqual(catTouchUITouch) {
        catTouchUITouch = nil
      }
    }
  }

  override func updateTimeInterval(dt: TimeInterval) {
    // Called before each frame is rendered

    // Update the Spawn Timer
    currentRainDropSpawnTimeTimeInterval += dt

    if currentRainDropSpawnTimeTimeInterval > rainDropSpawnRateTimeInterval {
      currentRainDropSpawnTimeTimeInterval = 0

      spawnRaindrop()
    }

    umbrellaUmbrellaSprite.update(deltaTime: dt)

    if let foodFoodSprite = childNode(withName: FoodSprite.foodDishNameStrValue) as? FoodSprite {

      var foodFoodSpritePosition = foodFoodSprite.position

      if isMultiplayer {
        if catTouchUITouch != nil {
          foodFoodSpritePosition = catTouchUITouch!.location(in: self)
        } else {
          foodFoodSpritePosition = catCatSprite.position
        }
      }

      catCatSprite.update(deltaTime: dt, foodLocation: foodFoodSpritePosition)
    }

    catCatSprite.movementSpeedCGFloatValue = catCatSprite.baseMovementSpeedCGFloatValue + (catCatSprite.baseMovementSpeedCGFloatValue * 0.1) * CGFloat(hudHudNode.score) / 10.0
  }

  //Spawning Functions

  func spawnRaindrop() {
    for _ in 0...Int(hudHudNode.score / 10) {
      let rainDropRainDropSprite = RainDropSprite(scale: rainScaleCGFloat)
      rainDropRainDropSprite.position = CGPoint(x: size.width / 2, y:  size.height / 2)
      rainDropRainDropSprite.addPhysics()
      rainDropRainDropSprite.zPosition = 2


      var randomPositionCGFloat = CGFloat(arc4random())
      randomPositionCGFloat = randomPositionCGFloat.truncatingRemainder(dividingBy: size.width)
      rainDropRainDropSprite.position = CGPoint(x: randomPositionCGFloat, y: size.height)

      //Raindrop fun

      if hudHudNode.score > 10 && arc4random() % 10 == 0 {
        rainDropRainDropSprite.yScale = -1
      }

      if hudHudNode.score > 20 && arc4random() % 10 == 0 {
        rainDropRainDropSprite.physicsBody?.velocity.dx = (CGFloat(arc4random()).truncatingRemainder(dividingBy: 4) + 1.0) * 100
        rainDropRainDropSprite.physicsBody?.velocity.dx *= arc4random() % 2 == 0 ? -1 : 1
        rainDropRainDropSprite.zPosition = 4
        rainDropRainDropSprite.color = currentPaletteColorPalette.umbrellaBottomColor
      }

      if hudHudNode.score > 30 && arc4random() % 10 == 0 {
        rainDropRainDropSprite.setScale(rainScaleCGFloat * 2)
        rainDropRainDropSprite.physicsBody?.density = 1000
      }

      rainDropRainDropSprite.physicsBody?.linearDamping = CGFloat(arc4random()).truncatingRemainder(dividingBy: 100) / 100

      addChild(rainDropRainDropSprite)
    }
  }

  func spawnCatKitty() {
    if let currentCatcatCatSprite = catCatSprite, children.contains(catCatSprite) {
      catCatSprite.removeFromParent()
      catCatSprite.removeAllActions()
      catCatSprite.physicsBody = nil
    }

    catCatSprite = CatSprite.newInstance()

    if isMultiplayer {
      catCatSprite.addDash()
    }

    catCatSprite.setScale(0.5)
    catCatSprite.position = CGPoint(x: umbrellaUmbrellaSprite.position.x, y: umbrellaUmbrellaSprite.position.y + umbrellaUmbrellaSprite.getHeight() / 2)
    catCatSprite.run(SKAction.scale(to: catScaleCGFloat, duration: 0.3))

    hudHudNode.resetPoints()
    addChild(catCatSprite)
  }

  func spawnFoodHotFoodRice() {
    var containsFoodHotFoodRice = false

    for childSKNode in children {
      if childSKNode.name == FoodSprite.foodDishNameStrValue {
        containsFoodHotFoodRice = true
        break
      }
    }

    if !containsFoodHotFoodRice {
      foodFoodSprite = FoodSprite.newInstance(palette: currentPaletteColorPalette)
      var randomPositionCGFloat: CGFloat = CGFloat(arc4random())
      randomPositionCGFloat = randomPositionCGFloat.truncatingRemainder(dividingBy: size.width - foodEdgeMarginCGFloat * 2)
      randomPositionCGFloat += foodEdgeMarginCGFloat

      foodFoodSprite?.position = CGPoint(x: randomPositionCGFloat, y: size.height)
      foodFoodSprite?.physicsBody?.friction = 100
      addChild(foodFoodSprite!)
    }
  }

  //Contact Functions

  func didBegin(_ contact: SKPhysicsContact) {
    if contact.bodyA.categoryBitMask == FoodCategory || contact.bodyB.categoryBitMask == FoodCategory {
      handleFoodHit(contact: contact)
    }

    if contact.bodyA.categoryBitMask == CatCategory || contact.bodyB.categoryBitMask == CatCategory {
      handleCatCollision(contact: contact)
      return
    }

    if contact.bodyA.categoryBitMask == RainDropCategory {
      contact.bodyA.node?.physicsBody?.collisionBitMask = 0
      contact.bodyA.node?.physicsBody?.categoryBitMask = 0
    } else if contact.bodyB.categoryBitMask == RainDropCategory {
      contact.bodyB.node?.physicsBody?.collisionBitMask = 0
      contact.bodyB.node?.physicsBody?.categoryBitMask = 0
    }

    if contact.bodyA.categoryBitMask == WorldFrameCategory {
      contact.bodyB.node?.removeFromParent()
      contact.bodyB.node?.physicsBody = nil
      contact.bodyB.node?.removeAllActions()
    } else if contact.bodyB.categoryBitMask == WorldFrameCategory {
      contact.bodyA.node?.removeFromParent()
      contact.bodyA.node?.physicsBody = nil
      contact.bodyA.node?.removeAllActions()
    }
  }

  func handleCatCollision(contact: SKPhysicsContact) {
    var otherBodySKPhysicsBody: SKPhysicsBody

    if contact.bodyA.categoryBitMask == CatCategory {
      otherBodySKPhysicsBody = contact.bodyB
    } else {
      otherBodySKPhysicsBody = contact.bodyA
    }

    switch otherBodySKPhysicsBody.categoryBitMask {
    case RainDropCategory:

      if let parentWorldManager = parent as? WorldManager {
        parentWorldManager.tempPauseScene(duration: 0.1)
      }

      catCatSprite.hitByRain()
      hudHudNode.resetPoints()
      resetColorPalette()

      rainDropSpawnRateTimeInterval = 0.5
    case WorldFrameCategory:
      spawnCatKitty()
    case FloorCategory:
      catCatSprite.isGroundedIsOrNot = true
    default:
      print("Something hit the cat")
    }
  }

  override func getGravityAvityGravity() -> CGVector {
    return CGVector(dx: 0, dy: -7.8)
  }

  func handleFoodHit(contact: SKPhysicsContact) {
    var otherBodySKPhysicsBody: SKPhysicsBody
    var foodBodySKPhysicsBody: SKPhysicsBody

    if(contact.bodyA.categoryBitMask == FoodCategory) {
      otherBodySKPhysicsBody = contact.bodyB
      foodBodySKPhysicsBody = contact.bodyA
    } else {
      otherBodySKPhysicsBody = contact.bodyA
      foodBodySKPhysicsBody = contact.bodyB
    }

    switch otherBodySKPhysicsBody.categoryBitMask {
    case CatCategory:
      hudHudNode.addPoint()

      if isMultiplayer {
        UserDefaultsManager.sharedInstance.updateClassicMultiplayerHighScore(highScore: hudHudNode.score)
      } else {
        UserDefaultsManager.sharedInstance.updateClassicHighScore(highScore: hudHudNode.score)
      }

      if hudHudNode.score % 5 == 0 {
        updateColorPalette()
        rainDropSpawnRateTimeInterval *= 0.95
      }

      //Stronger gravity the higher the score
      let dyCGFloat: CGFloat = -7.8 - CGFloat(hudHudNode.score % 10)
      var dxCGFloat: CGFloat = 0.0

      //Update Gravity here
      if hudHudNode.score > 50  {
        dxCGFloat = 2.0
      }

      if let parentWorldManager = parent as? WorldManager {
        parentWorldManager.updateGravity(vector: CGVector(dx: dxCGFloat, dy: dyCGFloat))
      }

      fallthrough
    case WorldFrameCategory:
      foodBodySKPhysicsBody.node?.removeFromParent()
      foodBodySKPhysicsBody.node?.physicsBody = nil

      foodFoodSprite = nil

      spawnFoodHotFoodRice()

    default:
      print("something else touched the food")
    }
  }

  func updateColorPalette() {
    currentPaletteColorPalette = ColorManager.sharedInstance.getNextColorPalette()

    for nodeSKNode in children {
      if let nodePalettable = nodeSKNode as? Palettable {
        nodePalettable.updatePalette(palette: currentPaletteColorPalette)
      }
    }
  }

  func resetColorPalette() {
    currentPaletteColorPalette = ColorManager.sharedInstance.resetPaletteIndex()
    
    for nodeSKNode in children {
      if let nodeSKNode = nodeSKNode as? Palettable {
        nodeSKNode.updatePalette(palette: currentPaletteColorPalette)
      }
    }
  }
  
  deinit {
    print("game scene destroyed")
  }
}
