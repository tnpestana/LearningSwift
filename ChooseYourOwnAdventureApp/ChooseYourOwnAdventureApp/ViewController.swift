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
    @IBOutlet weak var txtStoryline: UITextView!
    
    @IBOutlet weak var btnAnswer1: UIButton!
    @IBOutlet weak var btnAnswer2: UIButton!

    let storyline = Storyline()
    var storyIndex: Int = 1
    let retryString = "Retry"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        txtStoryline.text = storyline.story1
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
                storyIndex = 3
                txtStoryline.text = storyline.story3
                btnAnswer1.setTitle(storyline.answer3a, for: [])
                btnAnswer2.setTitle(storyline.answer3b, for: [])
            }
            else
            {
                storyIndex = 2
                txtStoryline.text = storyline.story2
                btnAnswer1.setTitle(storyline.answer2a, for: [])
                btnAnswer2.setTitle(storyline.answer2b, for: [])
            }
        case 2:
            if sender.tag == 1
            {
                storyIndex = 3
                txtStoryline.text = storyline.story3
                btnAnswer1.setTitle(storyline.answer3a, for: [])
                btnAnswer2.setTitle(storyline.answer3b, for: [])
            }
            else
            {
                storyIndex = 4
                txtStoryline.text = storyline.story4
                btnAnswer1.setTitle(retryString, for: [])
                btnAnswer2.isHidden = true
            }
            break
        case 3:
            if sender.tag == 1
            {
                storyIndex = 6
                txtStoryline.text = storyline.story6
                btnAnswer1.setTitle(retryString, for: [])
                btnAnswer2.isHidden = true
            }
            else
            {
                storyIndex = 5
                txtStoryline.text = storyline.story5
                btnAnswer1.setTitle(retryString, for: [])
                btnAnswer2.isHidden = true
            }
            break
        default:
            storyIndex = 1
            txtStoryline.text = storyline.story1
            btnAnswer1.setTitle(storyline.answer1a, for: [])
            btnAnswer2.setTitle(storyline.answer1b, for: [])
            btnAnswer2.isHidden = false
        }
        
        
    }
}

