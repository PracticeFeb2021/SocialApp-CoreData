//
//  PostListVC.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import UIKit
import CoreData

class PostListVC: UIViewController, StoryboardInitializable, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var dataManager: CoreDataManager!
    
    var netService: NetworkingService!

    private var fetchedResultsController: NSFetchedResultsController<Post>!
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationItem.title = "Posts"
        
        setupFetchedResultsController()
        
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: PostCell.cellReuseId)
        tableView.dataSource = self
        tableView.delegate = self
        
        preloadUsers()
        reloadPosts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadSavedPosts()
    }
    
    //MARK: - UI setup

    private func setupFetchedResultsController() {
        let request = Post.makeFetchRequest()
        request.fetchBatchSize = 20
        request.sortDescriptors = [
            NSSortDescriptor(key: "uid", ascending: false)
        ]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: dataManager.getViewContext(), sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
    }
    
    //MARK: - CoreData
    
    func loadSavedPosts() {
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    func preloadUsers(){
        netService.loadUsers { users in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self,
                      let users = users else {
                    return
                }
                users.forEach { user in
                    strongSelf.dataManager.createUser(with: user)
                }
            }
        }
    }
    
    /// from network
    func reloadPosts() {
        netService.loadPosts { [weak self] posts in
            guard let strongSelf = self,
                  let newPosts = posts else {
                return
            }
            print("INFO: \(newPosts.count) posts received from network")
            
            DispatchQueue.main.async {
                newPosts.forEach { post in
                    strongSelf.dataManager.createPost(with: post)
                }
                strongSelf.loadSavedPosts()
            }
        }
    }
}

//MARK: - TableView

extension PostListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(withIdentifier: PostCell.cellReuseId, for: indexPath) as! PostCell
        let post = fetchedResultsController.object(at: indexPath)
        cell.configure(with: post)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PostVC") as! PostVC
        vc.netService = netService
        vc.dataManager = dataManager
        vc.post = fetchedResultsController.object(at: indexPath)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
