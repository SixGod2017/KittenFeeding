//
//  RainTransition.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 5/23/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class RainTransition : SKNode {

  var spritesSKSpriteNode = [[SKSpriteNode]]()
  var spriteNameDictDictionary = [String : Int]()

  func setupConfiguration() {
    zPosition = 2000
    let scene = SKScene(fileNamed: "RainTransition")
    var rowIndex = 0
    var colIndex = 0

    var currentSpriteSKNode = scene?.childNode(withName: getSpriteNameParamISRowAndColReturnString(row: rowIndex, col: colIndex))

    while currentSpriteSKNode != nil {
      currentSpriteSKNode?.removeFromParent()
      addChild(currentSpriteSKNode!)

      currentSpriteSKNode?.alpha = 0

      spriteNameDictDictionary.updateValue(children.index(of: currentSpriteSKNode!)!, forKey: currentSpriteSKNode!.name!)

      if rowIndex == 0 {
        spritesSKSpriteNode.append([SKSpriteNode]())
      }

      spritesSKSpriteNode[colIndex].append(currentSpriteSKNode as! SKSpriteNode)

      rowIndex += 1

      currentSpriteSKNode = scene?.childNode(withName: getSpriteNameParamISRowAndColReturnString(row: rowIndex, col: colIndex))

      //Check for end of row, if nil get next column
      if currentSpriteSKNode == nil {
        print("Sprites in col: \(colIndex) is \(spritesSKSpriteNode[colIndex].count)")

        rowIndex = 0
        colIndex += 1

        currentSpriteSKNode = scene?.childNode(withName: getSpriteNameParamISRowAndColReturnString(row: rowIndex, col: colIndex))
      }
    }
  }

  func performTransitionTransitionExtras(extras : TransitionExtras?) {
    if let extrasTransitionExtras = extras {
      switch extrasTransitionExtras.transitionType {
      case .ScaleInCircular(let point):
        performScaleSpiralToScaleAtPointFromColor(toScale: 1, atPoint: point, fromColor: extrasTransitionExtras.fromColor, toColor: extrasTransitionExtras.toColor)

      case .ScaleInEvenOddColumn:
        performScaleInEvenOddFromColorToColor(fromColor: extrasTransitionExtras.fromColor, toColor: extrasTransitionExtras.toColor)
      case .ScaleInChecker:
        performScaleInCheckerFromColorToColor(fromColor: extrasTransitionExtras.fromColor, toColor: extrasTransitionExtras.toColor)
      case .ScaleInLinearTop:
        performScaleInLinearTopFromColorTopTopToColor(fromColor: extrasTransitionExtras.fromColor, toColor: extrasTransitionExtras.toColor)
      case .ScaleInUniform:
        performScaleInUniform(fromColor: extrasTransitionExtras.fromColor, toColor: extrasTransitionExtras.toColor)
      }
    }
  }

  func performScaleInUniform(fromColor : SKColor, toColor : SKColor) {
    for columnIndex in spritesSKSpriteNode {
      for rowIndex in columnIndex {
        let scaleAnimScaleAnimation = getScaleAnimationFromColorToColorToScaleReturnSKAction(fromColor: fromColor, toColor: toColor, toScale: 1)
        rowIndex.run(scaleAnimScaleAnimation)
      }
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
      (self.parent as! Router).transitionCoveredScreen()

      self.performScaleOutUniformFromColorToColor(fromColor: toColor, toColor: toColor)
    }
  }

  private func performScaleOutUniformFromColorToColor(fromColor : SKColor, toColor : SKColor) {
    for columnIndex in spritesSKSpriteNode {
      for rowIndex in columnIndex {
        let scaleAnimScaleAnimation = getScaleAnimationFromColorToColorToScaleReturnSKAction(fromColor: fromColor, toColor: toColor, toScale: 0)

        rowIndex.run(scaleAnimScaleAnimation)
      }
    }
  }

  func performScaleInEvenOddFromColorToColor(fromColor : SKColor, toColor : SKColor)  {
    let scaleAnimGetScaleAnimation = getScaleAnimationFromColorToColorToScaleReturnSKAction(fromColor: fromColor, toColor: toColor, toScale: 1)

    for colIndex in 0 ..< spritesSKSpriteNode.count {
      for rowIndex in 0 ..< spritesSKSpriteNode[colIndex].count {
        let nodeSKSpriteNode = spritesSKSpriteNode[colIndex][rowIndex]
        nodeSKSpriteNode.alpha = 1
        nodeSKSpriteNode.scale(to: CGSize())

        let delay = isEvenParamNumberReturnBool(number: rowIndex)

        nodeSKSpriteNode.run(SKAction.sequence([
          SKAction.wait(forDuration: 0.3 * (delay ? 0 : 1)),
          scaleAnimGetScaleAnimation
        ]))
      }
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      (self.parent as! Router).transitionCoveredScreen()

      self.performScaleOutEvenOddFromColorToColor(fromColor: toColor, toColor: toColor)
    }
  }

  private func performScaleOutEvenOddFromColorToColor(fromColor : SKColor, toColor : SKColor) {
    let scaleAnimGetScaleAnimation = getScaleAnimationFromColorToColorToScaleReturnSKAction(fromColor: fromColor, toColor: toColor, toScale: 1)

    for colIndex in 0 ..< spritesSKSpriteNode.count {

      for rowIndex in 0 ..< spritesSKSpriteNode[colIndex].count {
        let nodeSKSpriteNode = spritesSKSpriteNode[colIndex][rowIndex]
        let delayIsOrNot = isEvenParamNumberReturnBool(number: rowIndex)

        nodeSKSpriteNode.run(SKAction.sequence([
          SKAction.wait(forDuration: 0.3 * (delayIsOrNot ? 0 : 1)),
          scaleAnimGetScaleAnimation
        ]))
      }
    }
  }

  func performScaleInCheckerFromColorToColor(fromColor : SKColor, toColor : SKColor) {
    let scaleAnimScaleAnimationScaleAnimation = getScaleAnimationFromColorToColorToScaleReturnSKAction(fromColor: fromColor, toColor: toColor, toScale: 1)

    for colCount in 0 ..< spritesSKSpriteNode.count {
      for rowCount in 0 ..< spritesSKSpriteNode[colCount].count {
        let nodeSKSpriteNodeSKSpriteNode = spritesSKSpriteNode[colCount][rowCount]
        nodeSKSpriteNodeSKSpriteNode.alpha = 1.0
        nodeSKSpriteNodeSKSpriteNode.scale(to: CGSize())

        let delayIsOrNot = isEvenParamNumberReturnBool(number: rowCount) && isEvenParamNumberReturnBool(number: colCount) || !isEvenParamNumberReturnBool(number: rowCount) && isEvenParamNumberReturnBool(number: colCount)

        nodeSKSpriteNodeSKSpriteNode.run(SKAction.sequence([
          SKAction.wait(forDuration: 0.3 * (delayIsOrNot ? 0 : 1)),
          scaleAnimScaleAnimationScaleAnimation
          ]))
      }
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 1.55) {
      (self.parent as! Router).transitionCoveredScreen()

      self.performScaleOutCheckerFromColorToColor(fromColor: toColor, toColor: toColor)
    }
  }

  private func performScaleOutCheckerFromColorToColor(fromColor : SKColor, toColor : SKColor) {
    let scaleAnimScaleAnimationScaleAnimation = getScaleAnimationFromColorToColorToScaleReturnSKAction(fromColor: fromColor, toColor: toColor, toScale: 0)

    for colCountIndex in 0 ..< spritesSKSpriteNode.count {
      for rowCountIndex in 0 ..< spritesSKSpriteNode[colCountIndex].count {
        let nodeSKSpriteNodeSKSpriteNode = spritesSKSpriteNode[colCountIndex][rowCountIndex]
        let delayIsOrNot = !isEvenParamNumberReturnBool(number: rowCountIndex) && !isEvenParamNumberReturnBool(number: colCountIndex) || isEvenParamNumberReturnBool(number: rowCountIndex) && !isEvenParamNumberReturnBool(number: colCountIndex)

        nodeSKSpriteNodeSKSpriteNode.run(SKAction.sequence([
          SKAction.wait(forDuration: 0.3 * (delayIsOrNot ? 0 : 1)),
          scaleAnimScaleAnimationScaleAnimation
        ]))
      }
    }
  }

  func performScaleInLinearTopFromColorTopTopToColor(fromColor : SKColor, toColor : SKColor) {
    let scaleAnimScaletionScaleAnimation = getScaleAnimationFromColorToColorToScaleReturnSKAction(fromColor: fromColor, toColor: toColor, toScale: 1)

    for columnIndexCount in spritesSKSpriteNode {
      for iIndex in 0 ..< columnIndexCount.count {
        let spriteSKSpriteNode = columnIndexCount[iIndex]
        spriteSKSpriteNode.alpha = 1.0
        spriteSKSpriteNode.scale(to: CGSize())
        spriteSKSpriteNode.color = fromColor

        spriteSKSpriteNode.run(SKAction.sequence([
          SKAction.wait(forDuration: 0.05 * TimeInterval(iIndex)),
          scaleAnimScaletionScaleAnimation
          ]))
      }
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 2.01) {
      (self.parent as! Router).transitionCoveredScreen()

      self.performScaleOutLinearTopFromColorOutLinearTopToColor(from: toColor, to: toColor)
    }
  }

  private func performScaleOutLinearTopFromColorOutLinearTopToColor(from: SKColor, to: SKColor) {
    let scaleAnimScaleGetScaleAnimationScale = getScaleAnimationFromColorToColorToScaleReturnSKAction(fromColor: from, toColor: to, toScale: 0.0)

    for columnCountIndexCount in spritesSKSpriteNode {
      for iContIndexCount in 0 ..< columnCountIndexCount.count {
        let spriteSKSpriteSKSpriteNode = columnCountIndexCount[iContIndexCount]
        spriteSKSpriteSKSpriteNode.run(SKAction.sequence([
          SKAction.wait(forDuration: 0.05 * TimeInterval(iContIndexCount)),
          scaleAnimScaleGetScaleAnimationScale
        ]))
      }
    }
  }

  //Beware! Brittle code awaits yee who dares to enter
  func performScaleSpiralToScaleAtPointFromColor(toScale: CGFloat, atPoint: CGPoint, fromColor : SKColor, toColor : SKColor) {
    let childrenCount = children.count
    var affectedCountCount = 0

    var childAtPointSKSpriteNode : SKSpriteNode?
    for child in children {
      if child.contains(atPoint) {
        childAtPointSKSpriteNode = (child as! SKSpriteNode)
        break
      }
    }

    if childAtPointSKSpriteNode == nil {
      childAtPointSKSpriteNode = (children[Int(arc4random()) % children.count] as! SKSpriteNode)
    }

    let coordinatesStringArr = childAtPointSKSpriteNode?.name?.characters.split{$0 == "."}.map(String.init)

    var colIndex = Int(coordinatesStringArr![0])!
    var rowIndex = Int(coordinatesStringArr![1])!
    var lastDirectionDirection = Direction.None
    let animationSecretKeySecretKey = "scaleKey\(toScale)\(fromColor)\(toColor)"

    var sideCountLengthLength = 0
    var currentSideMovement = 0

    let animScaleAnimation = getScaleAnimationFromColorToColorToScaleReturnSKAction(fromColor: fromColor, toColor: toColor, toScale: toScale)

    var delayTimeInterval: TimeInterval = 0
    while affectedCountCount < childrenCount {
      let nodeName = getSpriteNameParamISRowAndColReturnString(row: rowIndex, col: colIndex)

      if let keyIndex = spriteNameDictDictionary[nodeName] {
        let nodeSKSpriteNode = children[keyIndex] as! SKSpriteNode

        if nodeSKSpriteNode.action(forKey: animationSecretKeySecretKey) == nil {
          nodeSKSpriteNode.setScale(1 - toScale)
          nodeSKSpriteNode.color = fromColor
          nodeSKSpriteNode.alpha = 1

          delayTimeInterval = 0.001 * TimeInterval(affectedCountCount)

          nodeSKSpriteNode.run(SKAction.sequence([
            SKAction.wait(forDuration: delayTimeInterval),
            animScaleAnimation
            ]), withKey: animationSecretKeySecretKey)
          
          affectedCountCount += 1
        }
      }

      switch lastDirectionDirection {
      case Direction.None:
        lastDirectionDirection = Direction.South
      case Direction.South:
        sideCountLengthLength += 2
        currentSideMovement = 0

        lastDirectionDirection = Direction.NorthWest
        rowIndex += 1
      case Direction.NorthWest:
        if currentSideMovement < sideCountLengthLength {
          lastDirectionDirection = Direction.NorthWest

          if isEvenParamNumberReturnBool(number: colIndex) {
            rowIndex -= 1
          }

          colIndex -= 1

          currentSideMovement += 1
        } else {
          lastDirectionDirection = Direction.NorthEast
          currentSideMovement = 0
        }
      case Direction.NorthEast:

        if currentSideMovement < sideCountLengthLength {
          lastDirectionDirection = Direction.NorthEast

          if isEvenParamNumberReturnBool(number: colIndex) {
            rowIndex -= 1
          }

          colIndex += 1

          currentSideMovement += 1
        } else {
          lastDirectionDirection = Direction.SouthEast
          currentSideMovement = 0
        }

      case  Direction.SouthEast:
        if currentSideMovement < sideCountLengthLength {
          lastDirectionDirection = Direction.SouthEast

          if !isEvenParamNumberReturnBool(number: colIndex) {
            rowIndex += 1
          }
          
            colIndex += 1

          currentSideMovement += 1
        } else {
          lastDirectionDirection = Direction.SouthWest
          currentSideMovement = 0
        }
      case Direction.SouthWest:
        if currentSideMovement < sideCountLengthLength {
          lastDirectionDirection = Direction.SouthWest

          if !isEvenParamNumberReturnBool(number: colIndex) {
            rowIndex += 1
          }

          colIndex -= 1

          currentSideMovement += 1
        } else {
          lastDirectionDirection = Direction.South
          currentSideMovement = 0
        }
      case Direction.West: break
      case Direction.North: break
      case Direction.East: break
        
      }
    }

    if toScale > 0 {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.51) {
        (self.parent as! Router).transitionCoveredScreen()

        self.performScaleSpiralToScaleAtPointFromColor(toScale: 0.0, atPoint: atPoint, fromColor: toColor, toColor: toColor)
      }
    }
  }

  func getScaleAnimationFromColorToColorToScaleReturnSKAction(fromColor : SKColor, toColor : SKColor, toScale: CGFloat) -> SKAction {
    let scaleAnimSKAction = SKAction.scale(to: toScale, duration: 0.5)
    scaleAnimSKAction.timingMode = .easeIn

    return SKAction.group([
      scaleAnimSKAction,
      SKAction.sequence([
        SKAction.wait(forDuration: 0.1),
        ColorAction().colorTransitionAction(fromColor: fromColor, toColor: toColor)
        ])
      ])
  }

  func isEvenParamNumberReturnBool(number : Int) -> Bool {
    return number % 2 == 0
  }
  
  func getSpriteNameParamISRowAndColReturnString(row: Int, col: Int) -> String {
    return "\(col).\(row)"
  }
}

enum TransitionType {
  case ScaleInUniform
  case ScaleInLinearTop
  case ScaleInCircular(fromPoint : CGPoint)
  case ScaleInEvenOddColumn
  case ScaleInChecker
}

class TransitionExtras {
  var transitionType : TransitionType
  var fromColor : SKColor
  var toColor : SKColor

  init(transitionType : TransitionType, fromColor : SKColor = RAIN_COLOR, toColor : SKColor = RAIN_COLOR) {
    self.transitionType = transitionType
    self.fromColor = fromColor
    self.toColor = toColor
  }
}

enum Direction {
  case North, NorthEast, East, SouthEast, South, SouthWest, West, NorthWest, None
}
