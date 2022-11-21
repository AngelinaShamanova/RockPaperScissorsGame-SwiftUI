//
//  ContentView.swift
//  RockPaperScissorsGame
//
//  Created by Ангелина Шаманова on 21.11.22..
//

import SwiftUI

struct ContentView: View {
    @State private var timeRemaining = 0
    
    @State private var computerMove = 0
    @State private var userMove: Int?
    
    @State private var score = 0
    
    @State private var showAlert = false
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private let moves = ["rock", "paper", "scissors"]
    private let movesIndexes = [0, 1, 2]
    
    private var buttonText: String {
        return timeRemaining <= 3 && timeRemaining != 0 ? "\(timeRemaining)" : "Start"
    }
    
    private var userMoveText: String {
        return userMove != nil ? "Your move: \(moves[userMove ?? 0])" : "Your turn"
    }
    
    var body: some View {
        VStack {
            Form {
                Section {
                    Image(moves[computerMove])
                        .resizable()
                        .frame(width: 100, height: 100)
                        .onReceive(timer) { _ in
                            if timeRemaining == 1 {
                                computerMove = movesIndexes.shuffled().randomElement() ?? 0
                            }
                        }
                } header: {
                    Text("Computer move: \(moves[computerMove])")
                }
                Section {
                    HStack {
                        ForEach(moves.indices, id: \.self) { index in
                            Button {
                                
                            } label: {
                                VStack {
                                    Image(moves[index])
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                }
                            }
                            .onTapGesture {
                                if timeRemaining > 0 {
                                    userMove = index
                                }
                            }
                        }
                    }
                } header: {
                    Text(userMoveText)
                }
            }
            Text("Your score: \(score)".uppercased())
                .frame(width: UIScreen.main.bounds.width - 30,
                       height: 20, alignment: .leading)
            Button {
                startGame()
            } label: {
                Text(buttonText)
                    .foregroundColor(.white)
            }
            .frame(width: UIScreen.main.bounds.width - 60,
                   height: 48)
            .background(.indigo)
            .cornerRadius(8)
            .padding()
            .onReceive(timer) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else if timeRemaining == 0 {
                    checkUserWin()
                }
            }
        }
        .alert("Game over", isPresented: $showAlert) {
            Button("Start again", role: .cancel) {
                resetScore()
                startGame()
            }
            Button("Cancel", role: .destructive, action: resetScore)
        } message: {
            Text("Your score is \(score)")
        }
        .onAppear {
            UITableView.appearance().backgroundColor = .clear
        }
    }
    
    func startGame() {
        timeRemaining = 4
    }
    
    func checkUserWin() {
        if timeRemaining == 0 {
            switch computerMove {
            case 0:
                if userMove == 1 {
                    score += 1
                } else if userMove == 2 {
                    if score > 0 {
                        score -= 1
                    }
                }
            case 1:
                if userMove == 0 {
                    if score > 0 {
                        score -= 1
                    }
                } else if userMove == 2 {
                    score += 1
                }
            default:
                if userMove == 0 {
                    score += 1
                } else if userMove == 1 {
                    if score > 0 {
                        score -= 1
                    }
                }
            }
        }
        userMove  = nil
        checkForScoreLimit()
    }
    
    func checkForScoreLimit() {
        if score == 5 {
            showAlert = true
        }
    }
    
    func resetScore() {
        score = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
