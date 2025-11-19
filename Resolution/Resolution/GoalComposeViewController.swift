//
//  GoalComposeViewController.swift
//  Resolution
//
//  Created by June Eguilos on 11/19/25.
//

import UIKit

class GoalComposeViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionField: UITextView!
    
    var goalToEdit: Goal?
    
    var onComposeGoal: ((Goal) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        if let goal = goalToEdit{
            titleField.text = goal.title
            descriptionField.text = goal.description
            datePicker.date = goal.dateCreated
            
            self.title = "Edit Goal"
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func didTapDonebutton(_ sender: Any) {
        guard let title = titleField.text,
              !title.isEmpty else {
            return
        }
        
        var goal: Goal!
        
        if let editGoal = goalToEdit{
            // Create an updated goal with the same ID and properties
            goal = Goal(
                id: editGoal.id,
                title: title,
                description: descriptionField.text,
                dateCreated: datePicker.date,
                isComplete: editGoal.isComplete,
                completedDate: editGoal.completedDate,
                createdDate: editGoal.createdDate
            )
        } else {
            goal = Goal(
                title: title,
                description: descriptionField.text,
                dateCreated: datePicker.date
            )
        }
        
        onComposeGoal?(goal)
        
        dismiss(animated: true)
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

