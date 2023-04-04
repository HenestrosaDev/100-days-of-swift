//
//  MainView.swift
//  Hangman
//
//  Created by JC on 29/3/23.
//

import UIKit

class MainView: UIView {
    
    // MARK: Properties
    
    private weak var delegate: MainDelegate?
    
    private lazy var livesIv = UIImageView()
    private lazy var livesLb = UILabel()
    private lazy var scoreLb = UILabel()
    private lazy var topScoresBt = UIButton()
    private lazy var hangmanIv = UIImageView()
    private lazy var wordLb = UILabel()
    private lazy var lettersContainer = UIView()
    private lazy var letterBts = [UIButton]()
    
    private let padding: CGFloat = 20
    private let letterChars = [
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R",
        "S", "T", "U", "V", "W", "X", "Y", "Z"
    ]
    
    // MARK: - Initializers
    
    init(delegate: MainDelegate) {
        super.init(frame: .zero)
        
        backgroundColor = .systemBlue
        
        self.delegate = delegate
        
        configureLives()
        configureScoreLb()
        configureTopScoresBt()
        configureHangmanIv()
        configureLetters()
        
        /**
         The actual order of visualization, from top to bottom, is:
         - Score label
         - Hangman image view
         - Word label
         - Letters container
         
         The word label is configured lastly because it's going to be placed in the center Y
         between the hangman image view and letters container view.
         */
        configureWordLb()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func configureLives() {
        addSubview(livesIv)
        addSubview(livesLb)
        
        livesIv.translatesAutoresizingMaskIntoConstraints = false
        livesLb.translatesAutoresizingMaskIntoConstraints = false
        
        livesIv.image = UIImage(systemName: "heart.fill")
        livesIv.tintColor = .white
        
        livesLb.text = "3"
        livesLb.font = UIFont(name: "Marker Felt", size: 18)
        livesLb.textColor = .systemBlue
        
        let size: CGFloat = 40
        
        NSLayoutConstraint.activate([
            livesIv.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: padding
            ),
            livesIv.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: padding
            ),
            livesIv.heightAnchor.constraint(equalToConstant: size),
            livesIv.widthAnchor.constraint(equalToConstant: size)
        ])
        
        NSLayoutConstraint.activate([
            livesLb.centerXAnchor.constraint(equalTo: livesIv.centerXAnchor),
            livesLb.centerYAnchor.constraint(equalTo: livesIv.centerYAnchor, constant: 1),
        ])
    }
    
    private func configureScoreLb() {
        addSubview(scoreLb)
        scoreLb.translatesAutoresizingMaskIntoConstraints = false
        
        scoreLb.textAlignment = .center
        scoreLb.font = UIFont(name: "Marker Felt", size: 26)
        scoreLb.text = "0"
        scoreLb.textColor = .white
        
        NSLayoutConstraint.activate([
            scoreLb.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: padding
            ),
            scoreLb.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -padding
            ),
            scoreLb.centerYAnchor.constraint(
                equalTo: livesIv.centerYAnchor
            ),
            scoreLb.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    private func configureTopScoresBt() {
        addSubview(topScoresBt)
        topScoresBt.translatesAutoresizingMaskIntoConstraints = false
        
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        topScoresBt.setImage(UIImage(systemName: "rosette", withConfiguration: config), for: .normal)
        topScoresBt.tintColor = .white
        
        topScoresBt.addTarget(self, action: #selector(didTapTopScoresBt), for: .touchUpInside)
        
        //let size: CGFloat = 30
        
        NSLayoutConstraint.activate([
            topScoresBt.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -padding
            ),
            topScoresBt.centerYAnchor.constraint(
                equalTo: livesIv.centerYAnchor
            )
        ])
    }
    
    private func configureHangmanIv() {
        addSubview(hangmanIv)
        hangmanIv.translatesAutoresizingMaskIntoConstraints = false
        
        let size: CGFloat = 200
        
        NSLayoutConstraint.activate([
            hangmanIv.centerXAnchor.constraint(equalTo: centerXAnchor),
            hangmanIv.heightAnchor.constraint(equalToConstant: size),
            hangmanIv.widthAnchor.constraint(equalToConstant: size),
            hangmanIv.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: 100
            ),
        ])
    }
    
    private func configureWordLb() {
        addSubview(wordLb)
        wordLb.translatesAutoresizingMaskIntoConstraints = false
        
        wordLb.textAlignment = .center
        wordLb.font = UIFont(name: "Marker Felt", size: 42)
        wordLb.textColor = .white
        
        let guide = UILayoutGuide()
        addLayoutGuide(guide)

        NSLayoutConstraint.activate([
            guide.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            guide.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            guide.topAnchor.constraint(equalTo: hangmanIv.bottomAnchor),
            guide.bottomAnchor.constraint(equalTo: lettersContainer.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            wordLb.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: padding
            ),
            wordLb.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -padding
            ),
            wordLb.centerYAnchor.constraint(
                equalTo: guide.centerYAnchor
            ),
            wordLb.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    private func configureLetters() {
        addSubview(lettersContainer)
        lettersContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonSize = 50
        let rows = 4
        let columns = 7
        
        NSLayoutConstraint.activate([
            lettersContainer.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -padding / 2
            ),
            lettersContainer.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            lettersContainer.heightAnchor.constraint(equalToConstant: CGFloat(buttonSize * rows)),
            lettersContainer.widthAnchor.constraint(equalToConstant: CGFloat(buttonSize * columns)),
        ])
        
        var index = 0
        let letterCount = letterChars.count
        
        for row in 0 ..< rows {
            for column in 0 ..< columns {
                if index >= letterCount { break }
                
                let letter = letterChars[index]
                index += 1
                
                let letterButton = UIButton(type: .system)
                
                letterButton.setTitle(letter, for: .normal)
                letterButton.titleLabel?.font = UIFont(name: "Marker Felt", size: 26)
                letterButton.setTitleColor(.white, for: .normal)
                letterButton.backgroundColor = .systemIndigo
                letterButton.layer.cornerRadius = 10
                
                letterButton.addTarget(self, action: #selector(didTapLetter), for: .touchUpInside)
                
                let frame = CGRect(
                    x: column * buttonSize,
                    y: row * buttonSize,
                    width: buttonSize,
                    height: buttonSize
                )
                letterButton.frame = frame
                
                let buttonPadding = 5
                let bounds = CGRect(
                    x: buttonPadding,
                    y: buttonPadding,
                    width: buttonSize - buttonPadding,
                    height: buttonSize - buttonPadding
                )
                letterButton.bounds = bounds
                
                lettersContainer.addSubview(letterButton)
                letterBts.append(letterButton)
            }
        }
    }
    
    // MARK: Actions
    
    func enableLetterBts() {
        letterBts.forEach {
            $0.isEnabled = true
            $0.alpha = 1
        }
    }
    
    func updateWordLb(word: String) {
        wordLb.text = word
    }
    
    func updateHangmanIv(position: Int) {
        hangmanIv.image = UIImage(named: String(position))
    }
    
    func updateScoreLb(score: Int) {
        scoreLb.text = String(score)
    }
    
    func updateLivesLb(lives: Int) {
        livesLb.text = String(lives)
    }
    
    @objc private func didTapLetter(_ sender: UIButton) {
        guard sender.isEnabled, let letter = sender.titleLabel?.text else { return }
        sender.isEnabled = false
        sender.alpha = 0.5
        delegate?.didTapLetterButton(letter: letter)
    }
    
    @objc private func didTapTopScoresBt() {
        delegate?.didTapTopScoresBt()
    }

}
