//
//  HomeViewController.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import Foundation
import UIKit
import Combine

final class HomeViewController: UIViewController {

    private let viewModel: HomeViewModel

    private lazy var container: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()

    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Background", in: Bundle.module, with: nil)!)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchScore()
    }

    private func setupViews() {

        // Background image view
        view.addSubview(backgroundImageView)

        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Container view
        view.addSubview(container)

        let shortestSide: CGFloat = min(view.bounds.size.width, view.bounds.size.height)
        let margin: CGFloat = 25

        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalTo: container.widthAnchor),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.widthAnchor.constraint(equalToConstant:  shortestSide - (margin * 2))
        ])

        // Score view
        let scoreView = ScoreView(viewModel: viewModel.scoreViewModel)
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(scoreView)

        NSLayoutConstraint.activate([
            scoreView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            scoreView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            scoreView.topAnchor.constraint(equalTo: container.topAnchor),
            scoreView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}
