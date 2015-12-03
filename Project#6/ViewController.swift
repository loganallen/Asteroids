//
//  ViewController.swift
//  Project#6
//
//  Created by Logan Allen on 11/14/15.
//  Copyright © 2015 loganallen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WriteBackDelegate {

    @IBOutlet weak var highScore: UILabel!
    var currentScore: Int!
    var highS: Int!
    @IBOutlet weak var easy: UISwitch!
    @IBOutlet weak var medium: UISwitch!
    @IBOutlet weak var hard: UISwitch!
    var difficulty = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentScore = 0
        highS = 0
        highScore.text = highS.description
    }
    
    @IBAction func easySwitch(sender: UISwitch) {
        if sender.on == true{
            medium.on = false
            hard.on = false
            difficulty = 1
        }
    }
    @IBAction func medSwitch(sender: UISwitch) {
        if sender.on == true{
            easy.on = false
            hard.on = false
            difficulty = 2
        }
    }
    @IBAction func hardSwitch(sender: UISwitch) {
        if sender.on == true{
            easy.on = false
            medium.on = false
            difficulty = 3
        }
    }
    
    // Tell game the difficulty level
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startGame"{
            let dvc = segue.destinationViewController as! GameViewController
            dvc.highScore = highS
            dvc.difficulty = difficulty
            dvc.delegate = self
        }
    }
    
    func WriteBack(value: Int) {
        print("Sup")
        if value > highS{
            highS = value
            highScore.text = value.description
        }
    }
    
    // Call to return to start screen
    @IBAction func unwindToStartScreen(sender: UIStoryboardSegue){}

}

