//
//  APODListVC.swift
//  GS-APOD
//
//  Created by Rahul Chaudhary on 26/01/22.
//

import UIKit
import CoreData

class APODListVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    let apodListVM = APODListVM()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "APOD"
        registerTableViewCell()
        apodListVM.performFetchViaFetchedResultsController(onDeledate: self)
    }
    
    private func registerTableViewCell() {
        tblView.register(APODTableViewCell.nib, forCellReuseIdentifier: APODTableViewCell.identifier)
    }
    
    // MARK: - Btn Action
    
    @IBAction func addBtnAction(sender: UIBarButtonItem) {
        let alertController = AlertController.alertControllerWithTitleMessageAndTextField(title: "Enter date", message: "Please enter the date in \n'YYYY-MM-DD'\n format.", placeholder: "YYYY-MM-DD", buttonTitles: "Submit","Cancel") { [weak self] (index, str) in
            if index == 0 {
                self?.apodListVM.fetchAPODFor(dateString: str) { [weak self] errorStr in
                    if let msg = errorStr {
                        self?.showErrorMsg(msg: msg)
                    }
                }
            }
        }
        present(alertController, animated: true)
    }
    
    private func showErrorMsg(msg: String) {
        let alertController = AlertController.alertControllerWithTitleAndMessage(title: msg, message: nil, buttonTitles: "OK", completion: nil)
        present(alertController, animated: true)
    }
}

extension APODListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return apodListVM.fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apodListVM.fetchedResultsController.sections![section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: APODTableViewCell.identifier) as? APODTableViewCell else {
            return UITableViewCell()
        }
        cell.apodTableViewCellVM.apodModel = apodListVM.fetchedResultsController.object(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = apodListVM.getURLFor(indexPath: indexPath) else {
            return
        }
        let navVC = UIStoryboard.instantiateVCFromMain("WebViewNavVC") as? UINavigationController
        if let webViewVC = navVC?.viewControllers.first as? WebViewVC {
            webViewVC.loadUrl(url: url)
            present(navVC!, animated: true)
        }
    }
}

extension APODListVC: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                if let newIndexPath = newIndexPath {
                    tblView.insertRows(at: [newIndexPath], with: .none)
                }
                break
            case .delete:
                if let indexPath = indexPath {
                    tblView.deleteRows(at: [indexPath], with: .none)
                }
                break
            case .update:
                if let indexPath = indexPath {
                    tblView.reloadRows(at: [indexPath], with: .none)
                }
            case .move:
                if let indexPath = indexPath, let newIndexPath = newIndexPath {
                    tblView.deleteRows(at: [indexPath], with: .none)
                    tblView.insertRows(at: [newIndexPath], with: .none)
                }
            default:
                break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tblView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tblView.endUpdates()
    }
}
