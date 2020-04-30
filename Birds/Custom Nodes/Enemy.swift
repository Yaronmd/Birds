//
//  Enemy.swift
//  Birds
//
//  Created by yaron mordechai on 19/04/2020.
//  Copyright © 2020 yaron mordechai. All rights reserved.
//

import SpriteKit

enum EnemyType:String {
    case orange
}

class Enemy: SKSpriteNode {

    let type : EnemyType
    var health: Int = 0
    let animationFremes : [SKTexture]
    
    init(enemyType:EnemyType){
        self.type = enemyType
        animationFremes = AnamationHelper.loadTexture(from: SKTextureAtlas(named: type.rawValue), withName: type.rawValue)
        
        
        switch type {
        case .orange:
            health = 100
       
        }
        let texture = SKTexture(imageNamed: type.rawValue + "1")
       
        super.init(texture: texture, color: .clear, size: .zero)
        animateEnemy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createPhysicsBody(){
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = PhysicsCategory.enemy
        physicsBody?.collisionBitMask = PhysicsCategory.all
        physicsBody?.contactTestBitMask = PhysicsCategory.all
    }
    
    func animateEnemy(){
        run(SKAction.repeatForever(SKAction.animate(with: animationFremes, timePerFrame: 0.3, resize: false, restore: true)))
    
    }
    
    func impact(with force:Int)->Bool{
        
        self.health -= force
        
        if health < 1{
            self.removeFromParent()
            return true
        }
        return false
        
    }
    
}
