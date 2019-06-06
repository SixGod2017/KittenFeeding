//
//  LCDTimeNode.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 3/29/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDTimeNode : SKNode, Resetable, LCDSetupable {
  private var hoursTensSpotLCDNumberNode : LCDNumberNode!
  private var hoursOnesSpotLCDNumberNode : LCDNumberNode!
  private var minutesTensSpotLCDNumberNode : LCDNumberNode!
  private var minutesOnesSpotLCDNumberNode : LCDNumberNode!
  private let calendar = Calendar.current

  private let dateFormatter = DateFormatter()
  private var shouldUpdate = true


  func setup() {
    hoursTensSpotLCDNumberNode = childNode(withName: "hour-tens") as! LCDNumberNode!
    hoursOnesSpotLCDNumberNode = childNode(withName: "hour-ones") as! LCDNumberNode!
    minutesTensSpotLCDNumberNode = childNode(withName: "minute-tens") as! LCDNumberNode!
    minutesOnesSpotLCDNumberNode = childNode(withName: "minute-ones") as! LCDNumberNode!

    for child in children {
      if let setupable = child as? LCDSetupable {
        setupable.setup()
      }
    }
  }

  func update() {
    if(shouldUpdate) {
    let comp = calendar.dateComponents([.hour, .minute], from: Date())
    let hour = comp.hour
    let minute = comp.minute

    updateDisplay(hours: hour!, minutes: minute!)
    }
  }

  private func updateDisplay(hours : Int, minutes : Int) {
    let hoursOnes = hours % 10
    let hoursTens = (hours - hoursOnes) % 100

    let minutesOnes = minutes % 10
    let minutesTens = (minutes - minutesOnes) % 100

    hoursTensSpotLCDNumberNode.updateDisplay(number: hoursTens / 10)
    hoursOnesSpotLCDNumberNode.updateDisplay(number: hoursOnes)

    minutesTensSpotLCDNumberNode.updateDisplay(number: minutesTens / 10)
    minutesOnesSpotLCDNumberNode.updateDisplay(number: minutesOnes)
  }

  func resetPressed() {
    shouldUpdate = false

    updateDisplay(hours: 88, minutes: 88)
  }

  func resetReleased() {
    shouldUpdate = true
  }
}
