//
//  GameViewController.swift
//  Project#6
//
//  Created by Logan Allen on 11/14/15.
//  Copyright © 2015 loganallen. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollisionBehaviorDelegate {
    
    var delegate: WriteBackDelegate!
    
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var rocket: UIImageView!
    
    @IBOutlet weak var barButton: UIBarButtonItem!
    var animator: UIDynamicAnimator!
    var collision: UICollisionBehavior!
    var gravity: UIGravityBehavior!
    
    var enemyTimer: NSTimer!
    var shootTimer: NSTimer!
    
    var lasers: [UIImageView] = []
    var spawningRate = 0.5
    var scoreCount = 0
    var highScore = 0
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    var width = 0.0
    var height = 0.0
    var alive = true
    var difficulty = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        barButton.enabled = false
        width = Double(view.frame.width)
        height = Double(view.frame.height)
        score.text = scoreCount.description
        
        if difficulty == 2{
            spawningRate = 0.3
        }else if difficulty == 3{
            spawningRate = 0.1
        }else{
            spawningRate = 0.5
        }
        
        animator = UIDynamicAnimator(referenceView: self.view)
        
        collision = UICollisionBehavior(items: [rocket])
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.collisionDelegate = self
        
        gravity = UIGravityBehavior()
        gravity.magnitude = CGFloat(0.6)
        
        // Initialize enemy timer
        enemyTimer = NSTimer.scheduledTimerWithTimeInterval(spawningRate, target: self, selector: "enemyTimerFired:", userInfo: nil, repeats: true)
        
        gameOverLabel.hidden = true
        highScoreLabel.hidden = true
        
    }
    
    // Move rocket side to side
    @IBAction func panRocket(sender: UIPanGestureRecognizer) {
        print("Taking Gesture")
        let rocketView = sender.view!
        // Compare translation relative to some view
        let translation = sender.translationInView(self.view)
        rocketView.center = CGPoint(x: rocketView.center.x + translation.x, y: rocketView.center.y)
        // Tell gesture recognizer to reset itself to 0 (or else would accumulate)
        sender.setTranslation(CGPointZero, inView: self.view)
        animator.updateItemUsingCurrentState(rocket)
    }
    
    // Create new asteroid at top
    func enemyTimerFired(sender: NSTimer){
        let asteroid = UIImageView(frame: CGRect(x: randX(), y: 1.0, width: 35.0, height: 35.0))
        asteroid.image = UIImage(named: "asteroid")
        
        self.view.addSubview(asteroid)
        gravity.addItem(asteroid)
        animator.addBehavior(gravity)
        collision.addItem(asteroid)
        animator.addBehavior(collision)
    }
    
    // Increase score when asteroid hits bottom of screen
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        if (item as! UIView) != rocket && alive == true{
            scoreCount += 1
            score.text = scoreCount.description
            gravity.removeItem(item)
            collision.removeItem(item)
            (item as! UIView).removeFromSuperview()
        }
    }
    
    
    // When asteroid hits rocket
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint) {
        let obj1 = item1 as! UIView
        let obj2 = item2 as! UIView
        if obj1 == rocket || obj2 == rocket{
            collision.removeItem(rocket)
            rocket.hidden = true
            alive = false
            gameOverLabel.hidden = false
            barButton.enabled = true
            if scoreCount > highScore{
                highScoreLabel.hidden = false
            }
        }
    }
    @IBAction func HomeButtonPressed(sender: UIBarButtonItem) {
        print("Hi")
        delegate.WriteBack(scoreCount)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // Return random x value between 0-300
    func randX() -> Double{
        let num = Double(arc4random_uniform(UInt32(self.width)) + 0)
        return num
    }
    
    

}

extension UIColor {
    class func randomColor() -> UIColor {
        let r = CGFloat(drand48())
        let g = CGFloat(drand48())
        let b = CGFloat(drand48())
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}