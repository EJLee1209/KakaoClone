//
//  MyImageCell.swift
//  KakaoClone
//
//  Created by 이은재 on 10/31/23.
//

import UIKit

final class MyImageCell: UITableViewCell {
    //MARK: - Properties
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .systemGray2
        return label
    }()
    
    private let vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [])
        sv.axis = .vertical
        sv.spacing = 4
        return sv
    }()
    
    static let id = "MyImageCell"
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func layout() {
        backgroundColor = .clear
        [vStackView, dateLabel].forEach(contentView.addSubview(_:))
        vStackView.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.width.lessThanOrEqualTo(UIScreen.main.bounds.width - 150)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(vStackView)
            make.right.equalTo(vStackView.snp.left).offset(-4)
        }
    }
    
    func makeUI(message: ChatMessage) {
        dateLabel.text = message.timestamp.formattedDateString(dateFormat: "a hh:mm")
        
        let numberOfImage = message.images.count
        guard numberOfImage > 0 else { return }
        
        var views: [UIImageView] = []
        for i in 0 ..< numberOfImage {
            let iv = UIImageView()
            iv.backgroundColor = .systemIndigo
            iv.clipsToBounds = true
            iv.layer.cornerRadius = 4
            iv.sd_setImage(with: message.images[i])
            views.append(iv)
        }
        
        let numberOfRow = numberOfImage / 3
        let remain = numberOfImage % 3
        
        if numberOfRow > 0 {
            var rows = [UIStackView]()
            
            switch remain {
            case 0: // 모든 행을 3열로 만들기
                makeThreeColumnRows(numberOfRow: numberOfRow, views: views, rows: &rows)
            case 1: // 몫 - 1 행만 3열로 나머지는 2행 2열
                makeThreeColumnRows(numberOfRow: numberOfRow - 1, views: views, rows: &rows)
                
                for i in 0 ..< 2 {
                    let hStackView = makeHStackView()
                    
                    let startIdx = (numberOfRow - 1) * 3 + (i * 2)
                    for j in startIdx ..< startIdx + 2 {
                        hStackView.addArrangedSubview(views[j])
                    }
                    
                    makeConstraintsForHStackViewSubViews(hStackView.arrangedSubviews)
                    rows.append(hStackView)
                }
                
            case 2: // 몫 행만 3열로 나머지 1행은 2열
                makeThreeColumnRows(numberOfRow: numberOfRow, views: views, rows: &rows)
                
                let hStackView = makeHStackView()
                for i in numberOfImage - 2 ..< numberOfImage {
                    hStackView.addArrangedSubview(views[i])
                }
                
                makeConstraintsForHStackViewSubViews(hStackView.arrangedSubviews)
                rows.append(hStackView)
            default:
                break
            }
            
            rows.forEach(vStackView.addArrangedSubview(_:))
        } else {
            let hStackView = makeHStackView()
            views.forEach(hStackView.addArrangedSubview(_:))
            vStackView.addArrangedSubview(hStackView)
            
            makeConstraintsForHStackViewSubViews(hStackView.arrangedSubviews)
        }
        
    }
    
    private func makeThreeColumnRows(
        numberOfRow: Int,
        views: [UIView],
        rows: inout [UIStackView]
    ) {
        for i in 0 ..< numberOfRow {
            let hStackView = makeHStackView()
            for j in i * 3 ..< i * 3 + 3 {
                hStackView.addArrangedSubview(views[j])
            }
            
            makeConstraintsForHStackViewSubViews(hStackView.arrangedSubviews)
            rows.append(hStackView)
        }
    }
    
    private func makeHStackView() -> UIStackView {
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.spacing = 4
        hStackView.distribution = .fillEqually
        return hStackView
    }
    
    private func makeConstraintsForHStackViewSubViews(_ subViews: [UIView]) {
        subViews.forEach { view in
            view.snp.makeConstraints { make in
                make.height.equalTo(view.snp.width)
            }
        }
    }
    
}
