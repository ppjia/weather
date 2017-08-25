//  Copyright © 2017 rui. All rights reserved.

import UIKit
import SnapKit

class WeatherViewController: UIViewController {
    fileprivate let tableViewCellID = "WHTableViewCellID"
    fileprivate let tableView = UITableView()
    fileprivate let viewModel = WeatherViewModel()

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        tableView.estimatedSectionHeaderHeight = 60
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: tableViewCellID)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)

        // SnapKit used here for constraints
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather Forecast"
        viewModel.fetchWeatherDataWith(latitude: 33.8650, longitude: 151.2094) { [weak self] errorMessage in

            DispatchQueue.main.async {
                guard let error = errorMessage else {
                    self?.tableView.reloadData()
                    return
                }

                let alertController = UIAlertController( title: "Error", message: error, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(action)
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let forecastDetailsViewModel =
            viewModel.forecastDetailsViewModel(at: indexPath) as? DailyForecastDetailsViewModel else { return }
        let detailsViewController = DailyForecastDetailsViewController(viewModel: forecastDetailsViewModel)
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

extension WeatherViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellID, for: indexPath)
        if let cellViewModel = viewModel.cellViewModel(at: indexPath) {
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = cellViewModel.textToPresent
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let forecast = viewModel.forecastData(at: section) else { return nil }
        let view = UIView()
        let label = UILabel()
        label.backgroundColor = .lightGray
        label.numberOfLines = 0
        view.addSubview(label)

        // SnapKit used here for constraints
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10))
        }

        switch forecast.forecastType {
        case .currently:
            label.text =  "currently: " + forecast.summary
        case .daily:
            label.text =  "the next few days: " + forecast.summary
        case .hourly:
            break
        }
        return view
    }
}

