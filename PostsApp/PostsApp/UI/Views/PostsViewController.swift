//
//  ViewController.swift
//  PostsApp
//
//  Created by Prince$$ Di on 11.08.2022.
//

import UIKit
import Combine

class PostsViewController: UIViewController {
    var setForAllPosts = Set<AnyCancellable>()
    
    let postsViewModel = PostsViewModel()
    
    var expandedIndexSet : IndexSet = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setSortButton()
        
        postsViewModel.$posts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] posts in
                self?.tableView.reloadData()
            }
            .store(in: &setForAllPosts)
    }
    
    func setSortButton() {
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(sort))
        self.navigationItem.rightBarButtonItem  = sortButton
    }
    
    @objc func sort() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Popular", style: .default, handler: { _ in
            self.postsViewModel.posts.sort(by: { $0.likesCount > $1.likesCount} )
        }))
        actionSheet.addAction(UIAlertAction(title: "Date added", style: .default, handler: { _ in
            self.postsViewModel.posts.sort(by: { $0.timeshamp < $1.timeshamp} )
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(actionSheet, animated: true) {
            self.expandedIndexSet = []
        }
    }
}

extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        cell.postCellDelegate = self
        cell.indexPath = indexPath
        
        cell.selectionStyle = .none
        
        if expandedIndexSet.contains(indexPath.row) {
            cell.previewTextLabel.numberOfLines = 0
            cell.expandOrCollapseButton.setTitle("Collapse", for: .normal)
        } else {
            cell.previewTextLabel.numberOfLines = 2
            cell.expandOrCollapseButton.setTitle("Expand", for: .normal)
        }
        print(expandedIndexSet)
        
        let post = postsViewModel.get(by: indexPath.row)
        cell.setItems(post: post)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsViewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "detailVC") as? ConcretePostDetailsViewController {
            let id = postsViewModel.posts[indexPath.row].postID
            detailViewController.concretePostDetailsViewModel = ConcretePostDetailsViewModel(id: id)
            
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension PostsViewController: PostTableViewCellDelegate {
    func expandOrCollapseClicked(indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if(expandedIndexSet.contains(indexPath.row)){
            expandedIndexSet.remove(indexPath.row)
        } else {
            expandedIndexSet.insert(indexPath.row)
        }

        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
