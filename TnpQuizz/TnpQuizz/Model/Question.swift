//
//  Question.swift
//  TnpQuizz
//
//  Created by Tiago Pestana on 02/06/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import Foundation

class Question
{
    let question: String
    let answer: Bool
    let explanation: String
    
    init(question: String, answer: Bool, explanation: String)
    {
        self.question = question
        self.answer = answer
        self.explanation = explanation
    }
}
