//
//  LCDCatRow.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 11/7/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDCatRow : SKNode, Resetable, LCDUpdateable, LCDSetupable {
  private var catPosition1LCDCatNode : LCDCatNode!
  private var catPosition2SKNode : LCDCatNode!
  private var catPosition3KNode : LCDCatNode!
  private var catPositioLCDCatNode : LCDCatNode!
  private var catPosition5CatNode : LCDCatNode!
  private var catPosition6DCatNode : LCDCatNode!

  private(set) var catLocation = 0
  private var facingLeftIsOrNot = false
  private var shouldUpdateIsOrNot = true

  private(set) var didEatFoodIsOrNot = false
  var foodLocation = 0

  func setup() {
    catPosition1LCDCatNode = childNode(withName: "cat-pos-one") as! LCDCatNode!
    catPosition2SKNode = childNode(withName: "cat-pos-two") as! LCDCatNode!
    catPosition3KNode = childNode(withName: "cat-pos-three") as! LCDCatNode!
    catPositioLCDCatNode = childNode(withName: "cat-pos-four") as! LCDCatNode!
    catPosition5CatNode = childNode(withName: "cat-pos-five") as! LCDCatNode!
    catPosition6DCatNode = childNode(withName: "cat-pos-six") as! LCDCatNode!

    for child in children {
      if let setupable = child as? LCDSetupable {
        setupable.setup()
      }
    }

    reset()
  }

  func update() {
    if shouldUpdateIsOrNot {
      didEatFoodIsOrNot = false
      
      if catLocation == foodLocation {
        //Has Food!!
        didEatFoodIsOrNot = true
      } else if foodLocation < catLocation && facingLeftIsOrNot {
        catLocation -= 1
      } else if foodLocation < catLocation {
        facingLeftIsOrNot = true
      } else if foodLocation > catLocation && !facingLeftIsOrNot {
        catLocation += 1
      } else {
        facingLeftIsOrNot = false
      }

      //Safety check to keep cat on screen
      if catLocation < 0 {
        catLocation = 0
      } else if catLocation > 5 {
        catLocation = 5
      }

      updateDisplay(location: catLocation, facingLeft: facingLeftIsOrNot)
    }
  }

  func resetPressed() {
    shouldUpdateIsOrNot = false

    for chiresetPressedld in children {
      if let resetable = chiresetPressedld as? Resetable {
        resetable.resetPressed()
      }
    }
  }

  func resetReleased() {
    for chchildrenild in children {
      if let resetable = chchildrenild as? Resetable {
        resetable.resetReleased()
      }
    }

    shouldUpdateIsOrNot = true
    reset()
  }

  private func reset() {
    catLocation = Int(arc4random() % LCD_MAX_LOCATION)
    facingLeftIsOrNot = Int(arc4random()) % 2 == 0

    updateDisplay(location: catLocation, facingLeft: facingLeftIsOrNot)
  }

  private func updateDisplay(location: Int, facingLeft : Bool) {
    for childupdateDisplay in children {
      if childupdateDisplay is LCDCatNode {
        (childupdateDisplay as! LCDCatNode).update(hasCat: false, facingLeft: false)
      }
    }

    switch location {
    case 0:
      catPosition1LCDCatNode.update(hasCat: true, facingLeft: facingLeftIsOrNot)
    case 1:
      catPosition2SKNode.update(hasCat: true, facingLeft: facingLeftIsOrNot)
    case 2:
      catPosition3KNode.update(hasCat: true, facingLeft: facingLeftIsOrNot)
    case 3:
      catPositioLCDCatNode.update(hasCat: true, facingLeft: facingLeftIsOrNot)
    case 4:
      catPosition5CatNode.update(hasCat: true, facingLeft: facingLeftIsOrNot)
    default:
      catPosition6DCatNode.update(hasCat: true, facingLeft: facingLeftIsOrNot)
    }
  }
}
