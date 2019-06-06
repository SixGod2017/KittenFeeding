//
//  LCDFoodRow.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 11/7/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDFoodRow : SKNode, Resetable, LCDSetupable {

  private var foodPosition1SKSpriteNode : SKSpriteNode!
  private var foodPosition2SpriteNode : SKSpriteNode!
  private var foodPosition3SprieNode : SKSpriteNode!
  private var foodPosition4Node : SKSpriteNode!
  private var foodPosfoodPosition5Node : SKSpriteNode!
  private var foodPosition6SKNode : SKSpriteNode!

  private(set) var foodLocation = -1

  private var shouldUpdateIsOrNot = true

  func setup() {
    foodPosition1SKSpriteNode = childNode(withName: "food-pos-one") as! SKSpriteNode!
    foodPosition2SpriteNode = childNode(withName: "food-pos-two") as! SKSpriteNode!
    foodPosition3SprieNode = childNode(withName: "food-pos-three") as! SKSpriteNode!
    foodPosition4Node = childNode(withName: "food-pos-four") as! SKSpriteNode!
    foodPosfoodPosition5Node = childNode(withName: "food-pos-five") as! SKSpriteNode!
    foodPosition6SKNode = childNode(withName: "food-pos-six") as! SKSpriteNode!

    turnOffLocationAtIndex(index: 0)
    turnOffLocationAtIndex(index: 1)
    turnOffLocationAtIndex(index: 2)
    turnOffLocationAtIndex(index: 3)
    turnOffLocationAtIndex(index: 4)
    turnOffLocationAtIndex(index: 5)

    showNextPosition()
  }

  func showNextPosition() {
    if shouldUpdateIsOrNot {
      turnOffLocationAtIndex(index: foodLocation)
      var location = Int(arc4random() % LCD_MAX_LOCATION)

      //If location clashes with last location move the food to an adjacent location
      if foodLocation == location {
        location += (arc4random() % 2 == 0) ? 1 : -1

        if location < 0 {
          location = Int(LCD_MAX_LOCATION) - 1
        } else if location > Int(LCD_MAX_LOCATION) - 1 {
          location = 0
        }
      }

      print("next food location \(location)")

      turnOnLocationAtIndex(index: location)
    }
  }

  func resetPressed() {
    shouldUpdateIsOrNot = false

    turnOnLocationAtIndex(index: 0)
    turnOnLocationAtIndex(index: 1)
    turnOnLocationAtIndex(index: 2)
    turnOnLocationAtIndex(index: 3)
    turnOnLocationAtIndex(index: 4)
    turnOnLocationAtIndex(index: 5)
  }

  func resetReleased() {
    turnOffLocationAtIndex(index: 0)
    turnOffLocationAtIndex(index: 1)
    turnOffLocationAtIndex(index: 2)
    turnOffLocationAtIndex(index: 3)
    turnOffLocationAtIndex(index: 4)
    turnOffLocationAtIndex(index: 5)

    shouldUpdateIsOrNot = true
    showNextPosition()
  }

  func turnOffLocationAtIndex(index : Int) {
    switch index {
    case 0:
      foodPosition1SKSpriteNode.alpha = lcdOffAlpha
    case 1:
      foodPosition2SpriteNode.alpha = lcdOffAlpha
    case 2:
      foodPosition3SprieNode.alpha = lcdOffAlpha
    case 3:
      foodPosition4Node.alpha = lcdOffAlpha
    case 4:
      foodPosfoodPosition5Node.alpha = lcdOffAlpha
    default:
      foodPosition6SKNode.alpha = lcdOffAlpha
    }
  }

  func turnOnLocationAtIndex(index : Int) {
    switch index {
    case 0:
      foodPosition1SKSpriteNode.alpha = lcdOnAlpha
    case 1:
      foodPosition2SpriteNode.alpha = lcdOnAlpha
    case 2:
      foodPosition3SprieNode.alpha = lcdOnAlpha
    case 3:
      foodPosition4Node.alpha = lcdOnAlpha
    case 4:
      foodPosfoodPosition5Node.alpha = lcdOnAlpha
    default:
      foodPosition6SKNode.alpha = lcdOnAlpha
      foodLocation = 5 // In case we are at a negative location
    }
    
    foodLocation = index
  }
}
