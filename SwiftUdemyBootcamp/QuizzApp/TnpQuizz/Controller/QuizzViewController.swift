//
//  ViewController.swift
//  TnpQuizz
//
//  Created by Tiago Pestana on 01/06/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit

class QuizzViewController: UIViewController
{
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblExplanation: UILabel!
    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    
    @IBOutlet weak var btnTrue: UIButton!
    @IBOutlet weak var btnFalse: UIButton!
    @IBOutlet weak var btnRetry: UIButton!
    
    let questionBank = QuestionBank()
    var questionIndex = 0
    var score = 0
    
    var correctStr = "Correct!"
    var wrongStr = "Wrong!"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        btnTrue.layer.cornerRadius = 5
        btnFalse.layer.cornerRadius = 5
        btnRetry.layer.cornerRadius = 5
        
        retry()
    }
    
    
    @IBAction func retryBtnTapped(_ sender: Any)
    {
        retry()
    }
    
    @IBAction func answerChosen(_ sender: UIButton)
    {
        let answer = sender.tag == 0 ? false : true
        validateAnswer(answer: answer)
    }
    
    
    @IBAction func quitBtnTapped(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func validateAnswer(answer: Bool)
    {
        let result = answer == questionBank.list[questionIndex].answer
        btnTrue.isEnabled = false
        btnFalse.isEnabled = false
        lblExplanation.isHidden = false
        lblExplanation.text = questionBank.list[questionIndex].explanation
        if result
        {
            // correct
            score += 100;
            lblQuestion.text = correctStr;
        }
        else
        {
            lblQuestion.text = wrongStr;
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute:
            {
                // Put your code which should be executed with a delay here
                self.nextQuestion()
            })
    }
    
    func nextQuestion()
    {
        questionIndex += 1
        
        updateUI()
    }
    
    func updateUI()
    {
        lblProgress.text = "Progress: \(questionIndex)/\(String(questionBank.list.count))"
        lblScore.text = "Score: \(String(format: "%04d", score))"
        
        if questionIndex >= questionBank.list.count
        {
            quizzFinished()
            
            return
        }
        
        btnTrue.isEnabled = true
        btnFalse.isEnabled = true
        lblExplanation.isHidden = true
        lblQuestion.text = questionBank.list[questionIndex].question
    }
    
    func quizzFinished()
    {
        var conditionalStr = "Too bad,"
        if score >= questionBank.list.count / 2 * 100
        {
            conditionalStr = "Well done,"
        }
        lblQuestion.text = "\(conditionalStr) you've finished the quizz with a score of \(String(format: "%03d", score)) points"
        btnTrue.isHidden = true
        btnFalse.isHidden = true
        btnRetry.isHidden = false
        lblExplanation.isHidden = true
    }
    
    func retry()
    {
        btnTrue.isHidden = false
        btnFalse.isHidden = false
        btnRetry.isHidden = true
        
        score = 0
        questionIndex = 0
        updateUI()
    }
}

