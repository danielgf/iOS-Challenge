//
//  MasterViewController.swift
//  iOS Challenge
//
//  Created by Daniel Griso Filho on 6/11/15.
//  Copyright (c) 2015 iOS Daniel. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController,NSFetchedResultsControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context: NSManagedObjectContext = appDel.managedObjectContext!
    
        //Download content off URL
        let urlPath = "http://www.ckl.io/challenge"
        
        //Creating the url it self
        let url = NSURL(string: urlPath)
        
        //Creating a session
        let session = NSURLSession.sharedSession()
        
        
        let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            
            if (error != nil){
                
                println(error)
            }else{
                
                //Initiation JSON to convert to string and than we can use
                let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSArray
                
                //Checking  if have something inside the json
                if jsonResult.count > 0{
                    
                    //Creating a variable to store the values
                    let items: () = ()
                    
                    //Delete everything before adding something new who appers in the Json
                    var request = NSFetchRequest(entityName: "Information")
                    
                    request.returnsObjectsAsFaults = false
                    
                    var results = context.executeFetchRequest(request, error: nil)!
                    
                    if results.count > 0{
                        for results in results{
                            
                            context.deleteObject(results as! NSManagedObject)
                            
                            context.save(nil)
                        }
                        
                    }
                    
                    //loop to pass all of the json
                    for items in jsonResult {
                        
                        //conditions to take what I want from the json
                        if let title = items["title"] as? String{
                            
                            if let content = items["content"] as? String{
                                
                                if let author = items["authors"] as? String{
                                  
                                    if let website = items["website"] as? String{
                                        
                                        if let date = items["date"] as? String{

//                                            if let image = items["http://"] as? String{
                                            
                                                //Creating a variable to stoke the information in CoreData
                                                var newInfo:NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("Information", inManagedObjectContext: context) as! NSManagedObject
                                                
                                                //Puting values to add
                                                newInfo.setValue(title, forKey: "title")
                                                newInfo.setValue(content, forKey: "content")
                                                newInfo.setValue(author, forKey: "author")
                                                newInfo.setValue(website, forKey: "website")
                                                newInfo.setValue(date, forKey: "date")
//                                                newInfo.setValue(image, forKey: "image")

                                                context.save(nil)
//                                            }
                                        }
                                    }
                                }
                            }
                        }

                    }
                    
                }
                
                //Reloading TableView
                self.tableView.reloadData()
            }
        })
        
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
                (segue.destinationViewController as! DetailViewController).detailItem = object
            }
        }

    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section] as! NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
        
        cell.textLabel!.text = object.valueForKey("title")!.description
        
        //Creating new variables to put two informations on the description off the cell
        var yString = object.valueForKey("date")!.description
        var xString = object.valueForKey("author")!.description
        
        //We make one adding off the two variables and than we show
        var zString = "Author: " + xString + " - Date: " + yString
        cell.detailTextLabel?.text=zString

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Information", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
        let sortDescriptors = [sortDescriptor]
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        var error: NSError? = nil
        if !_fetchedResultsController!.performFetch(&error) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //println("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }

}