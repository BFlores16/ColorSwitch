//
//  Settings.swift
//  ColorSwitch
//
//  Created by Brando Flores on 12/15/20.
//

import SpriteKit

// The PhysicsBodies attributes for the ball
enum PhysicsCategories {
    static let none: UInt32 = 0
    
    // Use bitwise shifts to match the correct colors for the game
    static let ballCategory: UInt32 = 0x1           // 01
    static let switchCategory: UInt32 = 0x1 << 1    // 10
}
