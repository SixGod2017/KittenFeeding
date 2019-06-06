//
//  FoodSprite.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 8/31/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class FoodSprite : SKSpriteNode, Palettable {
  public static let foodDishNameStrValue = "FoodDish"

  public static func newInstance(palette : ColorPalette) -> FoodSprite {
    let foodDishFoodSprite = FoodSprite(imageNamed: "food_dish")
    foodDishFoodSprite.name = foodDishNameStrValue
    foodDishFoodSprite.color = palette.foodBowlColor
    foodDishFoodSprite.colorBlendFactor = 1

    foodDishFoodSprite.anchorPoint = CGPoint(x: 0, y: 1)

    foodDishFoodSprite.physicsBody = SKPhysicsBody(rectangleOf: foodDishFoodSprite.size,
                                         center: CGPoint(x: foodDishFoodSprite.size.width / 2, y: -foodDishFoodSprite.size.height / 2))
    foodDishFoodSprite.physicsBody?.categoryBitMask = FoodCategory
    foodDishFoodSprite.physicsBody?.contactTestBitMask = WorldFrameCategory | RainDropCategory | CatCategory
    foodDishFoodSprite.zPosition = 3

    //Generate Food Topping - Currently will always be brown
    let foodHeight = foodDishFoodSprite.size.height * 0.25
    let foodShape = SKShapeNode(rect: CGRect(x: 0, y: -foodHeight, width: foodDishFoodSprite.size.width, height: foodHeight))
    foodShape.fillColor = SKColor(red:0.36, green:0.21, blue:0.08, alpha:1.0)
    foodShape.strokeColor = SKColor.clear
    foodShape.zPosition = 4

    foodDishFoodSprite.addChild(foodShape)

    return foodDishFoodSprite
  }

  public func updatePalette(palette: ColorPalette) {
    run(ColorAction().colorTransitionAction(fromColor: color, toColor: palette.foodBowlColor, duration: colorChangeDuration))
  }
}
