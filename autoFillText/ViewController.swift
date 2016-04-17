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

let stackHeightShow:CGFloat = 150.0
let stackHeighthide:CGFloat = 0

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{
    
    //MARK: - ----individual properties----
    //MARK: -
    let recordData = RecordData()

    @IBOutlet weak var complectedTableView: UITableView!
    
    @IBOutlet weak var testTextField: UITextField!
    
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    var showList: Bool = false
    
    var dataSource: [String] = []
    var resultData: [String] = []
    //MARK: - ----Apple Inc. func----
    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showList = false
        
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
        UIView.animateWithDuration(0.3){

            self.stackViewHeight.constant = stackHeighthide
            self.complectedTableView.hidden = true

        }
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
        if currentString.isEmpty{
            showList = false
            UIView.animateWithDuration(0.3){
                self.complectedTableView.hidden = !self.showList
                self.stackViewHeight.constant = stackHeighthide
            }
        }else{
            complectedTableView.hidden = true
            let myMatch = UserNameMatch(array: dataSource, string: currentString)
            resultData = myMatch.sl_matchlist()
            if resultData.count > 0{
                print(resultData)
                showList = true
            }else{
                showList = false
            }
            
            UIView.animateWithDuration(0.3){
                self.complectedTableView.reloadData()
                self.complectedTableView.hidden = !self.showList
                if self.showList{
                    self.stackViewHeight.constant = stackHeightShow
                }else{
                    self.stackViewHeight.constant = stackHeighthide

                }
            }
        }

    }
    
    func getRecordData(){
        recordData.dataRead()
        dataSource = recordData.toReadArray
    }

    
    func loadUI(){
        
        testTextField.delegate = self
        testTextField.addTarget(self, action: #selector(ViewController.didChange(_:)), forControlEvents: .EditingChanged)
        
        complectedTableView.dataSource = self
        complectedTableView.delegate = self
        complectedTableView.tableFooterView = UIView.init()
        complectedTableView.layer.borderWidth = 0.5
        complectedTableView.layer.borderColor = UIColor.blackColor().CGColor
        
        self.stackViewHeight.constant = stackHeighthide
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
}