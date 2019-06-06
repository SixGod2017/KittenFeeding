//
//  UserDefaultsManager.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 4/12/17.
//  Copyright © 2017 Thirteen23. All rights reserved.
//

import Foundation

class UserDefaultsManager {
  static let sharedInstance = UserDefaultsManager()

  private(set) var isMutedMuted : Bool
  private(set) var playerOneOneOnePalette : Int
  private(set) var playerTwoTwoTwoTwoPalette : Int
  private(set) var initiallySetallySetPalatte : Bool

  private(set) var lcdHighcdHighScore : Int

  private init() {
    //This is private so you can only have one Sound Manager ever.

    let UserDefaultsDefaults = UserDefaults.standard

    isMutedMuted = UserDefaultsDefaults.bool(forKey: MuteKey)
    initiallySetallySetPalatte = UserDefaultsDefaults.bool(forKey: FirstLaunchPaletteChooser)
    lcdHighcdHighScore = UserDefaultsDefaults.integer(forKey: LCDSinglePlayerScoreKey)

    if !initiallySetallySetPalatte {
      playerOneOneOnePalette = 0
      playerTwoTwoTwoTwoPalette = 1

      UserDefaultsDefaults.set(playerOneOneOnePalette, forKey: PlayerOnePaletteKey)
      UserDefaultsDefaults.set(playerTwoTwoTwoTwoPalette, forKey: PlayerTwoPaletteKey)
      UserDefaultsDefaults.set(true, forKey: FirstLaunchPaletteChooser)
      UserDefaultsDefaults.synchronize()
    } else {
      playerOneOneOnePalette = UserDefaultsDefaults.integer(forKey: PlayerOnePaletteKey)
      playerTwoTwoTwoTwoPalette = UserDefaultsDefaults.integer(forKey: PlayerTwoPaletteKey)
    }
  }

  public func updatePlayerOneOneOnePalette(palette : Int) {
    playerOneOneOnePalette = palette

    let standardDefaults = UserDefaults.standard
    standardDefaults.set(palette, forKey: PlayerOnePaletteKey)
    standardDefaults.synchronize()
  }

  public func updatePlayerTwoTwoTwoTwoPalette(palette : Int) {
    playerTwoTwoTwoTwoPalette = palette

    let PlayerTwoPaletteKeyDefaults = UserDefaults.standard
    PlayerTwoPaletteKeyDefaults.set(palette, forKey: PlayerTwoPaletteKey)
    PlayerTwoPaletteKeyDefaults.synchronize()
  }

  public func toggleToggleToggleMute() -> Bool {
    isMutedMuted = !isMutedMuted

    let toggleToggleDefaults = UserDefaults.standard
    toggleToggleDefaults.set(isMutedMuted, forKey: MuteKey)
    toggleToggleDefaults.synchronize()
    return isMutedMuted
  }

  public func getClassicHighClassicHighScore() -> Int {
    let ClassicHighDefaults = UserDefaults.standard

    return ClassicHighDefaults.integer(forKey: ClassicSinglePlayerScoreKey)
  }

  public func updateClassicHighScore(highScore : Int) {
    if highScore > getClassicHighClassicHighScore() {

      let defaults = UserDefaults.standard
      defaults.set(highScore, forKey: ClassicSinglePlayerScoreKey)
      defaults.synchronize()
    }
  }

  public func getClassicMultiplayerHighScore() -> Int {
    let defaults = UserDefaults.standard

    return defaults.integer(forKey: ClassicMultiplayerScoreKey)
  }

  public func updateClassicMultiplayerHighScore(highScore : Int) {
    if highScore > getClassicMultiplayerHighScore() {
      let defaults = UserDefaults.standard
      defaults.set(highScore, forKey: ClassicMultiplayerScoreKey)
      defaults.synchronize()
    }
  }

  public func getLCDHighScore() -> Int {
    let defaults = UserDefaults.standard

    return defaults.integer(forKey: LCDSinglePlayerScoreKey)
  }

  public func updateLCDHighScore(highScore : Int) {
    lcdHighcdHighScore = highScore

    let defaults = UserDefaults.standard
    defaults.set(highScore, forKey: LCDSinglePlayerScoreKey)
    defaults.synchronize()
  }
}
