//
//  PostVC.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import UIKit
import CoreData

class PostVC: UIViewController, StoryboardInitializable, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postBodyLabel: UILabel!
    @IBOutlet weak var postAuthorLabel: UILabel!
    
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var commentsTableConstraint: NSLayoutConstraint!
    
    var post: Post!
    
    weak var dataManager: CoreDataManager!
    
    private var fetchedResultsController: NSFetchedResultsController<Comment>!
    
    var netService: NetworkingService!
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTitleLabel.text = post.title
        postBodyLabel.text = post.body
        
        setupCommentsTableView()
        reloadUser()
        reloadComments()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadSavedComments()
        loadSavedUser()
        updateScrollViewContentSize()
    }
    
    private func setupCommentsTableView() {
        let request = Comment.makeFetchRequest()
        request.fetchBatchSize = 20
        request.sortDescriptors = [
            NSSortDescriptor(key: "uid", ascending: false)
        ]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: dataManager.getViewContext(), sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        commentsTableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: CommentCell.cellReuseId)
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
    }
    
    //MARK: - UI

    private func updateScrollViewContentSize(){
        
        commentsTableConstraint.constant = commentsTableView.contentSize.height + 20.0
        var heightOfSubViews: CGFloat = 0.0
        contentView.subviews.forEach { subview in
            if let tableView = subview as? UITableView {
                heightOfSubViews += (tableView.contentSize.height + 20.0)
            } else {
                heightOfSubViews += subview.frame.size.height
            }
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: heightOfSubViews)
    }
    
    func reloadCommentsTableView(){
        commentsTableView.reloadData()
        commentsTableConstraint.constant = commentsTableView.contentSize.height
        view.layoutIfNeeded()
        commentsTableView.layoutIfNeeded()
    }
    
    //MARK: - CoreData
    
    func loadSavedUser() {
        guard let user = dataManager.fetchAllUsers()
                .first(where: {$0.id == post.user?.id }) else {
            return
        }
        self.postAuthorLabel.text = user.name
    }
    
    func loadSavedComments() {
        do {
            try fetchedResultsController.performFetch()
            reloadCommentsTableView()
        } catch {
            print("Fetch failed")
        }
    }
    
    //MARK: - Network
    
    /// from network
    func reloadUser() {
        guard let userId = post.user?.uid else {
            return
        }
        netService.loadUser(withID: userId) { user in
            guard let user = user else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.dataManager.createUser(with: user)
                self?.postAuthorLabel.text = user.name
            }
        }
    }
    
    /// from network
    func reloadComments() {
        netService.loadComments(forPostWithID: post.uid!, { commentsForPost in
            guard let comments = commentsForPost else {
                print("INFO: No comments received from network")
                return
            }
            print("INFO: found \(comments.count) comments for this post")
            
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                comments.forEach { comment in
                    strongSelf.dataManager.createComment(with: comment)
                }
                strongSelf.loadSavedComments()
            }
        })
    }
}


extension PostVC: UITableViewDelegate,UITableViewDataSource  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            self.commentsTableView.dequeueReusableCell(withIdentifier: CommentCell.cellReuseId, for: indexPath) as! CommentCell
        let comment = fetchedResultsController.object(at: indexPath)
        cell.configure(with: comment)
        return cell
    }
}
