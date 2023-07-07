import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    @IBOutlet weak private var image: UIImageView!
    @IBOutlet weak private var questionLable: UILabel!
    @IBOutlet weak private var counterL: UILabel!
    @IBOutlet weak private var loader: UIActivityIndicatorView!
    @IBOutlet weak private var buttonYes: UIButton!
    @IBOutlet weak private var buttonNo: UIButton!
        /// приватные переменные
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var store: StatisticService?
    private var totalAccuracy: StatisticService?
    private var gamesCount: StatisticService?
    private var bestGame: StatisticService?
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresent: AlertPresent?
    private var statisticService: StatisticService?
    private var dateTimeString: DateFormatter?
    private var randomWord = "больше"
    private var alertPresenterError: AlertPresenterError?
    private var myButtonYes: UIButton?
    private var myButtonNo: UIButton?

    // MARK: - Lifecycle
        /// функция, для загрузки экрана в памяти
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresent = AlertPresentImplementation(viewController: self)
        alertPresenterError = AlertPresenterErrorImplementasion(viewControllerError: self)
        image.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(networkClient: StubNetworkClient(emulateError: false)), delegate: self, randomWord: randomWord)
        statisticService = StatisticServiceImplementation()

        showLoadingIndicator()
        questionFactory?.loadData()
        self.loader.hidesWhenStopped = true
        myButtonYes = buttonYes as UIButton?
        myButtonNo = buttonNo as UIButton?
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
        /// метод делегата
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
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
        /// функция, которая конвертирует полученные данные
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
        /// функция, которая показывает вопрос
    private func show(quiz step: QuizStepViewModel) {
        image.image = step.image
        questionLable.text = step.question
        counterL.text = step.questionNumber
    }
        /// функция показа следующего вопроса или показывает результат
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            showQuizResult()
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
        myButtonYes?.isEnabled = true
        myButtonNo?.isEnabled = true
    }
        /// функция, которая выводит результат ответа (правильно или неправильно ответил)
    private func showAnswerResult(isCorrect: Bool) {
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
        myButtonYes?.isEnabled = false
        myButtonNo?.isEnabled = false
    }
    /// функция, которая показывает результат квиза
    private func showQuizResult() {
        statisticService?.store(correct: correctAnswers, total: questionsAmount)
        guard let statisticService = statisticService else {
            assertionFailure("Ошибка игры")
            return
        }
        let message =
            """
    Ваш результат: \(correctAnswers)/10,
    Количество сыгранных квизов: \(statisticService.gamesCount),
    Рекорд: \(statisticService.bestGame?.correct ?? 0)/10 (\((statisticService.bestGame?.date.dateTimeString) ?? "Ошибка времени")),
    Средняя точность \(String(format: "%.2f", statisticService.totalAccuracy))
"""
        let viewModel = AlertModel(
            title: "Этот раунд окончен!",
            message: message,
            buttonText: "Сыграть ещё раз",
            completion: { [weak self] in
                self?.correctAnswers = 0
                self?.currentQuestionIndex = 0
                self?.questionFactory?.requestNextQuestion()
            }
        )
        alertPresent?.show(alertPresent: viewModel)
    }
    // MARK: - Buttons
        /// Кнопка да
    @IBAction private func buttonYes(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
        /// Кнопка нет
    @IBAction private func buttonNo(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}
