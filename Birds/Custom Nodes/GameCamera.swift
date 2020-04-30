//
//  GameCamera.swift
//  Birds
//
//  Created by yaron mordechai on 30/03/2020.
//  Copyright © 2020 yaron mordechai. All rights reserved.
//

import SpriteKit
class GameCamera: SKCameraNode {
    
    
    //seting the Constrains to limit the frame
    func setConstrains(with secne:SKScene, and frame:CGRect ,to node:SKNode?){
        
 
        let scaledSize = CGSize(width: scene!.size.width * xScale, height: scene!.size.height * yScale)
        
        let boradContentRect = frame
        
        let xInset = min(scaledSize.width / 2,boradContentRect.width / 2)
        let yInset = min(scaledSize.height / 2,boradContentRect.height / 2)
        
      
        let insetContentRect = boradContentRect.insetBy(dx: xInset, dy: yInset)
        
        let xRange = SKRange(lowerLimit: insetContentRect.minX, upperLimit: insetContentRect.maxX)
        let yRange = SKRange(lowerLimit: insetContentRect.minY, upperLimit: insetContentRect.maxY)
        
        let levelEdgeConstraint = SKConstraint.positionX(xRange, y: yRange)
        
        if let node =  node{
            
            let zeroRange = SKRange(constantValue: 0.0)
            
            let poistionConstriant = SKConstraint.distance(zeroRange, to: node)
            
            constraints = [poistionConstriant ,levelEdgeConstraint ]
        }
        else{
              constraints = [levelEdgeConstraint]
        }
        
        
      
        
    }
    

}
