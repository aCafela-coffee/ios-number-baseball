//
//  NumberBaseball - main.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 
import Foundation

var randomNumbers: [Int] = []
var remainingChance: Int = 9
let inputNumberCount: Int = 3
let inputNumberRange: ClosedRange<Int> = 1...9

func generateRandomNumbers(count: Int) -> [Int] {
    var numbers: Set<Int> = []
    
    while numbers.count < count {
        let randomNumber: Int = Int.random(in: inputNumberRange)
        
        numbers.insert(randomNumber)
    }
    
    return Array(numbers)
}


/// 게임 점수를 판정하는 함수
/// - Parameter inputNumbers: 유저가 입력한 숫자의 배열
/// - Returns: 반환 타입은 튜플입니다.
func checkPlayResult(for inputNumbers: [Int]) -> (strikeCount: Int, ballCount: Int) {
    var strikeCount: Int = 0
    var ballCount: Int = 0
    
    for index in 0..<inputNumberCount {
        let isStrike: Bool = randomNumbers[index] == inputNumbers[index]
        var isBall: Bool {
            randomNumbers.contains(inputNumbers[index])
        }
        
        if isStrike {
            strikeCount += 1
        } else if isBall {
            ballCount += 1
        }
    }
    
    return (strikeCount, ballCount)
}

func isNumber(numbers: [String]) -> [Int]? {
    var result: [Int] = []

    for number in numbers {
        guard let number = Int(number) else {
            return nil
        }

        guard inputNumberRange ~= number else {
            return nil
        }

        result.append(number)
    }
    return result
}

func readUserInput() -> [Int]? {
    print("임의의 수 : ", terminator: "")
    
    guard let input: String = readLine() else {
        print("입력이 잘못되었습니다")
        fatalError()
    }
    
    guard let numbers: [Int] = numbers(from: input) else {
        print("입력이 잘못되었습니다.")
        return nil
    }

    return numbers
}

func numbers(from input: String) -> [Int]? {
    let separatedNumbers: [String] = input.split(separator: " ").map { String($0) }
    
    guard let numbers: [Int] = isNumber(numbers: separatedNumbers),
            numbers.count == inputNumberCount,
            Set(numbers).count == inputNumberCount else {
        return nil
    }
    
    return numbers
}

// MARK: - Game playing
func startGame() {
    if shouldStart() == false {
        return
    }
    
    randomNumbers = generateRandomNumbers(count: inputNumberCount)
    
    while remainingChance > 0 {
        print("숫자 3개를 띄어쓰기로 구분하여 입력해주세요.")
        print("중복 숫자는 허용하지 않습니다.")
        
        guard let playNumbers: [Int] = readUserInput() else {
            continue
        }
        let playResult = checkPlayResult(for: playNumbers)
        
        if playResult.strikeCount == inputNumberCount {
            break
        }
        
        remainingChance -= 1
        printPlayResult(strikeCount: playResult.strikeCount, ballCount: playResult.ballCount)
    }
    
    printWinner()
}

func printMenu() {
    print("1. 게임시작")
    print("2. 게임종료")
    print("원하는 기능을 선택해주세요 : ", terminator: "")
}

func shouldStart() -> Bool {
    while true {
        printMenu()
        
        guard let input: String = readLine() else {
            print("입력이 잘못되었습니다.")
            fatalError()
        }
        
        if input == "1" {
            return true
        } else if input == "2" {
            return false
        } else {
            print("입력이 잘못되었습니다.")
            continue
        }
    }
}

func printPlayResult(strikeCount: Int, ballCount: Int) {
    print("\(strikeCount) 스트라이크, \(ballCount) 볼")
    print("남은 기회 : \(remainingChance)")
}

func printWinner() {
    if remainingChance == 0 {
        print("컴퓨터 승리...")
    } else {
        print("사용자 승리...")
    }
}


// MARK: - Game start
startGame()
