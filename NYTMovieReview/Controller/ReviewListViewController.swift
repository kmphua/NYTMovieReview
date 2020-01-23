//
//  ReviewListViewController.swift
//  NYTMovieReview
//
//  Created by Kevin Phua on 2020/1/23.
//  Copyright © 2020 HagarSoft. All rights reserved.
//

import UIKit
import CoreData
import MBProgressHUD

class ReviewListViewController: UITableViewController {
    
    let cellID = "cellID"
    
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Review.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movie Reviews"
        view.backgroundColor = .white
        tableView.register(ReviewCell.self, forCellReuseIdentifier: cellID)
        updateTableContent(onLoad: true)
    }

    func updateTableContent(onLoad: Bool) {
        var itemCount = 0
        do {
            try self.fetchedhResultController.performFetch()
            print("COUNT FETCHED FIRST: \(String(describing: self.fetchedhResultController.sections?[0].numberOfObjects))")
            if let numObjects = self.fetchedhResultController.sections?[0].numberOfObjects {
                itemCount = numObjects
            }
        } catch let error  {
            print("ERROR: \(error)")
        }
        
        if onLoad && itemCount > 0 {
            // Don't load more objects if Core Data already has data
            return
        }
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Loading"
        
        let service = APIService()
        service.getDataWith(offset: itemCount) { (result) in
            switch result {
            case .Success(let data):
                //self.clearData()
                self.saveInCoreDataWith(array: data)
            case .Error(let message):
                DispatchQueue.main.async {
                    self.showAlertWith(title: "Error", message: message)
                }
            }
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: title, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ReviewCell
        
        if let review = fetchedhResultController.object(at: indexPath) as? Review {
            cell.setReviewCellWith(review: review)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedhResultController.sections?.first?.numberOfObjects {
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let review = fetchedhResultController.object(at: indexPath) as? Review else {
            print("Error retrieving Review at indexPath: \(indexPath)")
            return
        }
        
        let reviewDetailVC = ReviewDetailViewController()
        reviewDetailVC.setDetailViewWith(review)
        navigationController?.pushViewController(reviewDetailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let count = fetchedhResultController.sections?.first?.numberOfObjects {
            if indexPath.row + 1 == count {
                print("Reached the end of the table, loading more data")
                updateTableContent(onLoad: false)
            }
        }
    }
    
    private func createReviewEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        var id: Int64 = 0
        let defaults = UserDefaults.standard
        id = Int64(defaults.integer(forKey: "lastReviewId")) + 1
                
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let reviewEntity = NSEntityDescription.insertNewObject(forEntityName: "Review", into: context) as? Review {
            reviewEntity.id = id
            reviewEntity.title = dictionary["display_title"] as? String
            reviewEntity.rating = dictionary["mpaa_rating"] as? String
            reviewEntity.criticsPick = dictionary["critics_pick"] as? Int16 ?? 0
            reviewEntity.byLine = dictionary["byline"] as? String
            reviewEntity.headLine = dictionary["headline"] as? String
            reviewEntity.summary = dictionary["summary_short"] as? String
            reviewEntity.publicationDate = dictionary["publication_date"] as? String
            reviewEntity.openingDate = dictionary["opening_date"] as? String
            reviewEntity.dateUpdated = dictionary["date_updated"] as? String

            let linkDictionary = dictionary["link"] as? [String: AnyObject]
            reviewEntity.linkUrl = linkDictionary?["url"] as? String
            
            let mediaDictionary = dictionary["multimedia"] as? [String: AnyObject]
            reviewEntity.mediaUrl = mediaDictionary?["src"] as? String

            defaults.set(id, forKey: "lastReviewId")
            defaults.synchronize()
            
            return reviewEntity
        }
        return nil
    }
    
    private func saveInCoreDataWith(array: [[String: AnyObject]]) {
        _ = array.map{self.createReviewEntityFrom(dictionary: $0)}
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    private func clearData() {
        do {
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Review.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
}

extension ReviewListViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
}
