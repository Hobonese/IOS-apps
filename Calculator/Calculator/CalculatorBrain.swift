//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Raymond Xia on 10/21/17.
//  Copyright © 2017 Raymond Xia. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    
    private enum Operation {
        case constant(Double)
        case unaryOp((Double) -> Double)
        case binaryOp((Double, Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOp(sqrt),
        "cos" : Operation.unaryOp(cos),
        "±" : Operation.unaryOp({ -$0 } ),
        "x" : Operation.binaryOp({ $0 * $1}),
        "÷" : Operation.binaryOp({ $0 / $1}),
        "-" : Operation.binaryOp({ $0 - $1}),
        "+" : Operation.binaryOp({ $0 + $1}),
        "=" : Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOp(let function) :
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOp(let function) :
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals :
                performPendingBinaryOperation()
            }
        }
    }
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result : Double? {
        get {
            return accumulator
        }
    }
}
