//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Kiana Kavoosi on 6/13/16.
//  Copyright © 2016 Kiana Kavoosi. All rights reserved.
//

import Foundation
class CalculatorBrain
{
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    private var contentsOfAccumulatorAreDisplayed = true
    var description = ""
    var isPartialResult: Bool{
        get{
            return (pending != nil)
        }
    }
    
    func setOperand(operand: Double){
        accumulator = operand
        internalProgram.append(operand)
        contentsOfAccumulatorAreDisplayed = false
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "sin" : Operation.UnaryOperation(sin),
        "cos" : Operation.UnaryOperation(cos),
        "tan" : Operation.UnaryOperation(tan),
        "ln" : Operation.UnaryOperation(log),
        "×" : Operation.BinaryOperation({ $0 * $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 } ),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "−" : Operation.BinaryOperation({ $0 - $1 }),
        "=" : Operation.Equals,
        "c" : Operation.Clear
    ]
    
    private enum Operation{
        case Constant(Double)
        case UnaryOperation((Double) -> (Double))
        case BinaryOperation((Double, Double) -> (Double))
        case Equals
        case Clear
    }
    
    func performOperation(symbol: String){
        internalProgram.append(symbol)
        if let operation = operations[symbol]
        {
            switch operation
            {
            case .Constant(let value):
                if isPartialResult{
                    description += symbol
                }
                else{
                    description = symbol
                }
                contentsOfAccumulatorAreDisplayed = true
                accumulator = value
            case .UnaryOperation(let function):
                if isPartialResult{
                    description += symbol + "(" + String(accumulator) + ")"
                } else{
                    description = symbol + "(" + description + ")"
                }
                contentsOfAccumulatorAreDisplayed = true
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                description += " " + symbol + " "
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            case .Clear:
                clear()

            }
        }
    }
    
    private func clear(){
        accumulator = 0.0
        description = ""
        pending = nil
        internalProgram.removeAll()
        contentsOfAccumulatorAreDisplayed = true
    }
    
    private func executePendingBinaryOperation()
    {
        if pending != nil{
            if !contentsOfAccumulatorAreDisplayed{
                description += String(accumulator)
                contentsOfAccumulatorAreDisplayed = true
            }
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        } else if !contentsOfAccumulatorAreDisplayed{
            description = String(accumulator)
            //contentsOfAccumulatorAreDisplayed = true
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo
    {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get{
            return internalProgram
        }
        set{
            clear()
            if let arrayOfOps = newValue as? [AnyObject]{
                for op in arrayOfOps{
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operation = op as? String {
                        performOperation(operation)
                    }
                }
            }
        }
    }
    
    
    var result: Double{
        get{
            return accumulator
        }
    }
}