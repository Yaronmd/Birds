//
//  GameViewController.swift
//  Birds
//
//  Created by yaron mordechai on 30/03/2020.
//  Copyright © 2020 yaron mordechai. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

protocol SceneManagerDelegate {
    func presentMenuSence()
    func presentLevelSence()
    func presentGameSenceFor(level:Int)
}

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentMenuSence()
        
        }
    }


extension GameViewController:SceneManagerDelegate{
    
    func presentMenuSence() {
        let menuScene = MenuScene()
        menuScene.sceneManageDelegate = self
        present(scene: menuScene)
        
    }
    
    func presentLevelSence() {
        let levelScene = LevelScene()
        levelScene.sceneManageDelegate = self
        present(scene: levelScene)
    }
    
    func presentGameSenceFor(level: Int) {
        let sceneName = "GameScene_\(level)"
       
        if let gameScene = SKScene(fileNamed: sceneName) as? GameScene{
            gameScene.sceneManageDelegate = self
            gameScene.level = level
            present(scene: gameScene)
        }
    }
    
    func present(scene:SKScene){
        if let view = self.view as! SKView?{
            if let gestureRecegnizer = view.gestureRecognizers{
                
                for recognizer in gestureRecegnizer{
                    view.removeGestureRecognizer(recognizer)
                }
            }
            scene.scaleMode = .resizeFill
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
        }
    }
    
}
