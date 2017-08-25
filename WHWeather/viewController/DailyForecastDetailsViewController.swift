//  Copyright © 2017 rui. All rights reserved.

import UIKit

class DailyForecastDetailsViewController: UIViewController {
    private let viewModel: DailyForecastDetailsViewModel
    private let textView = UITextView()
    
    init(viewModel: DailyForecastDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = UIView()
        textView.isEditable = false
        view.addSubview(textView)
        
        // SnapKit used here for constraints
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = viewModel.detailsToPresent.map { $0.0 + ": " + $0.1 }.joined(separator: "\n\n")
    }
}
