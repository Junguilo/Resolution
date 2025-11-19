//
//  Goal.swift
//  Resolution
//
//  Created by June Eguilos on 11/19/25.
//

import UIKit

//goal model
struct Goal: Codable, Equatable{
    var title: String
    var description: String?
    var dateCreated: Date
    
    init(title: String, description: String, dateCreated: Date = Date()){
        self.title = title
        self.description = description
        self.dateCreated = dateCreated
    }
    
    // Add a custom init for editing existing goals
    init(id: String, title: String, description: String, dateCreated: Date, isComplete: Bool = false, completedDate: Date? = nil, createdDate: Date = Date()) {
        self.title = title
        self.description = description
        self.dateCreated = dateCreated
        self.id = id
        self.isComplete = isComplete
        self.completedDate = completedDate
        self.createdDate = createdDate
    }
    
    var isComplete: Bool = false {
        didSet{
            if isComplete{
                completedDate = Date()
            } else {
                completedDate = nil
            }
        }
    }
    
    private(set) var completedDate: Date?
    private(set) var createdDate: Date = Date()
    private(set) var id: String = UUID().uuidString
}

extension Goal{
    static var savedGoalsKey: String{
        return "savedGoals"
    }
    
    static func save(_ goals: [Goal]){
        let defaults = UserDefaults.standard

        let encodedData = try! JSONEncoder().encode(goals)
        defaults.set(encodedData, forKey: savedGoalsKey)
    }


    static func getGoals() -> [Goal] {
        let defaults = UserDefaults.standard
        
        if let data = defaults.data(forKey: savedGoalsKey){
            let decodedGoals = try! JSONDecoder().decode([Goal].self, from: data)
            
            return decodedGoals
        } else {
            return []
        }        
    }


    func save() {

        // TODO: Save the current task
        var goals = Goal.getGoals()
        
        if let index = goals.firstIndex(where: { $0.id == self.id }){
            goals.remove(at: index)
            goals.insert(self, at: index)
        } else {
            goals.append(self)
        }
        
        Goal.save(goals)
    }
    
}
