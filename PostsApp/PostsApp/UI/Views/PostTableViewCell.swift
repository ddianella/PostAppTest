//
//  PostTableViewCell.swift
//  PostsApp
//
//  Created by Prince$$ Di on 16.08.2022.
//

import UIKit

protocol PostTableViewCellDelegate {
    func expandOrCollapseClicked(indexPath: IndexPath)
}

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var previewTextLabel: UILabel!
    @IBOutlet weak var horizontalStackForLikesAndDate: UIStackView!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var timeshampLabel: UILabel!
    @IBOutlet weak var expandOrCollapseButton: UIButton!
    @IBOutlet weak var heightOfExpandOrCollapseButton: NSLayoutConstraint!
    
    var howManyDaysAgo: Int?
    
    var postCellDelegate: PostTableViewCellDelegate?
    var indexPath: IndexPath?
    
    func setItems(post: Post) {
        expandOrCollapseButton.layer.cornerRadius = 10
        titleLabel.text = post.title
        previewTextLabel.text = post.previewText
        
        if previewTextLabel.maxNumberOfLines <= 2 {
            expandOrCollapseButton.isHidden = true
            heightOfExpandOrCollapseButton.constant = 0
        }
        
        likesCountLabel.text = String("❤️\(post.likesCount)")
        getHowManyDaysAgo(timestamp: post.timeshamp)
        guard let howManyDaysAgo = howManyDaysAgo else { return }
        timeshampLabel.text = String("\(howManyDaysAgo) days ago")
    }
    
    func getHowManyDaysAgo(timestamp: Int) {
        let calendar = Calendar.current
        let dateNow = calendar.startOfDay(for: .now)
        let dateFromPost = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let postedDate = calendar.startOfDay(for: dateFromPost)
        howManyDaysAgo = calendar.dateComponents([.day], from: postedDate, to: dateNow).day
    }
    
    @IBAction func expandOrCollapseAction(_ sender: Any) {
        if let indexPath = indexPath {
            postCellDelegate?.expandOrCollapseClicked(indexPath: indexPath)
        }
    }
}
