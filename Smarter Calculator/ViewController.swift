//
//  ViewController.swift
//  Smarter Calculaor
//
//  Created by Ahmed Al-Zahrani on 2018-05-07.
//  Copyright © 2018 Ahmed Al-Zahrani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var brain: CalculatorBrain = CalculatorBrain()
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var variableLabel: UILabel!

    var userIsTyping = false
    var enteringFloat = false
    var variables = [String: Double]()
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    func handleEvaluation() {
        let evaluation = brain.evaluate(using: variables)
        if let result = evaluation.result {
            displayValue = result
        }
        if (evaluation.isPending) {
            descriptionLabel.text = evaluation.description + "..."
        } else {
            descriptionLabel.text = evaluation.description + "= "
        }
    }
    
    private func isBinary(operation: String) -> Bool {
        return operation == "+" || operation == "x" || operation == "÷" || operation == "-"
    }
    
    
    @IBAction func touchClear(_ sender: UIButton) {
        display.text = "0"
        userIsTyping = false
        enteringFloat = false
        variables.removeAll()
        brain.clearSequence()
        handleEvaluation()
        variableLabel.text = "M = 0.0"
        descriptionLabel.text! = " "
    }
    
    @IBAction func touchUndo(_ sender: UIButton) {
        if userIsTyping{
            userIsTyping = false
            display.text = "0"
        } else {
            brain.undo()
            handleEvaluation()
        }
    }
    
    @IBAction func touchSetVar(_ sender: UIButton) {
        variables["M"] = 0.0
        brain.setOperand(variable: "M")
        variableLabel.text! = "M = 0.0"
    }
    
    
    @IBAction func touchEvalVar(_ sender: UIButton) {
        variables["M"] = displayValue
        variableLabel.text! = "M = " + displayValue.description
        userIsTyping = false
        handleEvaluation()
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if (digit == ".") {
            if (enteringFloat){
                return
            } else {
                enteringFloat = true
            }
        }
        
        if userIsTyping {
            let textCurrentlyInDisplay = display!.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            userIsTyping = true
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsTyping {
            if (isBinary(operation: sender.currentTitle!)){
                brain.clearSequence()
            }
            brain.setOperand(displayValue)
            userIsTyping = false
        }
         if let symbol = sender.currentTitle {
            brain.addToSequence(symbolToAdd: symbol)
            handleEvaluation()
        }
    }

}

