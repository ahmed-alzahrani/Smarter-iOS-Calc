//
//  CalculatorBrain.swift
//  Smarter Calculaor
//
//  Created by Ahmed Al-Zahrani on 2018-05-07.
//  Copyright © 2018 Ahmed Al-Zahrani. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    // sequence stores inputs as long as we may need them to re-evalaute
    private var sequence: [String] = []
    
    mutating func addToSequence(symbolToAdd: String){
        sequence.append(symbolToAdd)
    }
    
    mutating func clearSequence() {
        sequence.removeAll()
    }
    
    mutating func undo() {
        if let last = sequence.last {
            print(last)
            if last == "="{
                sequence.removeLast()
                sequence.removeLast()
            }
        }
        sequence.removeLast()
    }
    
    // below are the functions used within evalaute to generate accurate descriptions
    private func editDescription(symbolToAdd: String, currentDescription: String?) -> String {
        var newString: String
        if (currentDescription != nil) {
            newString = currentDescription! + symbolToAdd
        } else {
            newString = symbolToAdd
        }
        newString += " "
        return newString
    }

    private func editDescriptionOnUnary(symbolToAdd: String, currentDescription: String?, pending: Bool) -> String {
        if (currentDescription != nil && (pending)) {
             return describeUnaryWithPending(symbolToAdd: symbolToAdd, currentDescription: currentDescription)
        } else {
            return symbolToAdd + "( " + currentDescription! + " ) "
        }
    }
    
    private func describeUnaryWithPending(symbolToAdd: String, currentDescription: String?) -> String{
        var count = 0
        var sinceLastSymbol = 0
        for character in currentDescription! {
            if (characterCheck(char: character)){
                sinceLastSymbol += 1
                continue
            } else {
                count += sinceLastSymbol
                sinceLastSymbol = 0
            }
        }
        let splitIndex = currentDescription!.index(currentDescription!.startIndex, offsetBy: count)
        let substring1 = currentDescription![..<splitIndex]
        let substring2 = currentDescription![splitIndex...]
        return substring1 + symbolToAdd + "(" + substring2 + ")"
    }
    
    private func characterCheck(char: Character) -> Bool {
        return ((char >= "0" && char <= "9") || char == "." || char == "∏" || char == "e")
    }
    
    // Operation Enum
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String,Operation> = [
        "∏" : .constant(Double.pi),
        "e" : .constant(M_E),
        "√" : .unaryOperation(sqrt),
        "±" : .unaryOperation({ -$0 }),
        "x" : .binaryOperation({ $0 * $1}),
        "+" : .binaryOperation({ $0 + $1}),
        "-" : .binaryOperation({ $0 - $1}),
        "÷" : .binaryOperation({ $0 / $1}),
        "=" : .equals
    ]
    
    
    // Pending Binary Struct/Funcs
    
    private func performPendingBinary(pending: PendingBinaryOperation, performWith: Double) -> Double {
        return pending.perform(with: performWith)
    }
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        sequence.append(operand.description)
    }
    
    mutating func setOperand(variable named: String) {
        sequence.append(named)
    }
    
    private func isVar(toEval: String) -> Bool {
        return toEval.contains("M")
    }
    
    func evaluate(using variables: Dictionary<String, Double>? = nil) -> (result: Double?, isPending: Bool, description: String) {
        var accumulator: Double?
        var pendingBinary: PendingBinaryOperation?
        var description: String?
        for item in sequence {
            if let operation = operations[item] {
                switch operation {
                case .constant(let value):
                    accumulator = value
                    description = editDescription(symbolToAdd: item, currentDescription: description)
                    
                case .unaryOperation(let function):
                    if (accumulator != nil) {
                        accumulator = function(accumulator!)
                        description = editDescriptionOnUnary(symbolToAdd: item, currentDescription: description, pending: (pendingBinary != nil))
                    }
                    
                case .binaryOperation(let function):
                    if accumulator != nil {
                        pendingBinary = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                        description = editDescription(symbolToAdd: item, currentDescription: description)
                        accumulator = nil
                    }
                    
                case .equals:
                    if pendingBinary != nil && accumulator != nil {
                        accumulator = pendingBinary?.perform(with: accumulator!)
                        pendingBinary = nil
                    }
                    break
                }
            } else {
                if (isVar(toEval: item)){
                    if let value = variables![item] {
                        accumulator = value
                    } else {
                        accumulator = 0.0
                    }
                    description = editDescription(symbolToAdd: item, currentDescription: description)
                } else {
                    // digit or numeric number
                    accumulator = Double(item)
                    description = editDescription(symbolToAdd: item, currentDescription: description)
                }
            }
            
        }
        let pending = (pendingBinary != nil)
        
        if let descriptionString = description {
            return (accumulator, pending, descriptionString)
        } else {
            return (accumulator, pending, " ")
        }
    }
    
   
    
}
