import UIKit

class ViewController: UIViewController {

    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var winLabel: UILabel!

    let allEmojis = ["🐶", "🐱", "🦊", "🐼", "🐸", "🐵", "🦁", "🐷"]

    var emojis: [String] = []
    var firstIndex: Int? = nil
    var secondIndex: Int? = nil
    var foundPairs = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        buttons.sort { $0.tag < $1.tag }

        let fontSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 120 : 70
        for button in buttons {
            button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        }

        newGame()
    }

    func newGame() {
        let shuffled = allEmojis.shuffled()
        let emoji1 = shuffled[0]
        let emoji2 = shuffled[1]
        emojis = [emoji1, emoji1, emoji2, emoji2].shuffled()

        firstIndex = nil
        secondIndex = nil
        foundPairs = 0
        winLabel.isHidden = true

        for button in buttons {
            button.setTitle("", for: .normal)
            button.isEnabled = true
        }
    }

    @IBAction func cardTapped(_ sender: UIButton) {
        guard let index = buttons.firstIndex(of: sender) else { return }

        if !sender.isEnabled || index == firstIndex || index == secondIndex {
            return
        }

        if let first = firstIndex, let second = secondIndex {
            buttons[first].setTitle("", for: .normal)
            buttons[second].setTitle("", for: .normal)
            firstIndex = nil
            secondIndex = nil
        }

        UIView.performWithoutAnimation {
            sender.setTitle(emojis[index], for: .normal)
            sender.layoutIfNeeded()
        }

        if firstIndex == nil {
            firstIndex = index
        } else {
            secondIndex = index

            if emojis[firstIndex!] == emojis[index] {
                buttons[firstIndex!].isEnabled = false
                sender.isEnabled = false
                firstIndex = nil
                secondIndex = nil

                if buttons.allSatisfy({ !$0.isEnabled }) {
                    winLabel.isHidden = false
                }
            }
        }
    }

    @IBAction func restartTapped(_ sender: UIButton) {
        newGame()
    }
}
