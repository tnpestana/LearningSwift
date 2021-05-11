//
//  ViewController.swift
//  ChooseYourOwnAdventureApp
//
//  Created by Tiago Pestana on 06/06/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var lblStoryline: UILabel!
    @IBOutlet weak var btnAnswer1: UIButton!
    @IBOutlet weak var btnAnswer2: UIButton!

    let storyline = Storyline()
    var storyIndex: Int = 1
    let retryString = "Retry"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblStoryline.text = storyline.story1
        btnAnswer1.setTitle(storyline.answer1a, for: [])
        btnAnswer2.setTitle(storyline.answer1b, for: [])
    }
    
    @IBAction func answerTapped(_ sender: UIButton)
    {
        switch storyIndex
        {
        case 1:
            if sender.tag == 1
            {
                story3()
            }
            else
            {
                story2()
            }
        case 2:
            if sender.tag == 1
            {
                story3()
            }
            else
            {
                story4()
            }
        case 3:
            if sender.tag == 1
            {
                story6()
            }
            else
            {
                story5()
            }
        default:
            retry()
        }
    }
    
    func retry()
    {
        storyIndex = 1
        lblStoryline.text = storyline.story1
        btnAnswer1.setTitle(storyline.answer1a, for: [])
        btnAnswer2.setTitle(storyline.answer1b, for: [])
        btnAnswer2.isHidden = false
    }
    
    func story2()
    {
        storyIndex = 2
        lblStoryline.text = storyline.story2
        btnAnswer1.setTitle(storyline.answer2a, for: [])
        btnAnswer2.setTitle(storyline.answer2b, for: [])
    }
    
    func story3()
    {
        storyIndex = 3
        lblStoryline.text = storyline.story3
        btnAnswer1.setTitle(storyline.answer3a, for: [])
        btnAnswer2.setTitle(storyline.answer3b, for: [])
    }
    
    func story4()
    {
        storyIndex = 4
        lblStoryline.text = storyline.story4
        btnAnswer1.setTitle(retryString, for: [])
        btnAnswer2.isHidden = true
    }
    
    func story5()
    {
        storyIndex = 5
        lblStoryline.text = storyline.story5
        btnAnswer1.setTitle(retryString, for: [])
        btnAnswer2.isHidden = true
    }
    
    func story6()
    {
        storyIndex = 6
        lblStoryline.text = storyline.story6
        btnAnswer1.setTitle(retryString, for: [])
        btnAnswer2.isHidden = true
    }
}

