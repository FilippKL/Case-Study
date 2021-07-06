//
//  detailedViewController.swift
//  Project_Mobile
//
//  Created by Filipp Krupnov on 30/6/21.
//

import UIKit
import WebKit

class detailedViewController: UIViewController {
    var userN: String = ""
    var words1 : String = ""
    
    @IBOutlet weak var userAvatar: WKWebView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var stars: UILabel!
    @IBOutlet weak var issuesCount: UILabel!
    @IBAction func buttonUpdateInfo(_ sender: Any) {
        updateLbl()
    }
    
    override func viewDidLoad() {
        requestData()
        userName?.text = words1
        print("\(userN) username" )
        let avatarURL = URL(string: "https://avatars.githubusercontent.com/\(words1)")
        userAvatar.load(URLRequest(url: avatarURL!))
    }
    override func viewDidAppear(_ animated: Bool) {
        updateLbl()
    }
    
    var sumStar : Int = 0
    var sumIssues: Int = 0
    
    func requestData() {
        let urlComponents = URLComponents(string: "https://api.github.com/users/\(words1)/repos")
        let wordsRequest = URLRequest(url: urlComponents!.url!)
    
        let sharedSession = URLSession.shared
        
        let wordTask = sharedSession.dataTask(with: wordsRequest) { [self] (data, response, error) in
            if let data = data,
               let response = response as? HTTPURLResponse,
               (200..<300) ~= response.statusCode,
               error == nil,
               let requestedWord = try? JSONDecoder().decode([Request].self, from: data){
//                print(requestedWord)
                sumStar = requestedWord.map({ $0.stargazers_count }).reduce(0, +)
                sumIssues = requestedWord.map({ $0.open_issues_count }).reduce(0, +)
                    }
        }
        wordTask.resume()
    }
    func updateLbl() {
        stars.text = "\(sumStar)"
        issuesCount.text = "\(sumIssues)"
    }
}
