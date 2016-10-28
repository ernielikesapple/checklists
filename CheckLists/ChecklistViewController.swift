//
//  ViewController.swift
//  CheckLists
//
//  Created by ernie on 16/10/2016.
//  Copyright © 2016 ernie. All rights reserved.
//
import UIKit
class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate
//make delegates in five easy step, Step 4: make object A(ChecklistViewController conform to the delegate protocol.It should put the name of the protocol in its class line ,        And implement the methods from the protocol)
{
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//delegate method for ItemDetailViewController
    //make ChecklistViewController a delegate for itemDetailViewController,add delegate method based on the protocol in itemDetailViewController's declaration
    
    //make delegates in five easy step, Step 4: make object A(ChecklistViewController conform to the delegate protocol.It should put the name of the protocol in its class line ,        And implement the methods from the protocol)
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: Checklistitem) {
        let newRowIndex = items.count
        items.append(item)   //add data to the Data Model layer
        let indexPath = NSIndexPath(forRow: newRowIndex,inSection: 0)
        let indexPaths = [indexPath]   //tableView.insertRowsAtIndexPaths only takes array that's why  it has to be in an array
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)    //add data to the View layer
        dismissViewControllerAnimated(true, completion: nil)
        self.saveChecklistItems() //data persistence
    }
    
    func itemDetailViewController(controller:ItemDetailViewController,didFinishEditingItem item:Checklistitem){
        if let index = items.indexOf(item){       //when user indexOf,we have to make item:ChecklistItem a NSObject,since the row index equal to array item ,so we can use array index to ensure which row this item should locate
            let indexPath = NSIndexPath(forRow: index,inSection: 0) //create the indexPath for the new Edited item based on index
            if let cell = tableView.cellForRowAtIndexPath(indexPath){
            configureTextForCell(cell, withChecklistItem: item)
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
        self.saveChecklistItems() //data persistence
    }
    
    //make delegates in five easy step, Step 5 ,tell object B(ItemDetailViewController) that object A(ChecklistViewController) is  now its delegate
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItem"{
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
        }else if segue.identifier == "EditItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            if let indexPath  = tableView.indexPathForCell(sender as! UITableViewCell){// tableView.indexPathForCell(sender as! UITableViewCell) this method simply takes the  sender's IndexPath object ,give it to indexPath variable
                controller.itemToEdit = items[indexPath.row] //the var itemToEdit is from the ItemDetailViewController.swift,since here,the controller var refer to this controller,so we can use it's variable ,initialize the row in the editItem screen with the sender row on ChecklistView
            }
          }
        }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//work on dataModel n view both sides ,to make the view show data
    var  items : [Checklistitem]
    required init?(coder aDecoder: NSCoder) {
        items = [Checklistitem]()
        //this instantiates the array ,now items contains a valid array object
        //but the array has no ChecklistItem objects inside it yet
        super.init(coder: aDecoder)
        loadChecklistItems()
        //this method get called ,when user ever used this app and saved new ChecklistItems inside the app,when there is a dataFile
        print("Documents folder is \( documentsDirectory() )")
        print("Data file path is \( dataFilePath() )")
    }
    
    //delete items
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
       
        items.removeAtIndex(indexPath.row)//remove from data model
        
        let indexPaths = [indexPath]   //remove from the view
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
        self.saveChecklistItems() //data persistence
    }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//set up the basic tableView
    //total row numbers in the section 0
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    //send cellForRowAtIndexPath message to uitableview data source,so that data can be provided
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistsItem",forIndexPath: indexPath)
        //this line of code gets a copy of the prototype cell - either a new one or a recycled one
        let item = items[indexPath.row]
        configureTextForCell(cell, withChecklistItem: item)
        configureCheckmarkForCell(cell, withChecklistItem: item)
        return cell
    }
    //let the uitableview delegate handle the situation when specified row has been selected
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
            let item = items[indexPath.row]
            item.toggleChecked() //data model changed
            configureCheckmarkForCell(cell,withChecklistItem: item)
            self.saveChecklistItems()//data persistence
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    
    func configureTextForCell(cell:UITableViewCell,withChecklistItem item:Checklistitem){
        let label = cell.viewWithTag(1000) as! UILabel
        //tag is used for referring the label,compared to @IBOutlet variable,cause this label in a prototype cell,so its not directly in the whole ChecklistViewController,so its better use tag,rather than IBOutlet
        label.text = item.text
    }
    func configureCheckmarkForCell(cell:UITableViewCell,withChecklistItem item: Checklistitem){
        
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "✔︎"
        }else{
            label.text = ""
        }
    }
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//data persistence part
    func documentsDirectory() -> String{ //save the file to file system,for now all the data lives in the memory ,so use data persistence technique to make the data lives longer
        //Creates a list of directory search paths.
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    func dataFilePath() -> String{  //construct the full path to the file that will store the checklist items,file name is "Checklists.plist"
        return(documentsDirectory() as NSString).stringByAppendingPathComponent("Checklists.plist")
    }
    
    func saveChecklistItems(){ //encode the ChecklistItem objects into a block of binary code
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData:data) //encode objects (and scalar values) into an architecture-independent format that can be stored in a file.
        archiver.encodeObject(items, forKey: "ChecklistItems")
        archiver.finishEncoding()  //nstructs the receiver to construct the final data stream. No more values can be encoded after this method is called. You must call this method when finished.
        data.writeToFile(dataFilePath(), atomically: true)
    }
    func loadChecklistItems(){ //decode a block of binary code back to ChecklistItemObjects
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path)//make sure there is a path,else it will be the first time user use this app
        {
            if let data = NSData(contentsOfFile:path)//put data into this NSData Object
            {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData :data)                //intantiate one NSKeyedUnarchiver
                items = unarchiver.decodeObjectForKey("ChecklistItems") as! [Checklistitem]   //use NSKeyedUnarchiver decode the ChecklistItems dataFile,here its the required init?(coder aDecoder: NSCoder) method in the Checklistitem.swift get called
                unarchiver.finishDecoding()
            }
        }
    }
    
    
    

}

