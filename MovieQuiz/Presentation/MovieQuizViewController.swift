import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    @IBOutlet weak private var image: UIImageView!
    @IBOutlet weak private var questionLable: UILabel!
    @IBOutlet weak private var counterLable: UILabel!
    @IBOutlet weak private var loader: UIActivityIndicatorView!
    @IBOutlet weak private var buttonYes: UIButton!
    @IBOutlet weak private var buttonNo: UIButton!
    var correctAnswers: Int = 0
    
    internal var alertPresent: AlertPresent?
    private var presenter: MovieQuizPresenter?
    private var alertPresenterError: AlertPresenterError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresent = AlertPresentImplementation(viewController: self)
        presenter = MovieQuizPresenter(viewController: self, statisticServiceFactory: StatisticServiceFactory(), alertPresent: alertPresent)
    }
    
    // Loader Indicator
    func showLoadingIndicator() {
        loader?.hidesWhenStopped = true
        loader?.startAnimating()
    }
    
    func hideLoadingIndicator() {
        loader?.hidesWhenStopped = true
        loader?.stopAnimating()
    }
    
    // Show Alert Error for Data Response
    func showImageLoadingError() {
        hideLoadingIndicator()
        let alert = AlertModelError(
            title: "Ошибка загрузки изображения",
            message: "Не удалось загрузить постер фильма",
            buttonText: "Попробовать еще раз"
        ) { [weak self] in
            self?.alertPresenterError?.restartGame()
        }
        alertPresenterError?.showImageError(alertPresentError: alert)
    }
    
    func showNetworkError(message: String) {
        let alert = UIAlertController(
            title: "Network Error",
            message: message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MainFunc
    func show(quiz step: QuizStepViewModel) {
        DispatchQueue.main.async {
            self.image.image = step.image
            self.questionLable.text = step.question
            self.counterLable.text = step.questionNumber
        }
    }
    
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        image.layer.masksToBounds = true
        image.layer.borderWidth = 8
        image.layer.borderColor = isCorrect ? UIColor.green.cgColor : UIColor.red.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.presenter?.showNextQuestionOrResults()
            self.image.layer.borderWidth = 0
        }
    }
    
    func showQuizResult() {
        presenter?.showQuizResult()
    }
    
    func showButtonState(isButtonYesEnabled: Bool, isButtonNoEnabled: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.buttonYes.isEnabled = isButtonYesEnabled
            self?.buttonNo.isEnabled = isButtonNoEnabled
        }
    }
    
    // ButtonsView
    @IBAction private func buttonYes(_ sender: UIButton) {
        presenter?.buttonYes()
    }
    
    @IBAction private func buttonNo(_ sender: UIButton) {
        presenter?.buttonNo()
    }
}
