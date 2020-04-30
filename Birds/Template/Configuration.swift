//
//  Configuration.swift
//  Birds
//
//  Created by yaron mordechai on 05/04/2020.
//  Copyright © 2020 yaron mordechai. All rights reserved.
//

import CoreGraphics



struct Levels {
    static var levelsDictionary = [String:Any]()
}

struct ZPosition {
    
    
    static let background:CGFloat = 0
    static let obstacles:CGFloat = 1
    static let birds:CGFloat = 2
     //menu/buttons etc
    static let hudBackground:CGFloat = 10
    static let hudLabel:CGFloat = 11
}

struct PhysicsCategory {
       static let none: UInt32 = 0
       static let all: UInt32 = UInt32.max
       static let edge: UInt32 = 0x1
       static let bird : UInt32 = 0x1 << 1
       static let block : UInt32 = 0x1 << 2
       static let enemy: UInt32 = 0x1 << 3
    
   }


extension CGPoint {
    
    static public func + ( left:CGPoint , right: CGPoint) ->CGPoint{
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    static public func - ( left:CGPoint , right: CGPoint) ->CGPoint{
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    static public func * (left:CGPoint , right:CGFloat) -> CGPoint {
        return CGPoint(x: left.x * right, y: left.y * right)
        
    
    }
    
    

   
}
