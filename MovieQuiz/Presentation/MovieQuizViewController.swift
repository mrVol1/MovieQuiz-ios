import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet weak private var image: UIImageView!
    @IBOutlet weak private var questionLable: UILabel!
    @IBOutlet weak private var counterL: UILabel!
    
    // приватные переменные
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresent: AlertPresent?
    
    // MARK: - Lifecycle
    //функция, для загрузки экрана в памяти
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(delegate: self)
        
        questionFactory?.requestNextQuestion()
        
        alertPresent = AlertPresent(viewController: self)
        
        //менеджер ошибок
        enum FileManagerError: Error {
            case fileDoesntExist
        }
        
        //добавление файла данных в директорию проекта
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "inception.json"
        documentsURL.appendPathComponent(fileName)
        let jsonString = try? String(contentsOf: documentsURL)
        
        // приведение типа данных к типу data
        guard let data = jsonString?.data(using: .utf8) else {
            return
        }
        
        //сериализация данных в json
        func jsonObject(with data: Data, options opt: JSONSerialization.ReadingOptions = []) throws {
                        do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                print(json as Any)
            } catch {
                print("Failed to parse: \(jsonString as Any)")
            }
        }
    }
    
    


    
    // MARK: - QuestionFactoryDelegate
    //метод делегата
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
    // MARK: - MainFunc
    //функция, которая конвертирует мок данные
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        image.image = step.image
        questionLable.text = step.question
        counterL.text = step.questionNumber
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            let message = "Ваш результат: \(correctAnswers)/10"
            let viewModel = AlertModel(
                title: "Этот раунд окончен!",
                message: message,
                buttonText: "Сыграть ещё раз",
                completion: {
                    ()
                }
            )
            alertPresent?.show(alertPresent: viewModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.self.requestNextQuestion()
        }
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
    
    // MARK: - Buttons
    // Кнопка да
    @IBAction private func buttonYes(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
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
        guard let currentQuestion = currentQuestion else {
            return
        }
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
