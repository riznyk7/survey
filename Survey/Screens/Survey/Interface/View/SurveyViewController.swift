//
//  SurveyViewController.swift
//  Survey
//
//  Created by Piter Miller on 12/5/19.
//  Copyright © 2019 home. All rights reserved.
//

import UIKit

final class SurveyViewController: ViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var questionsSubmittedLabel: UILabel!
    
    var presenter: SurveyModuleInterface?
    
    private lazy var prevButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "Prev", style: .done, target: self, action: #selector(didTouchPrev))
    }()
    
    private lazy var nextButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(didTouchNext))
    }()
    
    private var displayItems: [SurveyQuestionCollectionViewCell.DisplayItem] = []
    private var currentPage = 0 { didSet { processCurrentPageChange() } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        presenter?.setup()
    }
    
    private func configureViews() {
        configurePaginationButtons()
        updateNavigationBar()
        configureCollectionView()
        registerCells()
    }
    
    private func configurePaginationButtons() {
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 20
        
        navigationItem.rightBarButtonItems = [nextButton, space, prevButton]
        [prevButton, nextButton].forEach { $0.isEnabled = false }
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        
        DispatchQueue.main.async {
            self.configureCollectionViewLayout()
        }
    }
    
    private func configureCollectionViewLayout() {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.itemSize = collectionView.bounds.size
        flowLayout.scrollDirection = .horizontal

        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0
    }
    
    private func registerCells() {
        collectionView.registerCellFromNib(SurveyQuestionCollectionViewCell.self)
    }
    
    @objc private func didTouchPrev() {
        guard currentPage - 1 >= 0 else { return }
        currentPage -= 1
        view.endEditing(true)
    }
    
    @objc private func didTouchNext() {
        guard currentPage + 1 < displayItems.count else { return }
        currentPage += 1
        view.endEditing(true)
    }
    
    private func updateNavigationBar() {
        if displayItems.isEmpty {
            navigationItem.title = "Question 0/0"
        } else {
            navigationItem.title = "Question \(currentPage+1)/\(displayItems.count)"
        }
        
        prevButton.isEnabled = currentPage > 0
        nextButton.isEnabled = currentPage < displayItems.count - 1
    }
    
    private func updateSubmittedQuestionsCount() {
        guard let submittedQuestionsCount = presenter?.submittedQuestionsCount() else { return }
        questionsSubmittedLabel.text = "Questions submitted: \(submittedQuestionsCount)"
    }
    
    private func processCurrentPageChange() {
        scrollToItem(at: currentPage)
        updateNavigationBar()
    }
    
    private func scrollToItem(at index: Int) {
        collectionView.scrollToItem(at: IndexPath(item: index,
                                                  section: 0),
                                    at: .centeredHorizontally,
                                    animated: true)
    }
    
    deinit {
        print("SurveyViewController deinit...")
    }
}



//MARK: - SurveyViewInterface

extension SurveyViewController: SurveyViewInterface {
    
    func didLoadItems(_ items: [SurveyQuestionCollectionViewCell.DisplayItem]) {
        displayItems = items
        collectionView.reloadData()
        updateNavigationBar()
    }
    
    func didUpdateItems(_ items: [SurveyQuestionCollectionViewCell.DisplayItem]) {
        displayItems = items
        updateSubmittedQuestionsCount()
        refreshItems()
    }
    
    private func refreshItems() {
        let indexPaths = collectionView.indexPathsForVisibleItems
        
        indexPaths.forEach { indexPath in
            guard let cell = collectionView.cellForItem(at: indexPath) as? SurveyQuestionCollectionViewCell else { return }
            let item = displayItems[indexPath.row]
            cell.configure(with: item)
        }
    }
    
}

//MARK: - UICollectionViewDataSource

extension SurveyViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SurveyQuestionCollectionViewCell = collectionView.dequeueCell(at: indexPath)
        let item = displayItems[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
}
