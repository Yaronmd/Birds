//
//  GameScene.swift
//  Birds
//
//  Created by yaron mordechai on 30/03/2020.
//  Copyright © 2020 yaron mordechai. All rights reserved.
//

import SpriteKit
import GameplayKit

enum RoundState {
    case ready,flying,finished, animating ,gameover
}


class GameScene: SKScene {
    
    var sceneManageDelegate:SceneManagerDelegate?

    
    var mapNode = SKTileMapNode()
    let gameCamera = GameCamera()
    var panRecognizer = UIPanGestureRecognizer()
    var pinchRecognizer = UIPinchGestureRecognizer()
    
    var maxScale:CGFloat = 0
    
    var bird = Bird(type: .red)
    var birds = [Bird]()
    
    var enemies = 0 {
        didSet{
            if enemies < 1{
                roundState = .gameover
                presntPopup(victory: true)
            }
        }
    }
    
    var blocks = [Block(type: .stone),Block(type: .wood),Block(type: .glass)]
    
    let anchor = SKNode()
    
    var level:Int?
    
    var roundState = RoundState.ready
    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        guard let level = level else {
            return
        }
        guard let levelData = LevelData(level:level) else {
            return
        }


        for birdColor in levelData.birds{

            if let newBirdType = BirdType(rawValue:birdColor){
                birds.append(Bird(type: newBirdType))
            }

        }
        
        setupLevel()
        setupGestureRecognizers()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch roundState {
        case .ready:
            if let touch = touches.first{
                  
                  let location = touch.location(in: self)
                  
                  if bird.contains(location){
                      panRecognizer.isEnabled = false
                      bird.grabbed = true
                      bird.position = location
                  }
                  
              }
        case .flying:
            break;
        case .finished:
            print("finished")
            guard let view = view else {return}
            roundState = .animating
            let moveCameraBackAction = SKAction.move(to: CGPoint(x: view.bounds.size.width / 2 , y: view.bounds.size.height / 2 ), duration: 2.0)
            
            moveCameraBackAction.timingMode = .easeInEaseOut
            
            gameCamera.run(moveCameraBackAction,completion:{
                self.panRecognizer.isEnabled = true
                self.addBird()
                
            })
        case .animating:
            break
        
        case.gameover:
            break
            
       
    }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            
            if bird.grabbed{
                let location = touch.location(in: self)
                bird.position = location
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if bird.grabbed{
            gameCamera.setConstrains(with: self, and: mapNode.frame, to: bird)
            bird.grabbed = false
            
            bird.flying = true
            constraintToAnchor(active: false)
            roundState = .flying
            
            
            
            //distance for the bird from the anchor point
            let dx = anchor.position.x - bird.position.x
            let dy = anchor.position.y - bird.position.y
            
            // implementation throwing bird
            let impulse = CGVector(dx: dx, dy: dy)
            bird.physicsBody?.applyImpulse(impulse)
            bird.isUserInteractionEnabled = false
            
        }
    }
    
    func setupGestureRecognizers(){
        guard let view = view else {
            return
        }
        //Recognize when pan gesture and calling function pan
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan))
        view.addGestureRecognizer(panRecognizer)
        
        //Recognize when pinch gesture and calling function pinch
        pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        view.addGestureRecognizer(pinchRecognizer)
    }
    
    // setup the mapNode as TileMapNode
    func setupLevel(){
    
        if let mapNode = childNode(withName: "Tile Map Node") as? SKTileMapNode{
            self.mapNode = mapNode
            //self.mapNode.zPosition = ZPosition.background
            maxScale =  mapNode.mapSize.width / frame.size.width
            
            
        }
//        adding blocks(wood,glass,stone)
        
        for child in mapNode.children{
            if let child = child as? SKSpriteNode{
                
                guard let name = child.name else {continue}
                
                switch name {
                case "wood","stone","glass":
                    if  let block =  createBlock(from: child, name: name){
                        mapNode.addChild(block)
                        child.removeFromParent()
                    }
                   break
                case "orange":
                    if let enemy = createEnemy(from: child, name: name){
                        mapNode.addChild(enemy)
                        enemies += 1
                        child.removeFromParent()
                    }
                    break
                default:
                    break
                }
                
               

                //child.color = UIColor.clear

            }
        }
        print("addCamera")
        addCamera()
        
        let physicsRect = CGRect(x: 0, y: mapNode.tileSize.height, width: mapNode.frame.size.width, height: mapNode.frame.size.height - mapNode.tileSize.height)

        physicsBody = SKPhysicsBody(edgeLoopFrom: physicsRect)
        physicsBody?.categoryBitMask = PhysicsCategory.edge
        physicsBody?.contactTestBitMask = PhysicsCategory.bird | PhysicsCategory.block
        physicsBody?.collisionBitMask = PhysicsCategory.all
        
        anchor.position = CGPoint(x: mapNode.frame.midX / 2, y: mapNode.frame.midY / 2)
        addSlingShot()
        addChild(anchor)
        addBird()

    }
    
    func addCamera(){
        guard let view = view else {
            return
        }
        gameCamera.position = CGPoint(x: view.bounds.size.width / 2 , y: view.bounds.size.height / 2 )
        addChild(gameCamera)
        camera = gameCamera
        gameCamera.setConstrains(with: self, and: mapNode.frame, to: nil)
        
        
    }
    
    func addSlingShot(){
        let slingshot = SKSpriteNode(imageNamed: "slingshot")
        let scaleSize = CGSize(width: 0, height: mapNode.frame.midY / 2 - mapNode.tileSize.height / 2)
        slingshot.aspectScale(to: scaleSize, width: false, multiplier: 1.0)
    
        slingshot.position = CGPoint(x: anchor.position.x, y: mapNode.tileSize.height + slingshot.size.height / 2)
        slingshot.zPosition = ZPosition.obstacles
        mapNode.addChild(slingshot)
        
    }
    
    
    func addBird(){
        
        if birds.isEmpty{
            presntPopup(victory: false)
            return
        }
        bird = birds.removeFirst()
        
        bird.physicsBody = SKPhysicsBody(rectangleOf: bird.size)
        bird.physicsBody?.categoryBitMask = PhysicsCategory.bird
        bird.physicsBody?.contactTestBitMask = PhysicsCategory.all
        //bird collision physicsBody when  hit with the block  or contact with the ground
        bird.physicsBody?.collisionBitMask = PhysicsCategory.block | PhysicsCategory.edge
        bird.physicsBody?.isDynamic = false
        
        bird.position = anchor.position
        bird.zPosition = ZPosition.birds
        addChild(bird)
        bird.aspectScale(to: mapNode.tileSize, width: true, multiplier: 1.0)
        constraintToAnchor(active: true)
        roundState = .ready
    }
    
    func constraintToAnchor(active:Bool){
        
        if active{
            
            let slingRange = SKRange(lowerLimit: 0.0, upperLimit: bird.size.width*3)
            
            let positionConstraint = SKConstraint.distance(slingRange, to: anchor)
            
            bird.constraints = [positionConstraint]
        }
        else{
            bird.constraints?.removeAll()
        }
    }
    
    
    func presntPopup(victory:Bool){
        if victory{
            createPopup(type: 0)
        }else{
            createPopup(type: 1)
        }
        
    }
    func createPopup(type:Int){
        let popup = Popup(type: type, size:frame.size)
            popup.zPosition = ZPosition.hudBackground
            popup.popupButtonHandlerDelegate = self
            gameCamera.addChild(popup)
    }
    func createEnemy(from placeholder:SKSpriteNode, name:String) ->Enemy?{
        
        guard let enemyType = EnemyType(rawValue: name) else {
            return nil
        }
        
        let enemy = Enemy(enemyType: enemyType)
        enemy.size = placeholder.size
        enemy.position = placeholder.position
        enemy.zPosition = ZPosition.obstacles
        enemy.createPhysicsBody()
        
        return enemy
    }
    
    func createBlock(from placeholder:SKSpriteNode, name:String) -> Block?{
        guard let type = BlockType(rawValue: name)else{return nil}
    
        
         let block = Block(type: type)
         block.size = placeholder.size
         block.position = placeholder.position
         block.zPosition = ZPosition.obstacles
         block.zRotation = placeholder.zRotation
         block.createPhysicsBody()
         return block
        
    }
    override func didSimulatePhysics() {
        guard let physicsBody = bird.physicsBody else {
            return
        }
        
        if roundState == .flying && physicsBody.isResting{
            
            gameCamera.setConstrains(with: self, and: mapNode.frame, to: nil)
            bird.removeFromParent()
            roundState = .finished
        }
        
        
    }
    
  
}

//MARK: - PopupButtonHandlerDelegate
extension GameScene: PopupButtonHandlerDelegate{
    
    func menuTapped() {
        sceneManageDelegate?.presentLevelSence()
    }
    
    func nextTapped() {
        if let  level = level{
            sceneManageDelegate?.presentGameSenceFor(level: level + 1)
        }
    }
    
    func retryTapped() {
        if let level = level{
            sceneManageDelegate?.presentGameSenceFor(level: level)
        }
    }
    
    
}

//MARK: - SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate{
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let mask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch mask {
            
        case PhysicsCategory.bird | PhysicsCategory.block , PhysicsCategory.block | PhysicsCategory.edge :
            
            
            if let block = contact.bodyB.node as? Block{
                
                block.impact(with: Int(contact.collisionImpulse))
            }
                
            else if let block = contact.bodyA.node as? Block{
                block.impact(with: Int(contact.collisionImpulse))
            }
            
            
            
            if let bird = contact.bodyA.node as? Bird{
                bird.flying = false
            }
            else if let bird = contact.bodyB.node as? Bird{
                bird.flying = false

                
            }
            
            
        case PhysicsCategory.block | PhysicsCategory.block :
            if let block = contact.bodyB.node as? Block{
                          
                block.impact(with: Int(contact.collisionImpulse))
            }

            else if let block = contact.bodyA.node as? Block{
                
                block.impact(with: Int(contact.collisionImpulse))
            }
      
            
        case PhysicsCategory.bird | PhysicsCategory.edge:
            bird.flying = false

        case PhysicsCategory.bird | PhysicsCategory.enemy :
            if let enemy = contact.bodyA.node as? Enemy{
                
                if enemy.impact(with: Int(contact.collisionImpulse)){
                    enemies -= 1
                }
                
            }
            else if let enemy = contact.bodyB.node as? Enemy{
                if enemy.impact(with: Int(contact.collisionImpulse)){
                    enemies -= 1

                }

            }
            
            
            
        
        default:
            break
        }
    
    }
}

 //MARK: - Obective C methods
extension GameScene {
    
    
    @objc func pan(sender: UIPanGestureRecognizer){
        guard let view=view else {return}
        
        let transaltion = sender.translation(in: view) * gameCamera.yScale
        gameCamera.position = CGPoint(x: gameCamera.position.x - transaltion.x, y: gameCamera.position.y + transaltion.y)
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    @objc func pinch(sender: UIPinchGestureRecognizer){
        
        guard let view = view else {return}
        
        let locatioInView = sender.location(in: view)
        
        let location = convertPoint(fromView: locatioInView)
        
        
        if sender.numberOfTouches == 2 {
            
            if sender.state == .changed{
                let convertedScale = 1/sender.scale
                let newScale = gameCamera.yScale * convertedScale
                
                if newScale < maxScale && newScale > 0.5  {
                gameCamera.setScale(newScale)
                }
                
                let locationAfteScale = convertPoint(toView: locatioInView)
                
                //let locationDelta = CGPoint(x: loaction.x - locationAfteScale.x, y: loaction.y - locationAfteScale.y)
                let locationDelta = location - locationAfteScale
                
                //let newPosition = CGPoint(x: gameCamera.position.x + locationDelta.x, y: gameCamera.position.y + locationDelta.y)
                
                let newPosition = gameCamera.position + locationDelta
                
                
                gameCamera.position = newPosition
                
                sender.scale = 1.0
                
                gameCamera.setConstrains(with: self, and: mapNode.frame, to: nil)
                
                
            }
        }
        
    }
    
    
}
