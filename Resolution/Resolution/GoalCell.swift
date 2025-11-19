//
//  GoalCell.swift
//  Resolution
//
//  Created by June Eguilos on 11/19/25.
//

import UIKit

class GoalCell: UITableViewCell {


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    var onCompleteButtonTapped: (() -> Void)?
    
    var goal: Goal!
    
    @IBAction func didTapCompleteButton(_ sender: Any) {
        onCompleteButtonTapped?()
    }
    
    func configure(with goal: Goal, onCompleteButtonTapped: (() -> Void)?){
        self.goal = goal
        self.onCompleteButtonTapped = onCompleteButtonTapped
        update(with: goal)
    }
    
    private func update(with goal: Goal){
        titleLabel.text = goal.title
        descriptionLabel.text = goal.description
        //descriptionLabel.isHidden = goal.description = "" || goal.description == nil
        
        titleLabel.textColor = goal.isComplete ? .secondaryLabel: .label
        
        completeButton.isSelected = goal.isComplete
        
        completeButton.tintColor = goal.isComplete ? .systemBlue: .tertiaryLabel
                
    }

}
