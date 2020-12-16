//
//  GameScene.swift
//  ColorSwitch
//
//  Created by Brando Flores on 12/15/20.
//

import SpriteKit

class GameScene: SKScene {
    
    var colorCircle: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        layoutScene()
        setupPhysics()
    }
    
    /*
     Set the physics of the ball, slowing it down
     */
    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        physicsWorld.contactDelegate = self
    }
    
    /*
     Set the background color as well as the position of the color circle.
     Initial view for the player which creates the color circle and spawns
     the ball.
     */
    func layoutScene() {
        backgroundColor = UIColor(red: 44/255, green: 66/255, blue: 80/255, alpha: 1.0)
        
        // Add position and size properties for color circle
        colorCircle = SKSpriteNode(imageNamed: "ColorCircle")
        colorCircle.size = CGSize(width: frame.size.width / 3.0, height: frame.size.width / 3.0)
        colorCircle.position = CGPoint(x: frame.midX, y: frame.minY + colorCircle.size.height)
        
        // Add physics body properties for color circle
        colorCircle.physicsBody = SKPhysicsBody(circleOfRadius: colorCircle.size.width / 2.0)
        colorCircle.physicsBody?.categoryBitMask =  PhysicsCategories.switchCategory
        colorCircle.physicsBody?.isDynamic = false
        
        addChild(colorCircle)
        
        spawnBall()
    }
    
    /*
     Ball will start at the top center always. Ball will be respawned multiple
     times in the game
     */
    func spawnBall() {
        let ball = SKSpriteNode(imageNamed: "ball")
        
        // Add position and size properties for ball
        ball.size = CGSize(width: 30.0, height: 30.0)
        ball.position = CGPoint(x: frame.midX, y: frame.maxY)
        
        // Add physics body properties for ball
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        // Send contact bit to SKPhysicsContactDelegate
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory
        ball.physicsBody?.collisionBitMask = PhysicsCategories.none
        
        addChild(ball)
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    // 01
    // 10
    // 11
    // Called once ball contacts color circle
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.ballCategory | PhysicsCategories.switchCategory {
            print("contact")
        }
    }
    
}
