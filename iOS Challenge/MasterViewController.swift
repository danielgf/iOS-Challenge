//
//  MasterViewController.swift
//  iOS Challenge
//
//  Created by Daniel Griso Filho on 6/11/15.
//  Copyright (c) 2015 iOS Daniel. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController,NSFetchedResultsControllerDelegate,UITableViewDelegate,UITableViewDataSource {
    
    var managedObjectContext: NSManagedObjectContext? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        //Download Contents of URL
        let urlPath = "http://www.ckl.io/challenge"
        
        //Creating the url it self
        let url = NSURL(string: urlPath)
        
        //Creating a session
        let session = NSURLSession.sharedSession()
        
        //Creating a task
        let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            
            //Check if is not nil
            if(error != nil){
                
                //Print the error
                println(error)
            }else{
                
                //Initiation JSON to convert everything to a string and use after
                let jsonResul = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSArray
                
                //Checking if have something inside the JSON
                if jsonResul.count > 0{
                    
                    //Creating a variable to store the values
                    let items:() = ()
                    
                    //Deleting everything before adding something new who appers in the JSON
                    var request = NSFetchRequest(entityName: "Information")
                    
                    //Creating one variable to keep the context
                    var results = context.executeFetchRequest(request, error: nil)!
                    
                    //Checking if the variable create before have something inside
                    if results.count > 0{
                        
                        //Create a loop for pass into all the result
                        for results in results{
                            
                            //Deleting everything in the context
                            context.deleteObject(results as! NSManagedObject)
                            
                            context.save(nil)
                        }
                    }
                    
                    //Create a loop to pass into JSON
                    for items in jsonResul {
                        
                        //Conditions to take what we need from the JSON
                        if let title = items["title"] as? String{
                            
                            if let content = items["content"] as? String{
                                
                                if let author = items["authors"] as? String{
                                    
                                    if let website = items["website"] as? String{
                                        
                                        if let date = items["date"] as? String{
                                            
                                            //Creating a variable to store the information in CoreData
                                            var newInfo:NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("Information", inManagedObjectContext: context) as! NSManagedObject
                                            
                                            //Pass values to the CoreData
                                            newInfo.setValue(title, forKey: "title")
                                            newInfo.setValue(content, forKey: "content")
                                            newInfo.setValue(author, forKey: "author")
                                            newInfo.setValue(website, forKey: "website")
                                            newInfo.setValue(date, forKey: "date")
                                            context.save(nil)
                                            
                                            if let imageURL = items["image"] as? String{
                                                
                                                newInfo.setValue(imageURL, forKey: "imageURL")
                                                context.save(nil)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
                
            }
            //Reloading TableView
            self.tableView.reloadData()
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
        return self.fetchedResultsController.sections?.count ?? 0
        //        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section] as! NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TableViewCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func configureCell(cell: TableViewCell, atIndexPath indexPath: NSIndexPath) {
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
        
        //We create a new class to custom the cell and after that we call the class into the func
        cell.titleLabel.text = object.valueForKey("title")!.description
        cell.authorLabel.text = object.valueForKey("author")!.description
        cell.dateLabel.text = object.valueForKey("date")!.description
        
        
//        let urlimage:NSURL = NSURL(string: "http://lorempixel.com/400/400/technics/1/")!
//        
//        let data:NSData = NSData(contentsOfURL: urlimage)!
//        
//        let image:UIImage = UIImage(data: data)!
        
    }
    
    //We create this func to custom the display of the cell
    func tableView(tableView: UITableView, willDisplayCell cell: TableViewCell, forRowAtIndexPath indexPath: NSIndexPath)() {
        
        //We set one image into the imageView before show the real image who is coming from the URL
        cell.imageShow.image = UIImage(contentsOfFile: "Placeholder")
        
        //We put one animation to show the user the image is loading
        cell.activitiShow.startAnimating()
        
    }
    
    //Create this func to put one Checkmark when you click to see the informations on the cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
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