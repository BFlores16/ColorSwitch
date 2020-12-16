//
//  MenuScene.swift
//  ColorSwitch
//
//  Created by Brando Flores on 12/15/20.
//

import SpriteKit

class MenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 44/255, green: 66/255, blue: 80/255, alpha: 1.0)
        addLogo()
        addLabels()
    }
    
    /*
    Add game logo to screen
     */
    func addLogo() {
        let logo = SKSpriteNode(imageNamed: "logo")
        logo.size = CGSize(width: frame.size.width / 4.0, height:  frame.size.width / 4.0)
        logo.position = CGPoint(x: frame.midX, y: frame.size.height - 100)
        addChild(logo)
    }
    
    /*
     Add play, high score, and recent score to screen
     */
    func addLabels() {
        let playLabel = SKLabelNode(text: "Tap to play!")
        playLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        playLabel.fontName = "AvenirNext-Bold"
        playLabel.fontColor = UIColor.white
        playLabel.fontSize = 50
        addChild(playLabel)
        
        let highScoreLabel = SKLabelNode(text: "Highscore: " + "\(UserDefaults.standard.integer(forKey: "Highscore"))")
        highScoreLabel.position = CGPoint(x: frame.midX, y: playLabel.position.y - 100)
        highScoreLabel.fontName = "AvenirNext-Bold"
        highScoreLabel.fontColor = UIColor.white
        highScoreLabel.fontSize = 40
        addChild(highScoreLabel)
        
        let recentScoreLabel = SKLabelNode(text: "Recent Score: " + "\(UserDefaults.standard.integer(forKey: "RecentScore"))")
        recentScoreLabel.position = CGPoint(x: frame.midX, y: highScoreLabel.position.y - 50)
        recentScoreLabel.fontName = "AvenirNext-Bold"
        recentScoreLabel.fontColor = UIColor.white
        recentScoreLabel.fontSize = 40
        addChild(recentScoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameScene = GameScene(size: view!.bounds.size)
        view?.presentScene(gameScene)
    }
    
}
