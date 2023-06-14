import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    
    @IBOutlet weak private var image: UIImageView!
    @IBOutlet weak private var questionLable: UILabel!
    @IBOutlet weak private var counterL: UILabel!
    
    // приватные переменные
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    //функция, для отображения первого вопроса
    override func viewDidLoad() {
        super.viewDidLoad()
        let firstQiestion = self.questions[self.currentQuestionIndex]
        let viewModel = self.convert(model: firstQiestion)
        show(quiz: viewModel)
    }
    
    //функция, которая конвертирует мок данные
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return questionStep
    }
    
    // функция, которая выводит следующие вопросы
    private func show(quiz step: QuizStepViewModel) {
        image.image = step.image
        questionLable.text = step.question
        counterL.text = step.questionNumber
    }
    
    //функция, которая показывает следующий вопрос или выводит алерт
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswers)/10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
    }
    
    // функция для вывода аллерта
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //функция, которая выводит результат ответа
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
    }
    
    // Кнопка да
    @IBAction private func buttonYes(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        
        let myButton = sender as? UIButton
        myButton?.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000))
        {
            myButton?.isEnabled = true
        }
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
    
    // Кнопка нет
    @IBAction private func buttonNo(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        
        let myButton = sender as? UIButton
        myButton?.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000))
        {
            myButton?.isEnabled = true
        }
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
}
