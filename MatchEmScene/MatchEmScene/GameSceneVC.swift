//
//  ViewController.swift
//  MatchEmScene
//
//  Created by Elliott Ullman on 3/29/21.
//

import UIKit

class GameSceneViewController: UIViewController {

    // MARK: - ==== Config Properties ====
    //===============================================
    // Min and max width and height for rectangles
    private let rectSizeMin:CGFloat = 50.0
    private let rectSizeMax:CGFloat = 150.0
    
    private var randomAlpha = false
    
    private var fadeDuration: TimeInterval = 0.8
    
    private var newRectInterval: TimeInterval = 1.2
    private var newRectTimer: Timer?
    private var gameDuration: TimeInterval = 12.0
    private var gameTimer: Timer?
    
    private var rectanglesCreated = 0 { didSet {gameInfoLabel?.text = gameInfo} }
    private var rectanglesTouched = 0 { didSet {gameInfoLabel?.text = gameInfo} }
    
    
    
    // MARK: - ==== Internal Properties ====
    // array of rectangles
    private var rectangles = [UIButton]()
    
    private var gameInProgress = false
    
    @IBOutlet weak var gameInfoLabel: UILabel!
    private var gameInfo: String {
        let labelText = String(format: "Time: %2.1f Created: %2d Touch: %2d", gameTimeRemaining, rectanglesCreated, rectanglesTouched)
        return labelText
    }
    
    private lazy var gameTimeRemaining = gameDuration { didSet {gameInfoLabel?.text = gameInfo} }
    
    // MatchEm properties
    private var rectangleDict: [UIButton: UIButton] = [:]
    private var firstButton: UIButton?
    private var buttonPressed = false
    
    
    
    // MARK: - ==== View Controller Methods ====
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Super call
        super.viewWillAppear(animated)
        
        // Create rectangles
        startGameRunning()
        
    }
    
    //===============================================
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //===============================================
    @objc private func handleTouch(sender: UIButton) {
        
        if gameInProgress {
            
            // if a button has been pressed already
            if buttonPressed {
                
                // if second button is pair
                if rectangleDict[firstButton!] == sender {
                    sender.setTitle("😃", for: .normal)
                    
                    rectanglesTouched += 1
                    
                    removeRectangle(rectangle: sender)
                    removeRectangle(rectangle: firstButton!)
                }
                // if not, unhighlight initial button
                else {
                    firstButton!.setTitle("", for: .normal)
                }
                
                // reset our flag conditional
                buttonPressed = false
                
            }
            // not previously pressed button
            else {
                // highlight, capture button for comparing, set our conditional
                sender.setTitle("😃", for: .normal)
                firstButton = sender
                buttonPressed = true
            }
            
        }
        // if game not in progress, do nothing
        else{
            return
        }
        
    }

}

// MARK: - ==== Rectangle Methods ====
extension GameSceneViewController {
    
    //===============================================
    private func createRectangle() {
        
        // random values
        let randSize = Utility.getRandomSize (fromMin: rectSizeMin, throughMax: rectSizeMax)
        let randLocation1 = Utility.getRandomLocation(size: randSize, screenSize: view.bounds.size)
        let randLocation2 = Utility.getRandomLocation(size: randSize, screenSize: view.bounds.size)
        let randomFrame1 = CGRect(origin: randLocation1, size: randSize)
        let randomFrame2 = CGRect(origin: randLocation2, size: randSize)
        
        let rectangle1 = UIButton(frame: randomFrame1)
        let rectangle2 = UIButton(frame: randomFrame2)
        
        // Save til end of game
        rectangles.append(rectangle1)
        rectangles.append(rectangle2)
        rectanglesCreated += 1
        
        // dictionary additions
        rectangleDict.updateValue(rectangle1, forKey: rectangle2)
        rectangleDict.updateValue(rectangle2, forKey: rectangle1)
        
        
        // Do some button/rectangle setup
        var randomColor = Utility.getRandomColor(randomAlpha: randomAlpha)
        rectangle1.backgroundColor = randomColor
        rectangle1.setTitle("", for: .normal)
        rectangle1.setTitleColor(.black, for: .normal)
        rectangle1.titleLabel?.font = .systemFont(ofSize: 50)
        rectangle1.showsTouchWhenHighlighted = true
        
        rectangle2.backgroundColor = randomColor
        rectangle2.setTitle("", for: .normal)
        rectangle2.setTitleColor(.black, for: .normal)
        rectangle2.titleLabel?.font = .systemFont(ofSize: 50)
        rectangle2.showsTouchWhenHighlighted = true
        
        // target/action connect button to VC
        rectangle1.addTarget(self, action: #selector(self.handleTouch(sender:)), for: .touchUpInside)
        rectangle2.addTarget(self, action: #selector(self.handleTouch(sender:)), for: .touchUpInside)
        
        // Make the rectangle visible
        self.view.addSubview(rectangle1)
        self.view.addSubview(rectangle2)
        
        // move label to front
        view.bringSubviewToFront(gameInfoLabel!)
        
        // decrement game time
        gameTimeRemaining -= newRectInterval
        
    }
    
    //===============================================
    func removeRectangle(rectangle: UIButton) {
        
        // fade animation
        let pa = UIViewPropertyAnimator(duration: fadeDuration, curve: .linear, animations: nil)
        
        pa.addAnimations {
            rectangle.alpha = 0.0
        }
        pa.startAnimation()
        
    }
    
    //===============================================
    func removeSavedRectangles() {
        
        for rectangle in rectangles { rectangle.removeFromSuperview() }
        
        rectangles.removeAll()
        
    }
    
}

//MARK: - ==== Timer Functions ====
extension GameSceneViewController {
    
    //===============================================
    private func startGameRunning(){
        
        // init label
        gameInfoLabel.textColor = .black
        gameInfoLabel.backgroundColor = .clear
        
        //reset from previous game
        removeSavedRectangles()
        
        // timer to produce rectangles
        newRectTimer = Timer.scheduledTimer(withTimeInterval: newRectInterval, repeats: true) { _ in self.createRectangle() }
        gameInProgress = true
        
        // game timer
        gameTimer = Timer.scheduledTimer(withTimeInterval: gameDuration, repeats: false) { _ in self.stopGameRunning() }
        
    }
    
    //===============================================
    private func stopGameRunning() {
        
        // stop timer
        if let timer = newRectTimer { timer.invalidate() }
        gameInProgress = false
        
        //remove reference
        self.newRectTimer = nil
        
        // end of game
        gameTimeRemaining = 0.0
        gameInfoLabel?.text = gameInfo
        gameInfoLabel.textColor = .red
        gameInfoLabel.backgroundColor = .black
        
    }
    
}
