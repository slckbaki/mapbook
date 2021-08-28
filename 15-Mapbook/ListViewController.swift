//
//  ListViewController.swift
//  15-Mapbook
//
//  Created by Selcuk Baki on 21/8/21.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var idArray = [UUID]()
    var titleArray = [String]()
    var chosenTitle = ""
    var chosenTitleID : UUID?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClick))
        
        getData()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newPlace"), object: nil)
    }
    
   @objc func getData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        request.returnsObjectsAsFaults = false
        do {
            let resultsArray = try context.fetch(request)
            if resultsArray.count > 0 {
                self.titleArray.removeAll(keepingCapacity: false)
                self.idArray.removeAll(keepingCapacity: false)
            for result in resultsArray as! [NSManagedObject] {
                if let title = result.value(forKey: "title") as? String{
                    self.titleArray.append(title)
                }
                if let id = result.value(forKey: "id") as? UUID {
                    self.idArray.append(id)
                }
                self.tableView.reloadData()
            }
        }
        } catch  {
            print("error")
        }
    }
    
    @objc func addButtonClick(){
        performSegue(withIdentifier: "toViewController", sender: nil)
        chosenTitle = ""
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenTitle = titleArray[indexPath.row]
        chosenTitleID = idArray[indexPath.row]
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toViewController" {
            let destinationVC = segue.destination as! ViewController
            destinationVC.selectedTitle = chosenTitle
            destinationVC.selectedTitleID = chosenTitleID
            
        }
    }
}
