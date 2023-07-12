import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    @IBOutlet weak private var image: UIImageView!
    @IBOutlet weak private var questionLable: UILabel!
    @IBOutlet weak private var counterL: UILabel!
    @IBOutlet weak private var loader: UIActivityIndicatorView!
    @IBOutlet weak private var buttonYes: UIButton!
    @IBOutlet weak private var buttonNo: UIButton!
    /// приватные переменные
    private var correctAnswers = 0
    private var store: StatisticService?
    private var totalAccuracy: StatisticService?
    private var gamesCount: StatisticService?
    private var bestGame: StatisticService?
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresent: AlertPresent?
    private var statisticService: StatisticService?
    private var dateTimeString: DateFormatter?
    private var randomWord = "больше"
    private var alertPresenterError: AlertPresenterError?
    private let presenter = MovieQuizPresenter()
    // MARK: - Lifecycle
    /// функция, для загрузки экрана в памяти
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresent = AlertPresentImplementation(viewController: self)
        alertPresenterError = AlertPresenterErrorImplementasion(viewControllerError: self)
        image.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(networkClient: NetworkClient(apiKey: MoviesLoader.apiKey)), delegate: self, randomWord: randomWord)
        presenter.questionFactory = questionFactory
        statisticService = StatisticServiceImplementation()
        presenter.statisticService = statisticService
        presenter.alertPresent = alertPresent
        showLoadingIndicator()
        questionFactory?.loadData()
        self.loader.hidesWhenStopped = true
        presenter.viewController = self
    }
    /// функция, которая выводит ошибку, если она возникла при загрузке данных с сети
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    /// метод отображения алерта при загрузке постера
    func didFailToLoadImage() {
        showImageLoadingError()
    }
    // MARK: - QuestionFactoryDelegate
    /// представление делегата
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    // MARK: - Loader Indicator
    /// функция, которая скрывает лоадер и показывает первый вопрос
    func didLoadDataFromServer() {
        hideLoadingIndicator() // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    /// показывает лоадер
    internal func showLoadingIndicator() {
        loader.hidesWhenStopped = true
        loader.startAnimating()
    }
    /// скрывает лоудер
    internal func hideLoadingIndicator () {
        loader.hidesWhenStopped = true
        loader.stopAnimating()
    }
    // MARK: - Show Alert Error for Data Response
    func showImageLoadingError() {
        hideLoadingIndicator()
        let alert = AlertModelError(
            title: "Ошибка загрузки изображения",
            message: "Не удалось загрузить постер фильма",
            buttonText: "Попробовать еще раз") { [weak self] in
                self?.questionFactory?.loadData()
            }
        alertPresenterError?.showImageError(alertPresentError: alert)
    }
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in self?.questionFactory?.loadData()
        }
        alertPresent?.show(alertPresent: model)
    }
    // MARK: - MainFunc
    /// функция, которая показывает вопрос
    func show(quiz step: QuizStepViewModel) {
        image.image = step.image
        questionLable.text = step.question
        counterL.text = step.questionNumber
    }
    /// функция показа следующего вопроса или показывает результат
    private func showNextQuestionOrResults() {
        presenter.showNextQuestionOrResults()
    }
    /// функция, которая выводит результат ответа (правильно или неправильно ответил)
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        image.layer.masksToBounds = true
        image.layer.borderWidth = 8
        image.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.image.layer.borderWidth = 0
        }
    }
    /// функция, которая показывает результат квиза
    func showQuizResult() {
        presenter.showQuizResult()
    }
    // MARK: - ButtonsView
    @IBAction private func buttonYes(_ sender: UIButton) {
        presenter.buttonYes()
    }
    @IBAction private func buttonNo(_ sender: UIButton) {
        presenter.buttonNo()
    }
}
