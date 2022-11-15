//
//  GameBoardModel.swift
//  nftApp
//
//  Created by Adam Reed on 2/17/22.
//

import Foundation
import GameKit
import UIKit

class BoardModel: ObservableObject {
    @Published var board: GKLeaderboard?
    @Published var localPlayerScore: GKLeaderboard.Entry?
    @Published var topScores: [GKLeaderboard.Entry]?
    let localPlayer = GKLocalPlayer.local
    
    func authenticateUser() {
        localPlayer.authenticateHandler = { vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            // Authenticate local user
            GKAccessPoint.shared.isActive = self.localPlayer.isAuthenticated
            self.load()
        }
    }
    
    func load() {
        print("Board is: \(board)")
        if nil == board {
            GKLeaderboard.loadLeaderboards(IDs: ["cryptoStandTopScoreLeaderBoard"]) { [weak self] (boards, error) in
                self?.board = boards?.first
                self?.updateScores()
            }
        } else {
            self.updateScores()
        }
    }
    
    func addScoreToLeaderBoard(score: Double) {
        print("submit score \(Int(score))")
        
        GKLeaderboard.submitScore(Int(score), context: 0, player: GKLocalPlayer.local, leaderboardIDs: ["cryptoStandTopScoreLeaderBoard"]) { error in
            print("error \(error)")
        }
        load()
        
    }
    
    func updateScores() {
        board?.loadEntries(for: .global, timeScope: .allTime, range: NSRange(location: 1, length: 10),
            completionHandler: { [weak self] (local, entries, count, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error updating scores: \(error)")
                }
                self?.localPlayerScore = local
                self?.topScores = entries
            }
        })
    }
}
