//
//  QuestionBank.swift
//  TnpQuizz
//
//  Created by Tiago Pestana on 02/06/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import Foundation

struct QuestionBank
{
    var list = [Question]()
    
    init()
    {
        // Add the Question to the list of questions
        list.append(Question(question: "Valentine\'s day is banned in Saudi Arabia.", answer: true, explanation: "According to the BBC, religious police banned red roses and sale of Valentine's day gifts as it is both un-Islamic and encourages relations of men and women outside wedlock."))
        
        list.append(Question(question: "A slug\'s blood is green.", answer: true, explanation: "52 bones in the feet and 206 in the whole body."))
        
        list.append(Question(question: "Approximately one quarter of human bones are in the feet.", answer: true, explanation: ""))
        
        list.append(Question(question: "The total surface area of two human lungs is approximately 70 square metres.", answer: true, explanation: "Under West Virginia state code §20-2-4 it is legal to take home and eat roadkill."))
        
        list.append(Question(question: "In West Virginia, USA, if you accidentally hit an animal with your car, you are free to take it home to eat.", answer: true, explanation: ""))
        
        list.append(Question(question: "In London, UK, if you happen to die in the House of Parliament, you are technically entitled to a state funeral, because the building is considered too sacred a place.", answer: false, explanation: ""))
        
        list.append(Question(question: "It is illegal to pee in the Ocean in Portugal.", answer: true, explanation: ""))
        
        list.append(Question(question: "You can lead a cow down stairs but not up stairs.", answer: false, explanation: "You can lead a cow up the stairs but not down the stairs. A cow’s ankle and knee joints are misaligned for supporting the animal’s weight when travelling down stairs."))
        
        list.append(Question(question: "Google was originally called \"Backrub\".", answer: true, explanation: "Larry and Sergey began collaborating on a search engine called BackRub in 1996."))
        
        list.append(Question(question: "Buzz Aldrin\'s mother\'s maiden name was \"Moon\".", answer: true, explanation: "Her name was Marion Moon."))
        
        list.append(Question(question: "The loudest sound produced by any animal is 188 decibels. That animal is the African Elephant.", answer: false, explanation: "Loud structured sounds of Blue Whales have been recorded in excess of 188 db (louder than a jet engine). The Tiger Pistol Shrimp is able to snap its claw and stun its prey by emitting a sound up to 200 db."))
        
        list.append(Question(question: "No piece of square dry paper can be folded in half more than 7 times.", answer: false, explanation: ""))
        
        list.append(Question(question: "Chocolate affects a dog\'s heart and nervous system; a few ounces are enough to kill a small dog.", answer: true, explanation: "Theobromine is a bitter alkaloid of the cocoa plant found in chocolate. Although harmless to humans, it can cause vomiting, diarrhoea, convulsions and even death in animals that digest theobromine slowly, such as dogs. The lethal dosage is between 250 and 500 mg per kg of body weight."))
    }
}
