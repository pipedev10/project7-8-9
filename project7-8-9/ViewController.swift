//
//  ViewController.swift
//  project7-8-9
//
//  Created by Pipe Carrasco on 04-09-21.
//

import UIKit

class ViewController: UIViewController {
    
    let englishAlphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    var wordKey = ""
    // MARK: - Properties
    var oportunitieInitial = 7
    lazy var levelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "Level: \(level)"
        return label
    }()
    
    let letterButtonView: UIView = {
        let letterButton = UIView()
        letterButton.translatesAutoresizingMaskIntoConstraints = false
        return letterButton
    }()
    
    let letterAnswersBtnView: UIView = {
        let letterAnswerView = UIView()
        letterAnswerView.translatesAutoresizingMaskIntoConstraints = false
        return letterAnswerView
    }()
    
    lazy var oportunities: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "\(oportunitieInitial)"
        label.font = UIFont.systemFont(ofSize: 80)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var letterButtons = [UIButton]()
    var score = 0
    var level = 0 {
        didSet{
            levelLabel.text = "Level: \(level)"
        }
    }
    var isWinner = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        performSelector(inBackground: #selector(loadLevel), with: nil)
        setupConstraint()
    }
    
    @objc func loadLevel(){
        var words = [String]()
        if let levelFileURL = Bundle.main.url(forResource: "level", withExtension: "txt"){
            if let levelContents = try? String(contentsOf: levelFileURL){
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    //let answer = parts[0]
                    words.append(parts[0])
                }
                words.shuffle()
                wordKey = words[0].uppercased()
                print(wordKey)
            }
        }
        
    }
    
    func setupConstraint(){
        view.addSubview(levelLabel)
        NSLayoutConstraint.activate([
            levelLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            levelLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
        
        view.addSubview(oportunities)
        NSLayoutConstraint.activate([
            oportunities.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 100),
            oportunities.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(letterAnswersBtnView)
        NSLayoutConstraint.activate([
            letterAnswersBtnView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            letterAnswersBtnView.topAnchor.constraint(equalTo: oportunities.bottomAnchor, constant: 100),
            letterAnswersBtnView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100)
        ])
        
        let width = 100
        let height = 100
        
        for row in 0..<wordKey.count{
            let letterButton = UIButton(type: .system)
            letterButton.setTitle("?", for: .normal)
            letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 38)
            letterButton.layer.borderWidth = 1
            letterButton.layer.borderColor = UIColor.black.cgColor
            letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            let frame = CGRect(x: row * width, y: 0 * height, width: width, height: height)
            
            letterButton.frame = frame
            letterAnswersBtnView.addSubview(letterButton)
            letterButtons.append(letterButton)
        }
        setupKeyboardGame()
    }
    
    func setupKeyboardGame(){
        let width = 150
        let height = 80
        var counterLetter = 0
        view.addSubview(letterButtonView)
        NSLayoutConstraint.activate([
            letterButtonView.widthAnchor.constraint(equalToConstant: 800),
            letterButtonView.heightAnchor.constraint(equalToConstant: 350),
            letterButtonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            letterButtonView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        for row in 0..<4{
            for column in 0..<5{
                if counterLetter < englishAlphabet.count {
                    let letterButton = UIButton(type: .system)
                    letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
                    //letterButton.setTitle("WWW", for: .normal)
                    let letter  = englishAlphabet[counterLetter].uppercased()
                    letterButton.setTitle(letter, for: .normal)
                    letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                    letterButton.layer.borderWidth = 1
                    letterButton.layer.borderColor = UIColor.systemBlue.cgColor
                    let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                    
                    letterButton.frame = frame
                    letterButtonView.addSubview(letterButton)
                    letterButtons.append(letterButton)
                    counterLetter += 1
                }
            }
        }
    }
    
    
    
    @objc func letterTapped(_ sender: UIButton){
        guard let buttonTitle = sender.titleLabel?.text else {return}
        var isFound = false
        print("wordKey = \(wordKey)")
        for (index, letter) in wordKey.enumerated() {
            if letter == Character(buttonTitle) {
                letterButtons[index].setTitle(buttonTitle, for: .normal)
                isFound = true
                score += 1
                sender.isHidden = true
            }else{
                
            }
        }
        if !isFound {
            oportunitieInitial -= 1
            oportunities.text = "\(oportunitieInitial)"
        }
        checkWinnerOrLoser()
    }
    
    func checkWinnerOrLoser(){
        if oportunitieInitial == 0 {
            showMessageResult(title: "Result", message: "you're loser")
        }else if score == wordKey.count {
            isWinner = true
            showMessageResult(title: "Result", message: "you're winner")
        }
    }
    
    func showMessageResult(title: String, message: String, action: UIAlertAction! = nil){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: isWinner ? reloadOrLevelUp : nil))
        present(ac, animated: true)
    }
    
    func reloadOrLevelUp(action: UIAlertAction! = nil){
        print("de pana xD")
        if(isWinner){
            level += 1
        }
        
    }
}

