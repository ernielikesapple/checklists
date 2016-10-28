//
//  Checklistitem.swift
//  CheckLists
//
//  Created by ernie on 20/10/2016.
//  Copyright © 2016 ernie. All rights reserved.
//

import Foundation

class Checklistitem :NSObject,NSCoding{
  
    var text = ""
    var checked = false
    //when create a new object in ChecklistViewController,like  let item = Checklistitem(),then this init method get called
    //when user press the + button ,goes to the page additem,then click done,this init will get called
    override init() {
        super.init()
    }
    
    //two necessary delegate methods from NSCoding protocol
    //implement the delegate methods from the NSCoding
    //encode the object inside the array ,those concrete objects
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeBool(checked, forKey: "Checked")
    }
    //restore ChecklistItems that were saved to disk
    required init?(coder aDecoder: NSCoder) {
        //required means this object is from a superClass,question mark means this init can fail,e.g 1st time when the app open,no data file yet
        //decode array objects from file(unfroze)
        //when the unarchiver does the thing like 
        //let item = ChecklistItem(coder: someDecoderObject)     this allocates memory for the new ChecklistItem
        
        text = aDecoder.decodeObjectForKey("Text") as! String
        checked = aDecoder.decodeBoolForKey("Checked")
        super.init()
    }
    
    
    
    




    
    
    
    
    
    



    func toggleChecked(){
        checked = !checked
    }


}