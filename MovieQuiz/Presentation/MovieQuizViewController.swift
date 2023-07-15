import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    @IBOutlet weak private var image: UIImageView!
    @IBOutlet weak private var questionLable: UILabel!
    @IBOutlet weak private var counterL: UILabel!
    @IBOutlet weak private var loader: UIActivityIndicatorView!
    @IBOutlet weak private var buttonYes: UIButton!
    @IBOutlet weak private var buttonNo: UIButton!
    var correctAnswers: Int = 0
    /// приватные переменные
    private var presenter: MovieQuizPresenter?
    // MARK: - Lifecycle
    /// функция, для загрузки экрана в памяти
    override func viewDidLoad() {
        super.viewDidLoad()
        let alertPresent = AlertPresentImplementation(viewController: self)
        presenter = MovieQuizPresenter(viewController: self, statisticServiceFactory: StatisticServiceFactory(), alertPresent: alertPresent)
    }
    // MARK: - Loader Indicator
    /// показывает лоадер
    internal func showLoadingIndicator() {
        loader?.hidesWhenStopped = true
        loader?.startAnimating()
    }
    /// скрывает лоудер
    internal func hideLoadingIndicator () {
        loader?.hidesWhenStopped = true
        loader?.stopAnimating()
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
