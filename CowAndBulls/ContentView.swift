//
//  ContentView.swift
//  CowAndBulls
//
//  Created by Akshat Gandhi on 03/01/25.
//

import SwiftUI

struct ContentView: View {

    @AppStorage("maximumGuesses") var maximumGuesses = 100
    @AppStorage("showGuessCount") var showGuessCount = false
    @AppStorage("answerLength") var answerLength = 4
    @AppStorage("enableHardMode") var enableHardMode = false
    
    @State private var guess = ""
    @State private var guesses: [String] = []
    @State private var answer = ""
    @State private var isGameOver = false
    @State private var isDuplicate = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TextField("Enter the Guesss.", text: $guess)
                    .onSubmit(submitGuess)
                Button("Go", action: submitGuess)
            }
            .padding()
            List(guesses, id:\.self) { guess in
                HStack {
                    Text(guess)
                    Spacer()
                    Text(result(for: guess))
                }
                
            }
            .listStyle(.sidebar)
            if showGuessCount {
                Text("Guesses: \(guesses.count)/\(maximumGuesses)")
                    .padding()
            }
        }
        .frame(width: 250)
        .frame(minHeight: 300, maxHeight: .infinity)
        .onAppear(perform: startNewGame)
        .onChange(of: answerLength, startNewGame)
        .alert("You win!", isPresented: $isGameOver) {
            Button("OK", action: startNewGame)
        } message: {
            let str = guesses.count < 10 ? "Very sharp!" : guesses.count > 10 && guesses.count < 20 ? "Awesome!" : "Nice Play!"
            Text("\(str) Congratulations! Click OK to play again.")
        }
        .alert("Duplicate Guess", isPresented: $isDuplicate, actions: {
            Text("You guess duplicate value!!")
        })
        .navigationTitle("Cows and Bulls")
        .touchBar {
            HStack {
                Text("Guesses: \(guesses.count)")
                    .touchBarItemPrincipal()
                Spacer(minLength: 200)
            }
        }
    }
    
    func submitGuess() {
        guard !guesses.contains(guess) else {
            isDuplicate = true
            guess = ""
            return }
        guard Set(guess).count == answerLength else { return }
        guard guess.count == answerLength else { return }
        
        let badCharacters = CharacterSet(charactersIn: "0123456789").inverted
        guard guess.rangeOfCharacter(from: badCharacters) == nil else { return }
        
        guesses.insert(guess, at: 0)
        if result(for: guess).contains("\(answerLength)b") {
            isGameOver = true
        }
        guess = ""
    }
    
    func result(for guess: String) -> String {
        var bulls = 0
        var cows = 0
        
        let guessLetters = Array(guess)
        let answerLetters = Array(answer)
        
        for (index, letter) in guessLetters.enumerated() {
            if letter == answerLetters[index] {
                bulls += 1
            } else if answerLetters.contains(letter) {
                cows += 1
            }
        }
        
        return "\(bulls)b \(cows)c"
    }
    
    func startNewGame() {
        guard answerLength >= 3 && answerLength <= 8 else { return }
        guess = ""
        guesses.removeAll()
        answer = ""
        
        let numbers = (0...9).shuffled()
        
        for i in 0..<answerLength {
            answer.append(String(numbers[i]))
        }
    }
}

#Preview {
    ContentView()
}
