//
//  GoalListViewController.swift
//  Resolution
//
//  Created by June Eguilos on 11/19/25.
//

import UIKit

// MARK: - Quote Model
struct Quote: Codable {
    let text: String
    let author: String
    
    enum CodingKeys: String, CodingKey {
        case text = "q"
        case author = "a"
    }
}

class GoalListViewController: UIViewController{

    
    @IBOutlet weak var motivationalQuotes: UILabel!
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var emptyStateLabel: UIButton!
    
    var goals = [Goal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Fetch a motivational quote when the view loads
        fetchRandomQuote()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        refreshGoals()
        // Fetch a new quote each time the view appears
        fetchRandomQuote()
    }
    
    
    //move to the create new goal segue
    @IBAction func didTapNewGoalButton(_ sender: Any) {
        performSegue(withIdentifier: "newGoalSegue", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newGoalSegue" {
            if let composeNavController = segue.destination as? UINavigationController,
               let composeViewController = composeNavController.topViewController as? GoalComposeViewController{
                composeViewController.goalToEdit = sender as? Goal
                
                composeViewController.onComposeGoal = { [weak self] goal in
                    goal.save()
                    self?.refreshGoals()
                }
                
            }
        }
    }
    
    private func refreshGoals() {

        var goals = Goal.getGoals()

        goals.sort { lhs, rhs in
            if lhs.isComplete && rhs.isComplete {

                return lhs.completedDate! < rhs.completedDate!
            } else if !lhs.isComplete && !rhs.isComplete {

                return lhs.dateCreated < rhs.dateCreated
            } else {

                return !lhs.isComplete && rhs.isComplete
            }
        }

        self.goals = goals
        //emptyStateLabel.isHidden = !goals.isEmpty
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    // MARK: - Quote Fetching
    private func fetchRandomQuote() {
        guard let url = URL(string: "https://zenquotes.io/api/random") else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching quote: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    self?.motivationalQuotes.text = "Stay motivated and achieve your goals!"
                }
                return
            }
            
            do {
                let quotes = try JSONDecoder().decode([Quote].self, from: data)
                if let quote = quotes.first {
                    DispatchQueue.main.async {
                        self?.motivationalQuotes.text = "\"\(quote.text)\" - \(quote.author)"
                        self?.motivationalQuotes.numberOfLines = 0 // Allow multiple lines
                    }
                }
            } catch {
                print("Error decoding quote: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.motivationalQuotes.text = "Stay motivated and achieve your goals!"
                }
            }
        }.resume()
    }
}

extension GoalListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath) as! GoalCell
        
        let goal = goals[indexPath.row]
        
        cell.configure(with: goal, onCompleteButtonTapped: { [weak self] in
            // Toggle the completion status directly in the array
            self?.goals[indexPath.row].isComplete.toggle()
            self?.goals[indexPath.row].save()
            self?.refreshGoals()
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            goals.remove(at: indexPath.row)
            
            Goal.save(goals)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}


extension GoalListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1.
        tableView.deselectRow(at: indexPath, animated: false)
        // 2.
        let selectedTask = goals[indexPath.row]
        // 3.
        performSegue(withIdentifier: "newGoalSegue", sender: selectedTask)
    }
}
