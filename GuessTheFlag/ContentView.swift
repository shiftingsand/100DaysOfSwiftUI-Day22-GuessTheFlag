//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Chris Wu on 4/22/20.
//  Copyright © 2020 Chris Wu. All rights reserved.
//

import SwiftUI

// Day 24 - challenge 3.
// Go back to project 2 and create a FlagImage() view that renders one flag image using the specific set of modifiers we had.
struct SomeFlag : View {
    let flagImageName : String
    
    var body : some View {
        Image(flagImageName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var userScore = 0
    var message = ""
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of").foregroundColor(.white)
                    Text("\(countries[correctAnswer])")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                ForEach (0..<3) { number in
                    Button(action: {
                        self.evaluateFlag(myAnswer: number)
                    }) {
                        SomeFlag(flagImageName: self.countries[number])
//                        Image(self.countries[number]).renderingMode(.original)
//                            .clipShape(Capsule())
//                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
//                            .shadow(color: .black, radius: 2)
                    }
                }
                // goal #2 to show score
                Text("Your score is \(userScore)")
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text(scoreMessage), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }
    
    
    /// checks the answer
    /// - Parameter myAnswer: the index of the array the user selected
    func evaluateFlag(myAnswer : Int) {
        // goal #1 to modify score
        if myAnswer == correctAnswer {
            scoreTitle = "You got it right"
            userScore += 1
            scoreMessage = ""
        } else {
            scoreTitle = "You got it wrong!"
            userScore -= 1
            // goal #3 show what they actually selected
            scoreMessage = "That's the flag for \(countries[myAnswer])."
        }

        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
