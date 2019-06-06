//
//  PingPongScene.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 9/17/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class PingPongSceneNode : SceneNode, PingPongNavigation, SKPhysicsContactDelegate {
  private var umbrella1UmbrellaSprite: UmbrellaSprite!
  private var umbrella2UmbrellaSprite: UmbrellaSprite!

  private let cat1CatSprite = CatSprite.newInstance()
  private let cat2CatSprite = CatSprite.newInstance()

  private let hudPingPongHud = PingPongHud()

  private var puckSKSpriteNode: SKSpriteNode?

  private let backgroundNode = PingPongBackgroundNode()

  private var player1PaletteColorPalette: ColorPalette!
  private var player2PaletteColorPalette: ColorPalette!

  //Track finger movement based on touches
  private var p1TouchUITouch: UITouch?
  private var p2TouchUITouch: UITouch?

  private var lastUpdateTimeTimeInterval: TimeInterval = 0
  private let maxNoHitTimeTimeInterval: TimeInterval = 5
  private var currentNoHitTimeTimeInterval: TimeInterval = 0
  private var lastPaddleHitTimeInterval: TimeInterval = 0

  private var cat1DestinationCGPoint = CGPoint()
  private var cat2DestinationCGPoint = CGPoint()

  private var cat1ZeroPositionCGPoint = CGPoint()
  private var cat2ZeroPositionCGPoint = CGPoint()

  private var umbrella1ZeroPositionCGPoint = CGPoint()
  private var umbrella2ZeroPositionCGPoint = CGPoint()

  private let umbrellaScaleCGFloat: CGFloat = 0.85

  private let p1CGFloatRotation = CGFloat.pi / -2.0
  private let p2CGFloatRotation = CGFloat.pi / 2.0

  private let cat1KeyPLAYER_ONE_CAT = "PLAYER_ONE_CAT"
  private let cat2KeyPLAYER_TWO_CAT = "PLAYER_TWO_CAT"

  private let maxPointsVIntValue = 7

  private var rainScaleCGFloat: CGFloat = 1
  private var catScaleCGFloat: CGFloat = 1

  private var destinationOffsetCGFloat: CGFloat = 50

  private var deadZoneCGFloat:CGFloat = 150

  private var cat1XCGFloat: CGFloat = 0
  private var cat2XCGFloat: CGFloat = 0

  private var catHitIsOrNot = false
  private var p1LastHitIsOrNot = false

  private var roundStartedIsOrNot = false
  private var showingWinConditionIsOrNot = false
  private var giantModeIsOrNot = false

  override func attachedToAttachedToScene() {}
  override func detachedFromTachedFromScene() {}

  override func layoutSceneScene(size : CGSize, extras menuExtras: MenuExtras?) {

    if let extrasmenuExtras = menuExtras {
      rainScaleCGFloat = extrasmenuExtras.rainScaleInScale
      catScaleCGFloat = extrasmenuExtras.catKittyScale
    }

    if catScaleCGFloat > 2 {
      giantModeIsOrNot = true
    }

    isUserInteractionEnabled = true
    anchorPoint = CGPoint()

    color = SKColor(red:0.38, green:0.60, blue:0.65, alpha:1.0)

    player1PaletteColorPalette = ColorManager.sharedInstance.getColorPalette(UserDefaultsManager.sharedInstance.playerOneOneOnePalette)
    player2PaletteColorPalette = ColorManager.sharedInstance.getColorPalette(UserDefaultsManager.sharedInstance.playerTwoTwoTwoTwoPalette)

    if giantModeIsOrNot {
      deadZoneCGFloat = 75
    }

    hudPingPongHud.setup(size: size)
    hudPingPongHud.pingPongNavigation = self
    
    addChild(hudPingPongHud)

    backgroundNode.setup(frame: frame, deadZone: deadZoneCGFloat, playerOnePalette: player1PaletteColorPalette, playerTwoPalette: player2PaletteColorPalette)
    addChild(backgroundNode)

    physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    physicsBody?.restitution = 0.4
    physicsBody?.friction = 0.1

    configureUmbrellas()
    configureCats()

    resetplayerOnePuckIsOrNotLocations(arc4random() % 2 == 0) //random start location
  }

  private func puckConfiguration() {
    if puckSKSpriteNode == nil {
      puckSKSpriteNode = SKSpriteNode(imageNamed: "medium_rain_drop")
    }

    puckSKSpriteNode!.setScale(rainScaleCGFloat)
    puckSKSpriteNode!.zPosition = 4
    let centerPoint = CGPoint(x: 0, y: -puckSKSpriteNode!.size.height * 0.1)
    puckSKSpriteNode!.physicsBody = SKPhysicsBody(circleOfRadius: puckSKSpriteNode!.size.height / 4, center: centerPoint)
    puckSKSpriteNode!.physicsBody?.categoryBitMask = RainDropCategory
    puckSKSpriteNode!.physicsBody?.contactTestBitMask = UmbrellaCategory | WorldFrameCategory | CatCategory
    puckSKSpriteNode!.physicsBody?.restitution = 0.85
    puckSKSpriteNode!.physicsBody?.mass = 0.02
    puckSKSpriteNode!.physicsBody?.linearDamping = 0.5
    puckSKSpriteNode!.colorBlendFactor = 1
    puckSKSpriteNode?.color = RAIN_COLOR

    addChild(puckSKSpriteNode!)
  }

  private func configureCats() {
    cat1CatSprite.physicsBody?.collisionBitMask = RainDropCategory
    cat2CatSprite.physicsBody?.collisionBitMask = RainDropCategory

    cat1CatSprite.name = cat1KeyPLAYER_ONE_CAT
    cat2CatSprite.name = cat2KeyPLAYER_TWO_CAT

    cat1CatSprite.physicsBody?.linearDamping = 0
    cat2CatSprite.physicsBody?.linearDamping = 0

    cat1CatSprite.walkHorizontallyIsOrNot = false
    cat2CatSprite.walkHorizontallyIsOrNot = false

    cat1CatSprite.isGroundedIsOrNot = true
    cat2CatSprite.isGroundedIsOrNot = true

    cat1CatSprite.setScale(catScaleCGFloat)
    cat2CatSprite.setScale(catScaleCGFloat)

    cat1CatSprite.zRotation = p1CGFloatRotation
    cat1CatSprite.flipScaleIsOrNot = true
    cat2CatSprite.zRotation = p2CGFloatRotation

    cat1XCGFloat = cat1CatSprite.size.height * 0.55
    cat2XCGFloat = frame.maxX - cat2CatSprite.size.height * 0.6

    cat1ZeroPositionCGPoint = CGPoint(x:cat1XCGFloat,  y: frame.midY)

    cat1CatSprite.position = cat1ZeroPositionCGPoint
    cat1DestinationCGPoint = cat1CatSprite.position
    cat1DestinationCGPoint.y = destinationOffsetCGFloat

    cat2ZeroPositionCGPoint = CGPoint(x: cat2XCGFloat, y: frame.midY)
    cat2CatSprite.position = cat2ZeroPositionCGPoint
    cat2DestinationCGPoint.y = frame.height - destinationOffsetCGFloat

    addChild(cat1CatSprite)
    addChild(cat2CatSprite)
  }

  private func configureUmbrellas() {
    umbrella1UmbrellaSprite = UmbrellaSprite(palette: player1PaletteColorPalette, pingPong: true)
    umbrella2UmbrellaSprite = UmbrellaSprite(palette: player2PaletteColorPalette, pingPong: true)

    umbrella1UmbrellaSprite.physicsBody?.restitution = 0.1
    umbrella2UmbrellaSprite.physicsBody?.restitution = 0.1

    umbrella1UmbrellaSprite.setScale(umbrellaScaleCGFloat)
    umbrella2UmbrellaSprite.setScale(umbrellaScaleCGFloat)

    //Rotate our umbrellas!
    umbrella1UmbrellaSprite.zRotation = p1CGFloatRotation
    umbrella2UmbrellaSprite.zRotation = p2CGFloatRotation

    umbrella1ZeroPositionCGPoint = CGPoint(x: 150, y: frame.midY)
    umbrella2ZeroPositionCGPoint = CGPoint(x: frame.maxX - 150, y: frame.midY)

    umbrella1UmbrellaSprite.updatePosition(point: umbrella1ZeroPositionCGPoint)
    umbrella2UmbrellaSprite.updatePosition(point: umbrella2ZeroPositionCGPoint)


    addChild(umbrella1UmbrellaSprite)
    addChild(umbrella2UmbrellaSprite)
  }

  private func resetplayerOnePuckIsOrNotLocations(_ playerOnePuck : Bool) {
    hudPingPongHud.showQuitButton()

    cat1CatSprite.physicsBody?.velocity = CGVector()
    cat1CatSprite.physicsBody?.angularVelocity = 0

    cat2CatSprite.physicsBody?.velocity = CGVector()
    cat2CatSprite.physicsBody?.angularVelocity = 0

    umbrella1UmbrellaSprite.run(SKAction.move(to: umbrella1ZeroPositionCGPoint, duration: 0.25))
    umbrella1UmbrellaSprite.setDestination(destination: umbrella1ZeroPositionCGPoint)

    umbrella2UmbrellaSprite.run(SKAction.move(to: umbrella2ZeroPositionCGPoint, duration: 0.25))
    umbrella2UmbrellaSprite.setDestination(destination: umbrella2ZeroPositionCGPoint)

    cat1DestinationCGPoint = cat1ZeroPositionCGPoint
    cat1DestinationCGPoint.y = destinationOffsetCGFloat

    cat2DestinationCGPoint = cat2ZeroPositionCGPoint
    cat2DestinationCGPoint.y = frame.height - destinationOffsetCGFloat

    cat1CatSprite.run(SKAction.move(to: cat1ZeroPositionCGPoint, duration: 0.25))
    cat2CatSprite.run(SKAction.move(to: cat2ZeroPositionCGPoint, duration: 0.25))

    cat1CatSprite.run(SKAction.rotate(toAngle: p1CGFloatRotation, duration: 0.25))
    cat2CatSprite.run(SKAction.rotate(toAngle: p2CGFloatRotation, duration: 0.25))

    currentNoHitTimeTimeInterval = 0

    catHitIsOrNot = false
    roundStartedIsOrNot = false

    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(200)) {
      self.puckSKSpriteNode?.removeFromParent()
      self.puckConfiguration()

      if playerOnePuck {
        self.puckSKSpriteNode?.position = CGPoint(x: self.frame.midX - self.deadZoneCGFloat - 65, y: self.frame.height * (self.umbrella1UmbrellaSprite.position.y > self.frame.height / 2 ? 0.25 : 0.75))
      } else {
        self.puckSKSpriteNode?.position = CGPoint(x: self.frame.midX + self.deadZoneCGFloat + 65, y: self.frame.height * (self.umbrella2UmbrellaSprite.position.y > self.frame.height / 2 ? 0.25 : 0.75))
      }
    }
  }

  func quitPressed() {
    if let routerParent = parent as? Router {
      routerParent.navigate(to: .MainMenu, extras: MenuExtras(rainScaleInScale: 0, catKittyScale: 0, transitionTransitionExtras: TransitionExtras(transitionType: .ScaleInChecker)))
    }
  }

  func restartPressed() {
    let player1LostIsOrNot = hudPingPongHud.playerTwoScoreIntValue >= maxPointsVIntValue

    hudPingPongHud.hideRematchButton()
    hudPingPongHud.hideMessage()
    hudPingPongHud.resetScore()

    let showActionSKAction = SKAction.fadeIn(withDuration: 0.25)

    cat1CatSprite.run(showActionSKAction)
    cat2CatSprite.run(showActionSKAction)

    umbrella1UmbrellaSprite.run(showActionSKAction)
    umbrella2UmbrellaSprite.run(showActionSKAction)

    backgroundNode.run(showActionSKAction)

    let umbrellaScaleActionSKAction = SKAction.scale(to: umbrellaScaleCGFloat, duration: 0.25)

    umbrella1UmbrellaSprite.run(umbrellaScaleActionSKAction)
    umbrella2UmbrellaSprite.run(umbrellaScaleActionSKAction)

    umbrella1UmbrellaSprite.run(SKAction.rotate(toAngle: p1CGFloatRotation, duration: 0.25))
    umbrella2UmbrellaSprite.run(SKAction.rotate(toAngle: p2CGFloatRotation, duration: 0.25))

    showingWinConditionIsOrNot = false
    catHitIsOrNot = false
    roundStartedIsOrNot = false

    puckSKSpriteNode?.removeFromParent()
    puckSKSpriteNode = nil

    puckConfiguration()
    resetplayerOnePuckIsOrNotLocations(player1LostIsOrNot)
  }

  override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      if catHitIsOrNot { return }
      for touchUITouch in touches {
        var locationPoint = touchUITouch.location(in: self)

        if locationPoint.x < frame.midX {
          if p1TouchUITouch == nil {
            p1TouchUITouch = touchUITouch

            if locationPoint.x > frame.midX - deadZoneCGFloat {
              locationPoint.x = frame.midX - deadZoneCGFloat
            }

            umbrella1UmbrellaSprite.setDestination(destination: locationPoint)
          }
        } else {
          if p2TouchUITouch == nil {
            p2TouchUITouch = touchUITouch

            if locationPoint.x < frame.midX + deadZoneCGFloat {
              locationPoint.x = frame.midX + deadZoneCGFloat
            }

            umbrella2UmbrellaSprite.setDestination(destination: locationPoint)
          }
        }
    }
  }

  override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      if catHitIsOrNot { return }

      for tUITouchouchUIEvent in touches {
        var locationPoint = tUITouchouchUIEvent.location(in: self)

        if p1TouchUITouch == tUITouchouchUIEvent {
          if locationPoint.x > frame.midX - deadZoneCGFloat {
            locationPoint.x = frame.midX - deadZoneCGFloat
          }

          umbrella1UmbrellaSprite.setDestination(destination: locationPoint)
        } else if p2TouchUITouch == tUITouchouchUIEvent {
          if locationPoint.x < frame.midX + deadZoneCGFloat {
            locationPoint.x = frame.midX + deadZoneCGFloat
          }

          umbrella2UmbrellaSprite.setDestination(destination: locationPoint)
        }
      }
  }

  override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touchtouchesEnded in touches {
      if p1TouchUITouch == touchtouchesEnded {
        p1TouchUITouch = nil
      } else if p2TouchUITouch == touchtouchesEnded {
        p2TouchUITouch = nil
      }
    }
  }

  public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touchtouchesCancelled in touches {
      if p1TouchUITouch == touchtouchesCancelled {
        p1TouchUITouch = nil
      } else if p2TouchUITouch == touchtouchesCancelled {
        p2TouchUITouch = nil
      }
    }
  }

  override func getGravityAvityGravity() -> CGVector {
    return CGVector(dx: 0, dy: 0)
  }

  var lastTouchTimeInterval: TimeInterval = 0

  override func updateTimeInterval(dt : TimeInterval) { //check if raindrop is outside bounds, then reset
    lastPaddleHitTimeInterval += dt

    if showingWinConditionIsOrNot {
      return
    }

    if roundStartedIsOrNot {
      currentNoHitTimeTimeInterval += dt
    }

    if currentNoHitTimeTimeInterval > maxNoHitTimeTimeInterval {
      resetplayerOnePuckIsOrNotLocations(false)
    }

    umbrella1UmbrellaSprite.update(deltaTime: dt)
    umbrella2UmbrellaSprite.update(deltaTime: dt)

    if abs(cat1CatSprite.position.y - cat1DestinationCGPoint.y) < 30 {
      if cat1CatSprite.position.y < frame.midY {
        cat1DestinationCGPoint.y = frame.height - destinationOffsetCGFloat
      } else {
        cat1DestinationCGPoint.y = destinationOffsetCGFloat
      }
    }

    cat1DestinationCGPoint.x = cat1XCGFloat
    cat1CatSprite.update(deltaTime: dt, foodLocation: cat1DestinationCGPoint)

    if abs(cat2CatSprite.position.y - cat2DestinationCGPoint.y) < 30 {
      if cat2CatSprite.position.y < frame.midY {
        cat2DestinationCGPoint.y = frame.height - destinationOffsetCGFloat
      } else {
        cat2DestinationCGPoint.y = destinationOffsetCGFloat
      }
    }

    cat2DestinationCGPoint.x = cat2XCGFloat
    cat2CatSprite.update(deltaTime: dt, foodLocation: cat2DestinationCGPoint)
  }

  public func didBegin(_ contact: SKPhysicsContact) {
    if puckSKSpriteNode == nil {
      return
    }
    
    //So far only the rain drop and something else can come into contact
    var otherBodySKPhysicsBody: SKPhysicsBody

    if contact.bodyA.categoryBitMask == RainDropCategory {
      otherBodySKPhysicsBody = contact.bodyB
    } else if contact.bodyB.categoryBitMask == RainDropCategory {
      otherBodySKPhysicsBody = contact.bodyA
    } else {
      return
    }

    switch otherBodySKPhysicsBody.categoryBitMask {
    case UmbrellaCategory:

      if !roundStartedIsOrNot {
        hudPingPongHud.hideQuitButton()
      }

      roundStartedIsOrNot = true

      let isPlayer1Hit = otherBodySKPhysicsBody.node?.parent == umbrella1UmbrellaSprite

      if lastPaddleHitTimeInterval < 0.3 && (isPlayer1Hit && p1LastHitIsOrNot || !isPlayer1Hit && !p1LastHitIsOrNot) {
        return
      }


      if otherBodySKPhysicsBody.velocity.dx == 0 || otherBodySKPhysicsBody.velocity.dy == 0 {

      } else {
        puckSKSpriteNode?.physicsBody?.angularVelocity = 0.0
        puckSKSpriteNode?.physicsBody?.velocity = CGVector()
      }

      var impulse = (otherBodySKPhysicsBody.node?.parent as? UmbrellaSprite)!.getVelocity()

      let max : CGFloat = 15

      //Check who hit the puck last
      p1LastHitIsOrNot = isPlayer1Hit

      if abs(impulse.dx) > max {
        impulse.dx = max * ((impulse.dx > 1) ? 1 : -1)
      }

      if abs(impulse.dy) > max {
        impulse.dy = max * ((impulse.dy > 1) ? 1 : -1)
      }

      puckSKSpriteNode?.physicsBody?.applyImpulse(impulse)

      var umbrella : UmbrellaSprite

      if umbrella1UmbrellaSprite.isEqual(otherBodySKPhysicsBody.node) {
        umbrella = umbrella1UmbrellaSprite
      } else {
        umbrella = umbrella2UmbrellaSprite
      }

      puckSKSpriteNode!.run(ColorAction().colorTransitionAction(fromColor: puckSKSpriteNode!.color, toColor: umbrella.paletteColorPalette.umbrellaTopColor,
                                                    duration: 0.25))

      lastPaddleHitTimeInterval = 0
      currentNoHitTimeTimeInterval = 0
    case CatCategory:
      if !roundStartedIsOrNot {
        return
      }

      if !catHitIsOrNot {
        catHitIsOrNot = true

        puckSKSpriteNode?.physicsBody = nil
        puckSKSpriteNode?.removeFromParent()
        puckSKSpriteNode = nil

        if otherBodySKPhysicsBody.node?.name == cat1KeyPLAYER_ONE_CAT {
          hudPingPongHud.incrementPlayerTwo()

          if hudPingPongHud.playerTwoScoreIntValue >= maxPointsVIntValue {
            hudPingPongHud.showMessageIndefinitely(message: "Cat 2 WINS")

            showWinner()
            return
          } else if p1LastHitIsOrNot {
            hudPingPongHud.showMessage(message: "Cat 1 scored for Cat 2!")
          } else {
            hudPingPongHud.showMessage(message: "Cat 2 scored!")
          }

          cat1CatSprite.hitByRain()
          cat1CatSprite.removeAllActions()
          AVAudioPlayerSoundManager.sharedSharedInstance.meow(node: cat1CatSprite)
          cat1CatSprite.physicsBody?.angularVelocity = 0.75

          p1LastHitIsOrNot = true
        } else if otherBodySKPhysicsBody.node?.name == cat2KeyPLAYER_TWO_CAT {
          hudPingPongHud.incrementPlayerOne()

          if hudPingPongHud.playerOneScoreIntValue >= maxPointsVIntValue {
            hudPingPongHud.showMessageIndefinitely(message: "Cat 1 WINS")

            showWinner()

            return
          } else if !p1LastHitIsOrNot {
            hudPingPongHud.showMessage(message: "Cat 2 scored for Cat 1!")
          } else {
            hudPingPongHud.showMessage(message: "Cat 1 scored!")
          }

          cat2CatSprite.hitByRain()
          cat2CatSprite.removeAllActions()
          AVAudioPlayerSoundManager.sharedSharedInstance.meow(node: cat2CatSprite)
          cat2CatSprite.physicsBody?.angularVelocity = 0.75

          p1LastHitIsOrNot = false
        } else {
          print("wtf")
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
          self.resetplayerOnePuckIsOrNotLocations(self.p1LastHitIsOrNot)
        }
      }

    default:
      break
    }
  }

  private func showWinner() {
    showingWinConditionIsOrNot = true
    hudPingPongHud.showRematchButton()

    let winAnimationotherBodySKPhysicsBody = SKAction.group([
      SKAction.rotate(toAngle: 0, duration: 0.25),
      SKAction.scale(to: 2, duration: 0.25),
      SKAction.move(to: CGPoint(x: frame.midX, y: frame.midY), duration: 0.25)
      ])

    let fadeOutActionSKAction = SKAction.fadeOut(withDuration: 0.25)
    
    backgroundNode.run(fadeOutActionSKAction)
    puckSKSpriteNode?.run(fadeOutActionSKAction)
    
    if hudPingPongHud.playerTwoScoreIntValue >= maxPointsVIntValue {
      //P2 wins
      umbrella2UmbrellaSprite.run(winAnimationotherBodySKPhysicsBody)
      umbrella1UmbrellaSprite.run(fadeOutActionSKAction)
      
      cat2CatSprite.run(fadeOutActionSKAction)
      
    } else if hudPingPongHud.playerOneScoreIntValue >= maxPointsVIntValue {
      //P1 wins
      umbrella1UmbrellaSprite.run(winAnimationotherBodySKPhysicsBody)
      umbrella2UmbrellaSprite.run(fadeOutActionSKAction)
      
      cat1CatSprite.run(fadeOutActionSKAction)
    }
    
    umbrella1UmbrellaSprite.physicsBody = nil
    umbrella2UmbrellaSprite.physicsBody = nil
    puckSKSpriteNode?.physicsBody = nil
  }
  
  deinit {
    print("pingpong scene destroyed")
  }
}
