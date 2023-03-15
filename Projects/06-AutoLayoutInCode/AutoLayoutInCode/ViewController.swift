//
//  ViewController.swift
//  AutoLayoutInCode
//
//  Created by JC on 28/8/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.backgroundColor = UIColor.red
        label1.text = "THESE"
        label1.sizeToFit()

        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.backgroundColor = UIColor.cyan
        label2.text = "ARE"
        label2.sizeToFit()

        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.backgroundColor = UIColor.yellow
        label3.text = "SOME"
        label3.sizeToFit()

        let label4 = UILabel()
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.backgroundColor = UIColor.green
        label4.text = "AWESOME"
        label4.sizeToFit()

        let label5 = UILabel()
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.backgroundColor = UIColor.orange
        label5.text = "LABELS"
        label5.sizeToFit()

        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
        
        //VISUAL FORMATTING LANGUAGE approach.
//        let viewsDictionary = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]
//
//        for label in viewsDictionary.keys {
//            //NSLayoutConstraint converts Visual Format Language into an array of constraints. H: means adding a horizontal layout and | means the edge of the view controller. The [label\(labelNumber)] is hardcoded because whatever that we put in the brackets are searched in the viewsDictionary, which contains the reference to the UILabel
//            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
//        }
//
//        let metrics = ["labelHeight": 88]
//
//        //- is a space of 10 points. @999 means a priority 999 out of 1000 to satisfy the labelHeight height because, sometimes, the view can't meet the constraints but tries its best by approaching that metric (for example, if the value is 88, it might have a value of 78, for example)
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|", options: [], metrics: metrics, views: viewsDictionary))
        
        //ANCHORS approach. The best one due to the simplicity of the code
        var previousLabel: UILabel?
        let labels = [label1, label2, label3, label4, label5]
        
        //We give the labels the same width as the main view and a height of 88 points
        
        for label in labels {
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            label.heightAnchor.constraint(equalToConstant: 88).isActive = true
            
            //If we have a previousLabel, then make the current label equal to the bottom of the previous label
            if let previous = previousLabel {
                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
                label.heightAnchor.constraint(equalTo: previous.heightAnchor, constant: 10).isActive = true
                if labels.last == label {
                    label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
                }
            } else {
                //safeAreaLayout puts the view just below the top notch of the device
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            }
            
            previousLabel = label
        }
    }



}

