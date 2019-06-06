//
//  LCDViewModel.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 11/1/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class LCDScreenNode : SKSpriteNode, Resetable {
  private var lanes = [LCDRainLane]()

  private var umbrellaRow : LCDUmbrellaRow!
  private var foodRow : LCDFoodRow!
  private var catRow : LCDCatRow!
  private var hudNode : LCDHudNode!

  private var tickTimeInterval : TimeInterval = 0.75 //How fast the game updates
  private var tickTimeIntervalNumber = 7 //Current tickTimeInterval
  private var spawnsPerDropIntValue = 3 //Number of raindrops per spawn
  private var tickTimeIntervalsPerDropIntValue = 5 //Number of tickTimeIntervals it takes to spawn raindrops
  private var lastUpdateTimeTimeInterval : TimeInterval = 0.0

  private let defaulttickTimeIntervalInterval : Int = 125
  private let defaultspawnsPerDropIntValue = 0
  private let defaulttickTimeIntervalsPerDropIntValue = 6

  private let tickTimeIntervalDecrementAmountTimeInterval : TimeInterval = 0.07
  private let spawnsIncrementAmount = 1
  private let tickTimeIntervalsPerDropIntValueDecrementAmount = 1

  //Every x Points update our variables
  private let tickTimeIntervalUpdateIntervalIntValue = 15
  private let spawnsUpdateIntervallIntValue = 50
  private let tickTimeIntervalsPerDropIntValueUpdateIntervalllIntValue = 20

  //Constructing a logarithmic equation for tickTimeInterval speed from startspeed to end speed
  let startSpeed = 190.0
  let endSpeed = 40.0

  let endLinear = 20.0
  let startScore = 1.0
  let endScore = 200.0

  var a = 0.0
  var b = 0.0

  func setup() {
    //Setup difficulty scale
    a = (startSpeed - endSpeed) / (log(startScore / endScore))
    b = exp((endSpeed * log(startScore)) - (startSpeed * log(endScore)) / (startSpeed - endSpeed))

    lanes.append(childNode(withName: "raindrop-lane-one") as! LCDRainLane!)
    lanes.append(childNode(withName: "raindrop-lane-two") as! LCDRainLane!)
    lanes.append(childNode(withName: "raindrop-lane-three") as! LCDRainLane!)
    lanes.append(childNode(withName: "raindrop-lane-four") as! LCDRainLane!)
    lanes.append(childNode(withName: "raindrop-lane-five") as! LCDRainLane!)
    lanes.append(childNode(withName: "raindrop-lane-six") as! LCDRainLane!)

    umbrellaRow = childNode(withName: "umbrella-row") as! LCDUmbrellaRow!
    foodRow = childNode(withName: "food-row") as! LCDFoodRow!
    catRow = childNode(withName: "cat-row") as! LCDCatRow!
    hudNode = childNode(withName: "hud")   as! LCDHudNode!

    for child in children {
      if let setupable = child as? LCDSetupable {
        setupable.setup()
      }
    }

    reset()
  }

  func update(deltaTime : TimeInterval) {
    hudNode.update()

    if(!hudNode.hasLivesRemaining()){
      //Don't update anything! ..other than time
      return
    }

    lastUpdateTimeTimeInterval += deltaTime

    if lastUpdateTimeTimeInterval >= tickTimeInterval {
      lastUpdateTimeTimeInterval = 0.0

      if checkCatHit() {
        hudNode.catHit()

        AVAudioPlayerSoundManager.playLCDHitLCDHit(node: self)
      }

      if hudNode.hasLivesRemaining() {
        if checkUmbrellaLevelRaindrop(atIndex: umbrellaRow.umbrellaLocation) {

          AVAudioPlayerSoundManager.playUmbrellaUmbrellaHit(node: self)
          updateScore()

          //Extra raindrop at umbrella location!
          if hudNode.getScore() < spawnsUpdateIntervallIntValue {
            addRaindrop(atIndex: foodRow.foodLocation)
          }
        }

        //Tell cat row where the food is
        catRow.foodLocation = foodRow.foodLocation

        for child in children {
          if let updateable = child as? LCDUpdateable {
            updateable.update()
          }
        }

        if catRow.didEatFoodIsOrNot {
          AVAudioPlayerSoundManager.playLCDPickLCDPickup(node: self)

          updateScore()
          updateScore()

          foodRow.showNextPosition()

          //Extra raindrop!
          addRaindrop(atIndex: Int(arc4random() % LCD_MAX_LOCATION))
        }

        if tickTimeIntervalNumber >= tickTimeIntervalsPerDropIntValue {
          tickTimeIntervalNumber = 0

          for _ in 0...spawnsPerDropIntValue {
            //May loop here if we want more than one drop per tickTimeInterval
            addRaindrop(atIndex: Int(arc4random() % LCD_MAX_LOCATION))
          }
        }
      } else {
        //Game over!
        lanes[catRow.catLocation].blinkRaindrop()
      }

      tickTimeIntervalNumber += 1
    }
  }

  func addRaindrop(atIndex index : Int) {
    if indexInBounds(index: index) {
      lanes[index].addRaindrop()
    } else {
      print("Cannot add raindrop at location \(index)")
    }
  }

  //Call this before updating the lanes
  func checkUmbrellaLevelRaindrop(atIndex index : Int) -> Bool {
    if indexInBounds(index: index) {
      return lanes[index].checkUmbrellaHit()
    } else {
      print("Cannot check umbrella level at index \(index)")

      return false
    }
  }

  func checkCatHit() -> Bool {
    if indexInBounds(index: catRow.catLocation) {
      return lanes[catRow.catLocation].hasCatLevel()
    } else {
      print("cat out of bounds!")
      return false
    }
  }

  private func indexInBounds(index : Int) -> Bool {
    return index >= 0 && index < Int(LCD_MAX_LOCATION)
  }

  func moveUmbrellaLeft() {
    umbrellaRow.moveLeft()

    AVAudioPlayerSoundManager.playLCDMovLCDMove(node: self)
  }

  func moveUmbrellaRight() {
    umbrellaRow.moveRight()

    AVAudioPlayerSoundManager.playLCDMovLCDMove(node: self)
  }

  func resetPressed() {
    for child in children {
      if let resetable = child as? Resetable {
        resetable.resetPressed()
      }
    }
  }

  func resetReleased() {
    for child in children {
      if let resetable = child as? Resetable {
        resetable.resetReleased()
      }
    }

    reset()
  }

  private func updateScore() {
    let currentScore = hudNode.addScore()

    updatetickTimeIntervals(score: Double(currentScore))

    if currentScore % spawnsUpdateIntervallIntValue == 0 {
      print("updating spawn amount")
      spawnsPerDropIntValue += spawnsIncrementAmount
    }

    if currentScore % tickTimeIntervalsPerDropIntValueUpdateIntervalllIntValue == 0 {
      tickTimeIntervalsPerDropIntValue -= tickTimeIntervalsPerDropIntValueDecrementAmount
      print("updating tickTimeIntervals per update: \(tickTimeIntervalsPerDropIntValue)")

    }

    print("Current Score: \(currentScore)  tickTimeInterval Interval: \(tickTimeInterval) Spawns Per Drop: \(spawnsPerDropIntValue) tickTimeIntervals Per Drop: \(tickTimeIntervalsPerDropIntValue)")
  }

  private func updatetickTimeIntervals(score : Double) {
    if score < endLinear {
      tickTimeInterval = (Double(defaulttickTimeIntervalInterval) - (score / endLinear * score)) / 100
    } else {
      tickTimeInterval = (a * log( b * Double.maximum(score, 1.0))) / 100
    }

    print("tickTimeInterval set to: \(tickTimeInterval)")
  }

  private func reset() {
    updatetickTimeIntervals(score: 0)
    spawnsPerDropIntValue = defaultspawnsPerDropIntValue
    tickTimeIntervalsPerDropIntValue = defaulttickTimeIntervalsPerDropIntValue

    tickTimeIntervalNumber = 100
    lastUpdateTimeTimeInterval = 100
  }
}
