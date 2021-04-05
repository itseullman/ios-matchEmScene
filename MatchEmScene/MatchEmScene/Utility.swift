//
//  Utility.swift
//  MatchEmScene
//
//  Created by Elliott Ullman on 3/30/21.
//

import UIKit

class Utility: NSObject {
    
    // MARK: - ==== Random Value Funcs ====
    //===============================================
    static func randomFloatZeroThroughOne() -> CGFloat {
        
        // random value
        let randomFloat = CGFloat.random(in: 0 ... 1.0)
        
        return randomFloat
    
    }
    
    //===============================================
    static func getRandomSize(fromMin min: CGFloat, throughMax max: CGFloat) -> CGSize {
        
        // create random CGSize
        let randWidth  = randomFloatZeroThroughOne() * (max - min) + min
        let randHeight = randomFloatZeroThroughOne() * (max - min) + min
        let randSize   = CGSize(width: randWidth, height: randHeight)
        
        return randSize
        
    }
    
    //===============================================
    static func getRandomLocation(size rectSize: CGSize, screenSize: CGSize) -> CGPoint {
        
        // get screen dimensions
        let screenWidth  = screenSize.width
        let screenHeight = screenSize.height
        
        // create random location
        let rectX = randomFloatZeroThroughOne() * (screenWidth - rectSize.width)
        let rectY = randomFloatZeroThroughOne() * (screenHeight - rectSize.height)
        let location = CGPoint(x: rectX, y: rectY)
        
        return location
        
    }
    
    //===============================================
    static func getRandomColor(randomAlpha: Bool) -> UIColor {
        
        // random vals for RGB
        let randRed = randomFloatZeroThroughOne()
        let randGreen = randomFloatZeroThroughOne()
        let randBlue = randomFloatZeroThroughOne()
        
        // transparency can be none or random
        var alpha:CGFloat = 1.0
        if randomAlpha {
            alpha = randomFloatZeroThroughOne()
        }
        
        return UIColor(red: randRed, green: randGreen, blue: randBlue, alpha: alpha)
        
    }
    
}
