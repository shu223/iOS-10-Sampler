//
//  PersitentContainerViewController.swift
//  iOS-10-Sampler
//
//  Created by Noritaka Kamiya on 2016/08/31.
//  Copyright © 2016 Noritaka Kamiya. All rights reserved.
//

import UIKit
import CoreData

let persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "iOS10Sampler")
    container.loadPersistentStores { storeDescription, error in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    return container
}()

class PersitentContainerViewController: UITableViewController {
    
    var messages: [Message] = []
    
    @IBAction func add(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Add message", message: "", preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] action in
            let text = alertController.textFields?.first?.text ?? ""
            self?.create(body: text)
            self?.fetch()
        })
        
        present(alertController, animated: true)
    }
    
    func fetch() {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        let asyncRequest = NSAsynchronousFetchRequest<Message>(fetchRequest: request) { result in
            self.messages = result.finalResult ?? []
            self.tableView.reloadData()
        }
        
        try! persistentContainer.viewContext.execute(asyncRequest)
    }
    
    func create(body: String) {
        let context = persistentContainer.viewContext
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.body = body
        message.createdAt = NSDate()
        
        try! context.save()
    }
    
    func delete(at index: Int) {
        let context = persistentContainer.viewContext
        let message = messages.remove(at: index)
        
        context.delete(message)
        
        try! context.save()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetch()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let message = messages[indexPath.row]
        cell.textLabel!.text = message.body
        cell.detailTextLabel!.text = String(describing: message.createdAt!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            delete(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
}
