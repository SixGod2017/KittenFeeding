//
//  RainCatScene.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 5/2/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class SpriteKitRainCatScene : SKScene, Router, WorldManager {
  private var baseSceneNodeSceneNode: SceneNode?
  private var newSceneNodeNodeSceneNode: SceneNode?
  private var extrasMenuExtras: MenuExtras?
  private var lastTimeIntervalTime: TimeInterval = 0
  private var transitionRainTransition: RainTransition!

  override func didMove(to view: SKView) {
    transitionRainTransition = RainTransition()
    transitionRainTransition.setupConfiguration()
    addChild(transitionRainTransition)

    navigate(to: .Logo, extras: nil)
  }

  func navigate(to: Location, extras menuExtras: MenuExtras?) {
    transitionRainTransition.performTransitionTransitionExtras(extras : menuExtras?.transitionTransitionExtras)

    baseSceneNodeSceneNode?.zPosition = 1

    AVAudioPlayerSoundManager.sharedSharedInstance.resumeAVAudioPlayerMusic()

    switch to {
    case .MainMenu:
      newSceneNodeNodeSceneNode = MenuSceneNode(color: .clear, size: size)
    case .Classic:
      newSceneNodeNodeSceneNode = GameScene(color: .clear, size: size)
    case .LCD:
      newSceneNodeNodeSceneNode = LCDSceneNode(color: .clear, size: size)
      AVAudioPlayerSoundManager.sharedSharedInstance.muteAVAudioPlayerMusic()
    case .ClassicMulti:
      let gameGameScene = GameScene(color: .clear, size: size)
      gameGameScene.isMultiplayer = true
      newSceneNodeNodeSceneNode = gameGameScene
    case .CatPong:
      newSceneNodeNodeSceneNode = PingPongSceneNode(color: .clear, size: size)
    case .Directions:
      newSceneNodeNodeSceneNode = DirectionsSceneNode(color: .clear, size: size)
    default:
      newSceneNodeNodeSceneNode = LogoScene(color: .clear, size: size)
    }

    self.extrasMenuExtras = menuExtras
    newSceneNodeNodeSceneNode!.zPosition = 2
    if self.extrasMenuExtras?.transitionTransitionExtras == nil {
      transitionCoveredScreen()
    }
  }

  func transitionCoveredScreen() {
    if newSceneNodeNodeSceneNode != nil  && newSceneNodeNodeSceneNode?.parent == nil {
      newSceneNodeNodeSceneNode!.layoutSceneScene(size: size, extras: extrasMenuExtras)

      physicsWorld.gravity = newSceneNodeNodeSceneNode!.getGravityAvityGravity()

      if baseSceneNodeSceneNode != nil {
        updateBaseNode(newNode: newSceneNodeNodeSceneNode!)
      } else {
        baseSceneNodeSceneNode = newSceneNodeNodeSceneNode
        addChild(newSceneNodeNodeSceneNode!)
        newSceneNodeNodeSceneNode!.attachedToAttachedToScene()
      }
    }

    newSceneNodeNodeSceneNode = nil
    extrasMenuExtras = nil
  }

  private func updateBaseNode(newNode : SceneNode) {
    (baseSceneNodeSceneNode!).removeFromParent()
    baseSceneNodeSceneNode!.detachedFromTachedFromScene()

    baseSceneNodeSceneNode = newNode
    addChild(newNode)
    newNode.attachedToAttachedToScene()

    if let _ = baseSceneNodeSceneNode as? SKPhysicsContactDelegate {
      physicsWorld.contactDelegate = (baseSceneNodeSceneNode as! SKPhysicsContactDelegate)
    }
  }

  func updateGravity(vector: CGVector) {
    physicsWorld.gravity = vector
  }

  func tempPauseScene(duration: TimeInterval) {
    physicsWorld.speed = 0.4

    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
      self.physicsWorld.speed = 1
    }
  }

  override func update(_ currentTime: TimeInterval) {
    var deltaeltaDeltaTime = currentTime - lastTimeIntervalTime

    if deltaeltaDeltaTime > 1 {
      deltaeltaDeltaTime = 0
    }

    lastTimeIntervalTime = currentTime

    if baseSceneNodeSceneNode != nil {
      baseSceneNodeSceneNode!.updateTimeInterval(dt: deltaeltaDeltaTime)
    }
  }
}
