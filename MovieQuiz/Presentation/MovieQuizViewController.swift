import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak private var image: UIImageView!
    @IBOutlet weak private var questionLable: UILabel!
    @IBOutlet weak private var counterL: UILabel!
    
    @IBAction private func buttonNo(_ sender: Any) {
    }
    
    
    @IBAction private func buttonYes(_ sender: Any) {
    }
    struct QuizQuestion {
        // строка с названием фильма,
        // совпадает с названием картинки афиши фильма в Assets
        let image: String
        // строка с вопросом о рейтинге фильма
        let text: String
        // булевое значение (true, false), правильный ответ на вопрос
        let correctAnswer: Bool
    }
    
    private let questions: [QuizQuestion] = [
        QuizQuestion (image: "The Godfather",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true),
        QuizQuestion (image: "The Dark Knight",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true),
        QuizQuestion (image: "Kill Bill",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true),
        QuizQuestion (image: "The Avengers",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true),
        QuizQuestion (image: "Deadpool",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true),
        QuizQuestion (image: "The Green Knight",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true),
        QuizQuestion (image: "Old",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: false),
        QuizQuestion (image: "The Ice Age Adventures of Buck Wild",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: false),
        QuizQuestion (image: "Tesla",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: false),
        QuizQuestion (image: "Vivarium",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: false)
    ]
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    struct QuizStepViewModel {
      // картинка с афишей фильма с типом UIImage
      let image: UIImage
      // вопрос о рейтинге квиза
      let question: String
      // строка с порядковым номером этого вопроса (ex. "1/10")
      let questionNumber: String
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        init?(named name: String)
    }
}
