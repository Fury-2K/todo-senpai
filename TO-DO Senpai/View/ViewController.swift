//
//  ViewController.swift
//  TO-DO Senpai
//
//  Created by Manas Aggarwal on 01/04/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    private var todoData: [ToDoData] = []
    
    private var dataSource: UITableViewDiffableDataSource<Section, ToDoData>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddButton()
        configureDataSource()
        tableView.layer.cornerRadius = 5
    }
    
    private func setupAddButton() {
        addButton.layer.cornerRadius = addButton.frame.height / 2
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOpacity = 1
        addButton.layer.shadowOffset = .zero
        addButton.layer.shadowRadius = 5
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, ToDoData>(tableView: tableView) { (tableView, indexPath, todoData) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = todoData.taskTitle
            cell.detailTextLabel?.text = todoData.taskBody
            return cell
        }
    }
    
    private func createSnapshot(from todoData: [ToDoData]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ToDoData>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(todoData)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func createTask(with title: String, body: String) {
        self.todoData.append(ToDoData(taskTitle: title, taskBody: body, createdAt: ""))
        createSnapshot(from: todoData)
    }
    
    @IBAction func addTask(_ sender: Any) {
        let alert = UIAlertController(title: "Create Task..", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { $0.placeholder = "Task Title" })
        alert.addTextField(configurationHandler: { $0.placeholder = "Task Body" })
        let action = UIAlertAction(title: "Create Task", style: .default) { [weak self] _ in
            guard let title = alert.textFields?.first?.text,
            let body = alert.textFields?.last?.text
            else { return }
            self?.createTask(with: title, body: body)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            guard let deletedData = dataSource.itemIdentifier(for: indexPath as IndexPath) else { return }
            todoData.removeAll(where: { $0 == deletedData })
            createSnapshot(from: todoData)
        }
    }
}

extension ViewController {
    fileprivate enum Section {
        case main
    }
}

