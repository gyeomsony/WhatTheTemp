//
//  WeatherView.swift
//  WhatTheTemp
//
//  Created by 이명지 on 1/7/25.
//
import UIKit
import RxSwift
import RxCocoa

final class WeatherView: UIView {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - 상단 UI Components
    // 지역명, 날씨, 기온 표시 컴포넌트
    private let locationNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private let weatherLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private lazy var mainWeatherTextStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [locationNameLabel, weatherLabel, temperatureLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .equalCentering
        stackView.alignment = .leading
        return stackView
    }()
    
    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 60, height: 60))
        }
        return imageView
    }()
    
    private lazy var mainWeatherBlock = HorizontalStackView(with: [mainWeatherTextStackView,
                                                                   weatherIconImageView])
    
    // 체감온도, 최저온도, 최고온도 표시 컴포넌트
    private let feelsLikeTemperatureLabel = WeatherDegreeLabel()
    private lazy var feelsLikeStackView = VerticalStackView(with: [feelsLikeTemperatureLabel,
                                                                  WeatherTitleLabel("체감")])
    private let minTemperatureLabel = WeatherDegreeLabel()
    private lazy var minTemperatureStackView = VerticalStackView(with: [minTemperatureLabel,
                                                                        WeatherTitleLabel("최저")])
    private let maxTemperatureLabel = WeatherDegreeLabel()
    private lazy var maxTemperatureStackView = VerticalStackView(with: [maxTemperatureLabel,
                                                                        WeatherTitleLabel("최고")])
    private lazy var feelsLikeBlock = HorizontalStackView(with: [feelsLikeStackView,
                                                                 minTemperatureStackView,
                                                                 maxTemperatureStackView])
    
    // 풍속, 습도, 강수확률 표시 컴포넌트
    private let windSpeedLabel = WeatherDegreeLabel()
    private let windSpeedIconImageView = IconImageView(name: "windSpeed")
    private lazy var windStackView = VerticalStackView(with: [windSpeedIconImageView,
                                                              windSpeedLabel,
                                                              WeatherTitleLabel("풍속")])
    private let humidityLabel = WeatherDegreeLabel()
    private let humidityIconImageView = IconImageView(name: "humidity")
    private lazy var humidityStackView = VerticalStackView(with: [humidityIconImageView,
                                                                  humidityLabel,
                                                                 WeatherTitleLabel("습도")])
    private let rainLabel = WeatherDegreeLabel()
    private let rainIconImageView = IconImageView(name: "rainProbability")
    private lazy var rainStackView = VerticalStackView(with: [rainIconImageView,
                                                              rainLabel,
                                                              WeatherTitleLabel("강수")])
    private lazy var windSpeedBlock = HorizontalStackView(with: [windStackView,
                                                                 humidityStackView,
                                                                 rainStackView])
    
    // 오늘 날씨 나타내는 컴포넌트들 묶는 스택뷰
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mainWeatherBlock,
                                                       feelsLikeBlock,
                                                       windSpeedBlock])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 15
        return stackView
    }()
    
    // MARK: - 하단 UI Components
    private var timeFilterButtons = [UIButton]()
    
    private let timeFilterButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        return stackView
    }()
    
    private lazy var hourlyCollectionView: HourlyCollectionView = {
        let collectionView = HourlyCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        return collectionView
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupButtons()
        setupAutoLayouts()
        setupDelegates()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Functions
    private func setupSubviews() {
        self.addSubview(topStackView)
        self.addSubview(timeFilterButtonsStackView)
        self.addSubview(hourlyCollectionView)
    }
    
    private func setupAutoLayouts() {
        topStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        mainWeatherBlock.snp.makeConstraints {
            $0.height.equalTo(170)
        }
        
        feelsLikeBlock.snp.makeConstraints {
            $0.height.equalTo(80)
        }
        
        windSpeedBlock.snp.makeConstraints {
            $0.height.equalTo(110)
        }
        
        timeFilterButtonsStackView.snp.makeConstraints {
            $0.top.equalTo(topStackView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(30)
        }
        
        hourlyCollectionView.snp.makeConstraints {
            $0.top.equalTo(timeFilterButtonsStackView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(120)
        }
    }
    
    private func setupButtons() {
        let buttonTitles = ["Today", "Tomorrow", "Next 3 Days"]
        for (index, title) in buttonTitles.enumerated() {
            let button = UIButton(type: .custom)
            button.backgroundColor = .clear
            button.setTitle(title, for: .normal)
            button.setTitleColor(.gray, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            button.tag = index
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            timeFilterButtons.append(button)
            timeFilterButtonsStackView.addArrangedSubview(button)
        }
        timeFilterButtons.first?.isSelected = true
    }
    
    @objc
    private func buttonTapped(_ sender: UIButton) {
        timeFilterButtons.forEach {
            $0.isSelected = false
        }
        sender.isSelected = true
    }
    
    private func setupDelegates() {
        hourlyCollectionView.delegate = self
        hourlyCollectionView.dataSource = self
    }
    
    // MARK: - Binding Method
    func bind(to viewModel: WeatherViewModel) {
        viewModel.currentWeather
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] current in
                self?.updateUI(with: current)
            }, onError: { error in
                print("데이터 바인딩 에러 발생: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI Update Method
    private func updateUI(with current: Current) {
        // 현재 날씨
        locationNameLabel.text = current.locationName
        weatherLabel.text = current.weatherDescription
        temperatureLabel.text = "\(Int(current.currentTemperature))°"
        weatherIconImageView.image = UIImage(named: WeatherAssets.getIconName(from: current.weatherCode))
        
        // 체감온도, 최저기온, 최고기온
        feelsLikeTemperatureLabel.text = "\(Int(current.feelsLikeTemperature))°"
        minTemperatureLabel.text = "\(Int(current.minTemperature))°"
        maxTemperatureLabel.text = "\(Int(current.maxTemperature))°"
        
        // 풍속, 습도, 강수확률
        windSpeedLabel.text = "\(Int(current.windSpeed))m/s"
        humidityLabel.text = "\(current.humidity)%"
        rainLabel.text = "\(Int(current.rainProbability))%"
    }
}

// MARK: - UIUICollectionView DataSource
extension WeatherView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell", for: indexPath) as? HourlyCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}

// MARK: - UICollectionView Delegate
extension WeatherView: UICollectionViewDelegate {
}
