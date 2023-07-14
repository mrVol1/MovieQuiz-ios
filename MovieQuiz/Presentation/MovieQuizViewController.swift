import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak private var questionLable: UILabel!
    @IBOutlet weak private var counterL: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak private var buttonYes: UIButton!
    @IBOutlet weak private var buttonNo: UIButton!
    /// приватные переменные
    private var totalAccuracy: StatisticService?
    private var gamesCount: StatisticService?
    private var bestGame: StatisticService?
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresent: AlertPresent?
    private var statisticService: StatisticService?
    private var dateTimeString: DateFormatter?
    private var alertPresenterError: AlertPresenterError?
    private var presenter: MovieQuizPresenter?
    // MARK: - Lifecycle
    /// функция, для загрузки экрана в памяти
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
    }
    // MARK: - Loader Indicator
    /// показывает лоадер
    internal func showLoadingIndicator() {
        presenter?.showLoadingIndicator()
    }
    /// скрывает лоудер
    internal func hideLoadingIndicator () {
        presenter?.hideLoadingIndicator()
    }
    // MARK: - Show Alert Error for Data Response
    func showImageLoadingError() {
        presenter?.showImageLoadingError()
    }
    func showNetworkError(message: String) {
        presenter?.showNetworkError(message: message)
    }
    /// метод отображения алерта при загрузке постера
    func didFailToLoadImage() {
        showImageLoadingError()
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
        presenter?.showNextQuestionOrResults()
    }
    /// функция, которая выводит результат ответа (правильно или неправильно ответил)
    func showAnswerResult(isCorrect: Bool) {
        presenter?.showAnswerResult(isCorrect: isCorrect)
    }
    /// функция, которая показывает результат квиза
    func showQuizResult() {
        presenter?.showQuizResult()
    }
    /// функция для отображения состояния кнопок
    func showButtonState(isButtonYesEnabled: Bool, isButtonNoEnabled: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.buttonYes.isEnabled = isButtonYesEnabled
            self?.buttonNo.isEnabled = isButtonNoEnabled
        }
    }
    // MARK: - ButtonsView
    @IBAction private func buttonYes(_ sender: UIButton) {
        presenter?.buttonYes()
    }
    @IBAction private func buttonNo(_ sender: UIButton) {
        presenter?.buttonNo()
    }
}
