//
//  GoalListViewController.swift
//  Resolution
//
//  Created by June Eguilos on 11/19/25.
//

import UIKit
 
class GoalListViewController: UIViewController{

    
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var emptyStateLabel: UIButton!
    
    var goals = [Goal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        refreshGoals()
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
