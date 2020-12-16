//
//  GameScene.swift
//  ColorSwitch
//
//  Created by Brando Flores on 12/15/20.
//

import SpriteKit

// Colors for the ball to be
enum PlayColors {
    static let colors = [
        UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
        UIColor(red: 241/255, green: 296/255, blue: 15/255, alpha: 1.0),
        UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0),
        UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
    ]
}

// Values 0-3 to designate the state of the color circle
enum SwitchState: Int {
    case red, yellow, green, blue
}

class GameScene: SKScene {
    
    var colorCircle: SKSpriteNode!
    var switchState = SwitchState.red
    var currentColorIndex: Int?
    
    let scoreLabel = SKLabelNode(text: "0")
    var score: Int = 0
    
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
        colorCircle.zPosition = ZPositions.colorCircle
        
        // Add physics body properties for color circle
        colorCircle.physicsBody = SKPhysicsBody(circleOfRadius: colorCircle.size.width / 2.0)
        colorCircle.physicsBody?.categoryBitMask =  PhysicsCategories.switchCategory
        colorCircle.physicsBody?.isDynamic = false
        addChild(colorCircle)
        
        // Add score label and configure UI
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 60.0
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        scoreLabel.zPosition = ZPositions.label
        addChild(scoreLabel)
        
        spawnBall()
    }
    
    func updateScoreLabel() {
        score += 1
        scoreLabel.text = "\(score)"
    }
    
    /*
     Ball will start at the top center always. Ball will be respawned multiple
     times in the game
     */
    func spawnBall() {
        // Create the next state of the color circle for the next round
        currentColorIndex = Int(arc4random_uniform(UInt32(4)))
        
        // Set the ball to a new color for the ball when it spawns
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: PlayColors.colors[currentColorIndex!], size: CGSize(width: 30.0, height: 30.0))
        ball.colorBlendFactor = 1.0
        ball.name = "Ball"
        
        // Add position properties for ball
        ball.position = CGPoint(x: frame.midX, y: frame.maxY)
        
        // Add physics body properties for ball
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        // Send contact bit to SKPhysicsContactDelegate
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory
        ball.physicsBody?.collisionBitMask = PhysicsCategories.none
        ball.zPosition = ZPositions.ball
        
        addChild(ball)
    }
    
    /*
     Turn the color circle to a different color
     */
    func turnColorCircle() {
        // If randomly generated number is too high, set it by default to red
        if let newState = SwitchState(rawValue: switchState.rawValue + 1) {
            switchState = newState
        }
        else {
            switchState = .red
        }
        
        colorCircle.run(SKAction.rotate(byAngle: .pi / 2, duration: 0.25))
        
    }
    
    func gameOver() {
        print("Game Over")
    }
    
    /*
     Turn the color circle when the user touches the screen
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        turnColorCircle()
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    // 01
    // 10
    // 11
    // Called once ball contacts color circle
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        // Check if the ball matched to the right color, otherwise end the
        // game
        if contactMask == PhysicsCategories.ballCategory | PhysicsCategories.switchCategory {
            if let ball = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                if currentColorIndex == switchState.rawValue {
                    updateScoreLabel()
                    ball.run(SKAction.fadeOut(withDuration: 0.25)) {
                        ball.removeFromParent()
                        self.spawnBall()
                    }
                }
                else {
                    gameOver()
                }
            }
        }
    }
    
}
