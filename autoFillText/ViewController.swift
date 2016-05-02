//
//  ViewController.swift
//  autoFillText
//
//  Created by Serx on 16/4/13.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import UIKit
import Foundation
import WebKit


class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{
    
    //MARK: - ----individual properties----
    //MARK: -
    let recordData = RecordData()

    @IBOutlet weak var complectedTableView: UITableView!
    @IBOutlet weak var testTextField: UITextField!
    
    @IBOutlet weak var secondTextFileToFirst: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var showList: Bool = false
    
    var dataSource: [String] = []
    var resultData: [String] = []
    
    
    //MARK: - ----Apple Inc. func----
    //MARK: -
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRecordData()
        loadUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        self.testTextField.text = cell?.textLabel?.text
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.complectedTableView.hidden = true
        hideSecondTextFeild()
    }
    
    //tableview datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = resultData[indexPath.row]
        return cell
    }
    
    
    
    //MARK: - ----individual func----
    //MARK: -
    
    
    
    func didChange(textField: UITextField){
        resultData = []
        print(textField.text)
        
        let currentString = textField.text!
        if currentString.isEmpty {
            showList = false
            self.complectedTableView.hidden = true
            hideSecondTextFeild()
        }
        else {
            complectedTableView.hidden = true
            
            let myMatch = UserNameMatch(array: dataSource, string: currentString)
            
            resultData = myMatch.sl_matchlist()
            if resultData.count > 0 {
                
                print(resultData)
                showList = true
                if resultData.count <= 5 {
                    let lim = HeightForCell * CGFloat(resultData.count)
                    tableViewHeight.constant = lim
                    secondTextFileToFirst.constant = lim
                }
                else{
                    tableViewHeight.constant = HeightForCell * 5.0
                    secondTextFileToFirst.constant = HeightForCell * 5.0
                }
            }
            else {
                showList = false
                hideSecondTextFeild()

            }
            self.complectedTableView.reloadData()
            self.complectedTableView.hidden = !self.showList

        }

    }
    
    func getRecordData(){
        recordData.dataRead()
        dataSource = recordData.toReadArray
    }

    
    func loadUI(){
        tableViewHeight.constant = 0.0
        hideSecondTextFeild()
        
        showList = false
        
        testTextField.delegate = self
        testTextField.addTarget(self, action: #selector(ViewController.didChange(_:)), forControlEvents: .EditingChanged)
        
        complectedTableView.dataSource = self
        complectedTableView.delegate = self
        
        complectedTableView.hidden = !showList
    }
    
    @IBAction func uploadText(sender: UIButton) {
        
        let limStr = self.testTextField.text!
        if !limStr.isEmpty{
            
            dataSource.append(limStr)
            let limMutableArray = NSMutableArray(array: dataSource)
            recordData.toWriteArray = limMutableArray
            recordData.dataWrite()
        }
    }
    
    func hideSecondTextFeild(){
        self.secondTextFileToFirst.constant = rewHeightForSecondToFirst
    }
}

let HeightForCell: CGFloat = 30.0
let rewHeightForSecondToFirst: CGFloat = 8.0