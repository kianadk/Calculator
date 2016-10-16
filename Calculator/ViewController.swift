//
//  ViewController.swift
//  Calculator
//
//  Created by Kiana Kavoosi on 6/12/16.
//  Copyright © 2016 Kiana Kavoosi. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    
    @IBOutlet private weak var display: UILabel!
    
    @IBOutlet private weak var displayDescription: UILabel!
    
    
    private var userIsInTheMiddleOfTyping = false
    private var displayValueHasDecimal = false
    
    @IBAction private func touchDigit(sender: UIButton){
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping{
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        }
        else{
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    
    @IBAction private func addDecimal() {
        if(!displayValueHasDecimal){
            if(userIsInTheMiddleOfTyping){
                display.text = display.text! + "."
            }
            else{
                display.text = "0."
                userIsInTheMiddleOfTyping = true
            }
            displayValueHasDecimal = true
        }
    }

    
    private var displayValue: Double{
        get{
            return Double(display.text!)!
        }
        
        set{
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(sender: UIButton){
        if(userIsInTheMiddleOfTyping){
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
            displayValueHasDecimal = false
        }
        if let mathematicalSymbol = sender.currentTitle{
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
        if brain.isPartialResult{
            displayDescription.text = brain.description + " ... "
        } else{
            displayDescription.text = brain.description + " = "
        }
        
    }
    
    
}

