//
//  LCDUmbrellaRow.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 11/7/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDUmbrellaRow : SKNode, Resetable, LCDSetupable {
  private var umbrella1SKSpriteNode : SKSpriteNode!
  private var umbrella2SKSpriteNode : SKSpriteNode!
  private var umbrella3SKSpriteNode : SKSpriteNode!
  private var umbrella4SKSpriteNode : SKSpriteNode!
  private var umbrella5SKSpriteNode : SKSpriteNode!
  private var umbrella6SKSpriteNode : SKSpriteNode!

  private var shouldUpdateIsOrNot = true

  private let defaultUmbrellaLocation = 2
  private(set) var umbrellaLocation = 0

  func setup() {
    umbrella1SKSpriteNode = childNode(withName: "umbrella-pos-one") as! SKSpriteNode!
    umbrella2SKSpriteNode = childNode(withName: "umbrella-pos-two") as! SKSpriteNode!
    umbrella3SKSpriteNode = childNode(withName: "umbrella-pos-three") as! SKSpriteNode!
    umbrella4SKSpriteNode = childNode(withName: "umbrella-pos-four") as! SKSpriteNode!
    umbrella5SKSpriteNode = childNode(withName: "umbrella-pos-five") as! SKSpriteNode!
    umbrella6SKSpriteNode = childNode(withName: "umbrella-pos-six") as! SKSpriteNode!

    umbrella1SKSpriteNode.alpha = lcdOffAlpha
    umbrella2SKSpriteNode.alpha = lcdOffAlpha
    umbrella4SKSpriteNode.alpha = lcdOffAlpha
    umbrella5SKSpriteNode.alpha = lcdOffAlpha
    umbrella6SKSpriteNode.alpha = lcdOffAlpha

    umbrellaLocation = defaultUmbrellaLocation
  }

  func moveLeft() {
    if umbrellaLocation > 0 {
      umbrellaLocation -= 1
    }

    updateLeds()
  }

  func moveRight() {
    if umbrellaLocation < Int(LCD_MAX_LOCATION) - 1 {
      umbrellaLocation += 1
    }

    updateLeds()
  }

  func updateLeds() {
    if(shouldUpdateIsOrNot) {
      umbrella1SKSpriteNode.alpha = umbrellaLocation == 0 ? lcdOnAlpha : lcdOffAlpha
      umbrella2SKSpriteNode.alpha = umbrellaLocation == 1 ? lcdOnAlpha : lcdOffAlpha
      umbrella3SKSpriteNode.alpha = umbrellaLocation == 2 ? lcdOnAlpha : lcdOffAlpha
      umbrella4SKSpriteNode.alpha = umbrellaLocation == 3 ? lcdOnAlpha : lcdOffAlpha
      umbrella5SKSpriteNode.alpha = umbrellaLocation == 4 ? lcdOnAlpha : lcdOffAlpha
      umbrella6SKSpriteNode.alpha = umbrellaLocation == 5 ? lcdOnAlpha : lcdOffAlpha
    }
  }

  func resetPressed() {
    shouldUpdateIsOrNot = false

    for child in children {
      if let resetable = child as? SKSpriteNode {
        resetable.alpha = lcdOnAlpha
      }
    }
  }

  func resetReleased() {
    shouldUpdateIsOrNot = true

    for child in children {
      if let resetable = child as? SKSpriteNode {
        resetable.alpha = lcdOffAlpha
      }
    }

    umbrellaLocation = defaultUmbrellaLocation
    updateLeds()
  }
}
