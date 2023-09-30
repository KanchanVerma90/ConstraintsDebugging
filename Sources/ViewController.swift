//
//  ViewController.swift
//  GameOfConstraints
//
//  Created by Kanchan Verma on 10/04/2021.
//

import UIKit

extension  UIViewController: updateViews {
    func constraintChanged(newConstraingt: NSLayoutConstraint) {
        let changedConst = self.view.constraints.filter { (const) -> Bool in
            return const.hashValue ==  newConstraingt.hashValue
        }
        if let changed = changedConst.first {
            self.view.removeConstraint(changed)
        }
        DispatchQueue.main.async {
            self.view.addConstraint(newConstraingt)
            self.view.updateConstraints()
            self.view.layoutIfNeeded()
        }
    }
    

    func createIDLayer<T:UIView>(forView: T) {
        let layer1 = UILabel.init()
        layer1.backgroundColor = .systemTeal
        layer1.text = forView.accessibilityIdentifier
        layer1.translatesAutoresizingMaskIntoConstraints = false
        layer1.textAlignment = .center
        layer1.numberOfLines = 0
        layer1.tag = -10
        self.view.addSubview(layer1)
        forView.layer.borderWidth = 0.5
        forView.layer.borderColor = (UIColor.gray.withAlphaComponent(0.5)).cgColor
        forView.layer.cornerRadius = 4
        layer1.trailingAnchor.constraint(equalTo: forView.leadingAnchor).isActive = true
        layer1.bottomAnchor.constraint(equalTo: forView.topAnchor).isActive = true
        //layer1.widthAnchor.constraint(equalToConstant: 30).isActive = true
        layer1.heightAnchor.constraint(equalToConstant: 25).isActive = true
        forView.bringSubviewToFront(layer1)
    }

    
     func assignAccessibilityIdentifier() {
        for vw in self.view.subviews {
            if vw.tag > -1 {
                vw.accessibilityIdentifier = vw.accessibilityIdentifier ?? "v\(self.view.subviews.firstIndex(of: vw) ?? 0)"
                createIDLayer(forView: vw)
            }
        }
    }
     @objc func getListOfConstraints() {
         let story = UIStoryboard(name: "Main", bundle: Bundle.main)
        let nextVC = story.instantiateViewController(withIdentifier: "listVC") as! ConstraintsList
        nextVC.listData = self.view.constraints.filter({ (lay) -> Bool in
            return !(((lay.firstItem as? UIView)?.accessibilityIdentifier == nil) && ((lay.secondItem as? UIView)?.accessibilityIdentifier == nil) || (lay.firstItem?.tag ?? 0 < 0))
        }) //subviews//
        for vw in self.view.subviews {
            let subViewsConstraints = vw.constraints.filter({ (lay) -> Bool in
                return !(((lay.firstItem as? UIView)?.accessibilityIdentifier == nil) && ((lay.secondItem as? UIView)?.accessibilityIdentifier == nil))
            })
            nextVC.listData.append(contentsOf: subViewsConstraints)
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func createConstriantsListing() {
        var showConstrainsBtn = UIButton.init()
        self.view.addSubview(showConstrainsBtn)
        showConstrainsBtn.frame = CGRect(origin: CGPoint(x: (CGPoint.zero.x + self.view.frame.size.width - 20), y: (CGPoint.zero.y + self.view.frame.size.height - 20)), size: CGSize(width: 35, height: 35))
        showConstrainsBtn.layer.cornerRadius = 35/2
        showConstrainsBtn.backgroundColor = UIColor.tertiarySystemGroupedBackground
        showConstrainsBtn.setBackgroundImage(UIImage.init(systemName: "arrowshape.zigzag.right.fill"), for: UIControl.State.normal)
        showConstrainsBtn.addTarget(self, action: #selector(getListOfConstraints), for: .touchUpInside)
       
    }

}

