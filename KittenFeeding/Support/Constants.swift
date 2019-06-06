//
//  Constants.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 8/30/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

let RainDropCategory   : UInt32 = 0x1 << 1
let FloorCategory      : UInt32 = 0x1 << 2
let UmbrellaCategory   : UInt32 = 0x1 << 3
let WorldFrameCategory : UInt32 = 0x1 << 4
let CatCategory        : UInt32 = 0x1 << 5
let FoodCategory       : UInt32 = 0x1 << 6

let colorChangeDuration : TimeInterval = 0.25

let LCD_MAX_LOCATION : UInt32 = 6

let lcdOffAlpha : CGFloat = 0.05
let lcdOnAlpha  : CGFloat = 1

let ClassicSinglePlayerScoreKey = "KITTENFEEDING_HIGHSCORE"
let ClassicMultiplayerScoreKey = "KITTENFEEDING_MULTIPLAYER_HIGHSCORE"
let LCDSinglePlayerScoreKey = "KITTENFEEDING_LCD_HIGHSCORE"

let MuteKey = "KITTENFEEDING_MUTED"
let FirstLaunchPaletteChooser = "FIRST_LAUNCH_PALETTE_CHOOSER"
let PlayerOnePaletteKey = "PLAYER_ONEPLAYER_ONE_PALETTE"
let PlayerTwoPaletteKey = "PLAYER_TWO__TWO__TWO_PALETTE"

let BASE_FONT_NAME = "PixelDigivolve"

public func Distance(p1: CGPoint, p2: CGPoint, absoluteValue: Bool = true) -> CGFloat {
  let distance = sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2))

  return (absoluteValue ? abs(distance) : distance)
}


public func getUIDeviceDisplayuserInterfaceIdiomSize() -> CGSize {
  if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
//    return CGSize(width: width * 2, height: height * 2)
//    return CGSize(width: 1334, height: 750)
    return CGSize(width: 1024, height: 768)
  } else {
    return CGSize(width: 1024, height: 768)
  }
}
