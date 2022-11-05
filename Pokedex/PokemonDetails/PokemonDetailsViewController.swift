//
//  PokemonDetailsViewController.swift
//  Pokedex
//
//  Created by Felipe Leite on 05/11/22.
//

import UIKit
import Charts

class PokemonDetailsViewController: UIViewController {

    private struct Consts {
        static let imageSize: CGFloat = 144.0
        static let fontSize: CGFloat = 20.0
        static let padding: CGFloat = 16.0
        static let chartHeight: CGFloat = 200.0
    }

    // MARK: Properties

    var presenter: PokemonDetailsPresenter

    // MARK: Views

    private lazy var imageView = UIImageView()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: Consts.fontSize)

        return label
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Type:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: Consts.fontSize)

        return label
    }()
    
    private lazy var typeStack: TypeStackView = {
        let stack = TypeStackView()
        
        stack.axis = .horizontal
        stack.spacing = 8.0
        stack.translatesAutoresizingMaskIntoConstraints = false

        return stack
    }()
    
    private lazy var heightLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Height:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: Consts.fontSize)

        return label
    }()
    
    private lazy var heightValueLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: Consts.fontSize)

        return label
    }()
    
    private lazy var weightLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Weight:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: Consts.fontSize)

        return label
    }()
    
    private lazy var weightValueLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: Consts.fontSize)

        return label
    }()
    
    private lazy var statsLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Stats:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: Consts.fontSize)

        return label
    }()
    
    private lazy var statsChartView: BarChartView = {
        let view = BarChartView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    // MARK: Initialization
    
    init(pokemon: Pokemon) {
        self.presenter = PokemonDetailsPresenter(pokemon: pokemon)

        super.init(nibName: nil, bundle: nil)
        
        self.title = pokemon.fullIdentifier
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.presenter.delegateDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showContent(true, animated: true)
    }
    
    // MARK: Helpers
    
    private func setup() {
        self.presenter.delegate = self

        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false

        self.view.backgroundColor = .white
        [
            self.imageView,
            self.typeLabel,
            self.typeStack,
            self.heightLabel,
            self.heightValueLabel,
            self.weightLabel,
            self.weightValueLabel,
            self.statsLabel,
            self.statsChartView,
        ].forEach { self.view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                                                constant: Consts.padding),
            self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.imageView.widthAnchor.constraint(equalToConstant: Consts.imageSize),
            self.imageView.heightAnchor.constraint(equalToConstant: Consts.imageSize),
        ])
        
        NSLayoutConstraint.activate([
            self.typeLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor,
                                                constant: Consts.padding),
            self.typeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                    constant: Consts.padding),
        ])

        NSLayoutConstraint.activate([
            self.typeStack.centerYAnchor.constraint(equalTo: self.typeLabel.centerYAnchor),
            self.typeStack.leadingAnchor.constraint(equalTo: self.typeLabel.trailingAnchor,
                                                    constant: Consts.padding),
        ])
        
        NSLayoutConstraint.activate([
            self.typeLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor,
                                                constant: Consts.padding),
            self.typeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                    constant: Consts.padding),
        ])
        
        NSLayoutConstraint.activate([
            self.heightLabel.topAnchor.constraint(equalTo: self.typeLabel.bottomAnchor,
                                                  constant: Consts.padding),
            self.heightLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                      constant: Consts.padding),
        ])

        NSLayoutConstraint.activate([
            self.heightValueLabel.topAnchor.constraint(equalTo: self.heightLabel.topAnchor),
            self.heightValueLabel.leadingAnchor.constraint(equalTo: self.heightLabel.trailingAnchor,
                                                           constant: Consts.padding),
        ])
        
        NSLayoutConstraint.activate([
            self.weightLabel.topAnchor.constraint(equalTo: self.heightLabel.topAnchor),
            self.weightLabel.leadingAnchor.constraint(equalTo: self.heightValueLabel.trailingAnchor,
                                                      constant: Consts.padding),
        ])
        
        NSLayoutConstraint.activate([
            self.weightValueLabel.topAnchor.constraint(equalTo: self.weightLabel.topAnchor),
            self.weightValueLabel.leadingAnchor.constraint(equalTo: self.weightLabel.trailingAnchor,
                                                           constant: Consts.padding),
        ])
        
        NSLayoutConstraint.activate([
            self.statsLabel.topAnchor.constraint(equalTo: self.weightLabel.bottomAnchor,
                                                 constant: Consts.padding),
            self.statsLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                     constant: Consts.padding),
        ])

        NSLayoutConstraint.activate([
            self.statsChartView.topAnchor.constraint(equalTo: self.statsLabel.bottomAnchor,
                                                     constant: Consts.padding),
            self.statsChartView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                         constant: Consts.padding),
            self.statsChartView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                          constant: -Consts.padding),
            self.statsChartView.heightAnchor.constraint(equalToConstant: Consts.chartHeight),
        ])
        
        self.showContent(false, animated: false)
    }
    
    // MARK: Helpers
    
    private func showContent(_ show: Bool, animated: Bool) {
        let duration = animated == true ? 0.3 : 0
        let transform = CGAffineTransform(translationX: 0, y: 32)
        let alpha = show ? 1.0 : 0.0
        let delay = show ? 0.1 : 0.0

        UIView.animate(withDuration: duration, delay: 0) {
            self.imageView.transform = show ? .identity : transform
            self.imageView.alpha = alpha
        }
        
        UIView.animate(withDuration: duration, delay: delay) {
            self.typeLabel.transform = show ? .identity : transform
            self.typeStack.transform = show ? .identity : transform
            self.typeLabel.alpha = alpha
            self.typeStack.alpha = alpha
        }
        
        UIView.animate(withDuration: duration, delay: delay * 2) {
            self.heightLabel.transform = show ? .identity : transform
            self.heightValueLabel.transform = show ? .identity : transform
            self.weightLabel.transform = show ? .identity : transform
            self.weightValueLabel.transform = show ? .identity : transform
            self.heightLabel.alpha = alpha
            self.heightValueLabel.alpha = alpha
            self.weightLabel.alpha = alpha
            self.weightValueLabel.alpha = alpha
        }
        
        UIView.animate(withDuration: duration, delay: delay * 3) {
            self.statsLabel.transform = show ? .identity : transform
            self.statsChartView.transform = show ? .identity : transform
            self.statsLabel.alpha = alpha
            self.statsChartView.alpha = alpha
        }
    }

}

// MARK: -

extension PokemonDetailsViewController: PokemonDetailsPresenterDelegate {
    
    func show(_ pokemon: Pokemon) {
        let lengthFormatter = LengthFormatter()
        lengthFormatter.unitStyle = .short
        lengthFormatter.isForPersonHeightUse = true
        
        let massFormatter = MassFormatter()
        massFormatter.unitStyle = .medium
        massFormatter.isForPersonMassUse = true

        self.typeStack.load(types: pokemon.types ?? [])
        
        let decimeters = Double(pokemon.height ?? 0)
        let inches = Measurement(value: decimeters, unit: UnitLength.decimeters).converted(to: .feet).value
        let formattedHeight = lengthFormatter.string(fromValue: inches, unit: .foot)
        self.heightValueLabel.text = formattedHeight

        let grams = Double(pokemon.weight ?? 0) * 100
        let pounds = Measurement(value: grams, unit: UnitMass.grams).converted(to: .pounds).value
        let formattedWeight = massFormatter.string(fromValue: pounds, unit: .pound)
        self.weightValueLabel.text = formattedWeight
        
        self.buildStats(pokemon: pokemon)
        Task { await self.imageView.loadPokemon(pokemon) }
    }
    
    // MARK: Helpers
    
    private func buildStats(pokemon: Pokemon) {
        guard let stats = pokemon.stats else { return }

        var dataEntries: [ ChartDataEntry ] = []
        var labels: [ String ] = []

        stats.enumerated().forEach { (index, stat) in
            dataEntries.append(
                BarChartDataEntry(x: Double(index),
                                  y: Double(stat.baseStat ?? 0))
            )
            labels.append(stat.name ?? "")
        }

        let chartDataSet = BarChartDataSet(entries: dataEntries)
        chartDataSet.stackLabels = labels
        chartDataSet.valueFont = .systemFont(ofSize: 15)

        let chartData = BarChartData(dataSet: chartDataSet)
        chartData.barWidth = 0.5

        statsChartView.data = chartData
        statsChartView.leftAxis.drawGridLinesEnabled = false
        statsChartView.rightAxis.enabled = false
        statsChartView.xAxis.valueFormatter = ChartXAxisFormatter()
        statsChartView.xAxis.labelFont = .systemFont(ofSize: 11)
        statsChartView.xAxis.drawGridLinesEnabled = false
        statsChartView.legend.enabled = false
    }

}

// MARK: -

class ChartXAxisFormatter: AxisValueFormatter {

    static let labels = [ "HP", "Attack", "Defense", "Special\nAttack", "Special\nDefense", "Speed" ]

    func stringForValue(_ value: Double, axis: Charts.AxisBase?) -> String {
        return ChartXAxisFormatter.labels[Int(value)]
    }
    
}
