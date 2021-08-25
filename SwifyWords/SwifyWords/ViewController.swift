//
//  ViewController.swift
//  SwifyWords
//
//  Created by Logesh Palani on 24/08/21.
//

import UIKit

class ViewController: UIViewController {

    var scoreLabel: UILabel!
    var answerLabel: UILabel!
    var cluesLabel: UILabel!
    var currentAnswer: UITextField!
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score = 0 {
        didSet{
            scoreLabel.text = "Score \(score)"
        }
    }
    var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.text = "Score: 0"
        scoreLabel.textAlignment = .right
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.text = "Clues"
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.textAlignment = .left
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.numberOfLines = 0
        view.addSubview(cluesLabel)
            
        answerLabel = UILabel()
        answerLabel.text = "Score"
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answerLabel.textAlignment = .right
        answerLabel.font = UIFont.systemFont(ofSize: 24)
        answerLabel.numberOfLines = 0
        view.addSubview(answerLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letter to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.setTitle("SUBMIT", for: .normal)
        submit.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(submit)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        submit.layer.borderWidth = 1
        submit.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0, right: 20.0)
        submit.layer.borderColor = UIColor.darkGray.cgColor
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("Clear", for: .normal)
        view.addSubview(clear)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        clear.layer.borderWidth = 1
        clear.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0, right: 20.0)
        clear.layer.borderColor = UIColor.darkGray.cgColor
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        let width = 150
        let height = 80
        
        for row in 0..<4 {
            for col in 0..<5 {
                let button = UIButton(type: .system)
                button.setTitle("WWW", for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                
                button.setTitle("WWW", for: .normal)
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                button.frame = frame
                button.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.systemBlue.cgColor
                buttonsView.addSubview(button)
                letterButtons.append(button)
            }
        }
        
        NSLayoutConstraint.activate([
        
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.widthAnchor.constraint(greaterThanOrEqualTo: view.widthAnchor, multiplier: 0.6, constant: -100),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            
            answerLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answerLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor,constant: -100),
            answerLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4),
            answerLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.topAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 20),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
           
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 30),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: clear.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setLevel()
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let answer = sender.titleLabel?.text else {
            return
        }
        currentAnswer.text = currentAnswer.text?.appending(answer)
        sender.isHidden = true
        activatedButtons.append(sender)
        
    }
    @objc func submitTapped(_ sender:UIButton){
        guard let answerText = currentAnswer.text else {
            return
        }
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()
            
            var splitAnswers = answerLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answerLabel.text = splitAnswers?.joined(separator: "\n")
            
            currentAnswer.text = ""
            score += 1
            let decimal = CharacterSet.decimalDigits
            if answerLabel.text?.rangeOfCharacter(from: decimal) == nil {
                let ac = UIAlertController(title: "Well done", message: "Are you ready for next level", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
            return
        }
        
        let ac = UIAlertController(title: "Wong answer", message: "Please think a minute and answer", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        score -= 1
        clearTapped(sender)
    }
    
    func levelUp(_ :UIAlertAction) {
        level += 1
        
        solutions.removeAll()
        setLevel()
        
        for btn in letterButtons {
            btn.isHidden = false
        }
    }
    
    @objc func clearTapped(_ sender:UIButton) {
        currentAnswer.text = ""
        
        for button in activatedButtons {
            button.isHidden = false
        }
        activatedButtons.removeAll()
    }
    func setLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let fileLevelUrl = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: fileLevelUrl) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index+1). \(clue)\n"
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answerLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterBits.shuffle()
        
        if letterBits.count == letterButtons.count {
            for i in 0..<letterBits.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
}

