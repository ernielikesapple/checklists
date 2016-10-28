//
//  ItemDetailViewController.swift
//  CheckLists
//
//  Created by ernie on 25/10/2016.
//  Copyright © 2016 ernie. All rights reserved.
//

import Foundation
import UIKit
//make delegates in five easy step, Step 1 :define a delegate protocol for object B(ItemDetailViewController)
protocol ItemDetailViewControllerDelegate : class {
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController)
    func itemDetailViewController(controller:ItemDetailViewController,didFinishAddingItem item: Checklistitem)
    func itemDetailViewController(controller:ItemDetailViewController,didFinishEditingItem item:Checklistitem)
    
}


class ItemDetailViewController: UITableViewController ,UITextViewDelegate{
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//reuse VC to second function
    var itemToEdit: Checklistitem?//when in the adding item view controller mode, this itemToEdit must be nil ,that's why it set to optional
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item =  itemToEdit {
            self.title = "Edit Item"
            textField.text = item.text
            doneBarButton.enabled = true
        }
    }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //functions about those buttons on the pages
    //use delegate to transfer data back to ChecklistViewController
    //make delegates in five easy step, Step 2 : give object B(ItemDetailViewController) an optional delegate variable,this variable should be weak
    weak var delegate : ItemDetailViewControllerDelegate?
    
    @IBAction func cancel(){
        
        //make delegates in five easy step, Step 3 : make object B(ItemDetailViewController) send messages to its delegate A(ChecklistViewController) when something interesting ochappens,such as the user pressing the Cancel or Done buttons,or when it needs a piece of information .You write delegate?.methodName(self...)
        delegate?.itemDetailViewControllerDidCancel(self)
       
    }
    
    @IBAction func done(){
       if let item = itemToEdit {  //if the "item" exists,then this done button is for the add editing  screen
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishEditingItem: item)
    }
        else {  //for the add item screen
        let item = Checklistitem()
        item.text = textField.text!
        item.checked = false
        //make delegates in five easy step, Step 3 : make object B(ItemDetailViewController) send messages to its delegate A(ChecklistViewController) when something interesting happens,such as the user pressing the Cancel or Done buttons,or when it needs a piece of information .You write delegate?.methodName(self...)

        delegate?.itemDetailViewController(self, didFinishAddingItem: item)
        }
    }
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//polishing the detail,enchance User eXperience
    //make sure the textField is unselectable
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    //make the keyboard appear rigth away when this page shows 
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    //make sure the doneBarButton is disabled when there is no text in the textField,
    func textField(textView: UITextView, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText :NSString = textField.text!
        let newText :NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        doneBarButton.enabled = (newText.length > 0)
        return true
    }

}