//
//  ScoreTableViewController.swift
//  football
//
//  Created by Martin Kostelej on 22/07/2021.
//

import UIKit

class ScoreTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let MAX_SIZE_OF_TABLE = 10
    let SCORE_DATA_KEY = "ScoreData"
    
    struct ScoreData: Codable {
        var date: String
        var score: Int
    }
    
    var scoreArray = [ScoreData]()
    
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreTableView: UITableView!
    
    var reachedScore: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = UserDefaults.standard.value(forKey: SCORE_DATA_KEY) as? Data {
            let array = try? PropertyListDecoder().decode(Array<ScoreData>.self, from: data)
            scoreArray = array ?? [ScoreData]()
        }
        
        changeTableOfScoreAndSave()
        
        scoreTableView.delegate = self
        scoreTableView.dataSource = self
        
        scoreLabel.text = "Dosiahnuté skóre: " + String(reachedScore)
                
        playAgainButton.layer.cornerRadius = 10.0
        applyShadow(button: playAgainButton)
        
    }
    
    func changeTableOfScoreAndSave() {
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        let date = df.string(from: Date())
        
        let newScoreData = ScoreData(date: date, score: reachedScore)
        scoreArray.append(newScoreData)
        
        scoreArray = scoreArray.sorted(by: { $0.score > $1.score})
        if scoreArray.count > MAX_SIZE_OF_TABLE {
            scoreArray.removeLast()
        }
        UserDefaults.standard.set(try? PropertyListEncoder().encode(scoreArray), forKey:SCORE_DATA_KEY)
    }
    
    @IBAction func playAgainButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if isBeingDismissed {
            NotificationCenter.default.post(name: NSNotification.Name("start"), object: nil)
        }
    }
    
    func applyShadow(button: UIButton){
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath) as! ScoreCell
        
        cell.dateLabel.text = scoreArray[indexPath.row].date
        cell.scoreLabel.text = String(scoreArray[indexPath.row].score)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
