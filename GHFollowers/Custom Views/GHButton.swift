//
//  GHButton.swift
//  GHFollowers
//
//  Created by Marcus Choi on 1/14/22.
//

import UIKit

class GHButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(bgColor: UIColor, title: String) {
        super.init(frame: .zero)
        self.backgroundColor = bgColor
        self.setTitle(title, for: .normal)
        configure()
    }
    
    private func configure() {
        layer.cornerRadius = 10
        setTitleColor(.white, for: .normal) 
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        //for storyboard autolayout
        translatesAutoresizingMaskIntoConstraints = false
    }

    //in case we want to change these properties after init
    func set(backgroundColor: UIColor, title: String) {
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }
}
