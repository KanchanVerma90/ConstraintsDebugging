//
//  ConstraintsList.swift
//  GameOfConstraints
//
//  Created by Kanchan Verma on 16/04/2021.
//

import UIKit

let attributesList : [String] = ["notAnAttribute","left","right","top","bottom","leading","trailing","width","height","centerX","centerY","lastBaseline","firstBaseline","leftMargin","rightMargin","topMargin","bottomMargin","leadingMargin","trailingMargin","centerXWithinMargins","centerYWithinMargins"]
let story = UIStoryboard(name: "Main", bundle: Bundle.main)

class ConstraintsList: UITableViewController {
    
    var listData: Array<NSLayoutConstraint> = []
    var firstItem: String!
    var seconditem: String!
    var multiplier: String!
    var constant: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "brief")
        cell?.textLabel?.text = ""
        let info = listData[indexPath.row]
        firstItem = "\((info.firstItem as? UIView)?.accessibilityIdentifier ?? "SuperView").\(info.firstAttribute.readableAttr())"
        seconditem = info.secondAttribute.rawValue == 0 ? "" : "\((info.secondItem as? UIView)?.accessibilityIdentifier ?? "SuperView").\(info.secondAttribute.readableAttr())"
        let str = seconditem?.isEmpty ?? false ? "\(firstItem ?? "") \(info.relation.equalityStr()) \(info.constant.description)" : "\(firstItem ?? "") \(info.relation.equalityStr()) \(seconditem ?? "") * \(info.multiplier.description) \(info.constant < 0 ? "-" : "+") \(info.constant.description)"
        cell?.textLabel?.text = "\(str)"
        cell?.textLabel?.numberOfLines = 0
        return cell ?? UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = story.instantiateViewController(withIdentifier: "Details") as! ConstraintsVC
        nextVC.theConstraint = listData[indexPath.row]
        nextVC.updateInitialVW = self.navigationController?.viewControllers.first as? updateViews
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension NSLayoutConstraint.Attribute {
    func readableAttr() -> String {
        if self.rawValue < attributesList.count {
            return attributesList[self.rawValue]
        }else {
            return ""
        }
        
    }
}

extension NSLayoutConstraint.Relation {
    func equalityStr() -> String {
        switch self {
        case .equal:
            return "="
        case .greaterThanOrEqual:
            return ">="
        case.lessThanOrEqual:
            return "=<"
        default:
            return "="
        }
        
    }
}
