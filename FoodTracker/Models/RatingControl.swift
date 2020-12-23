import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    //MARK: -Properties
    private var ratingButtons = [UIButton]()
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0){
        didSet{
            setupButtons()
        }
    }
    @IBInspectable var starCount = 5 {
        didSet{
            setupButtons()
        }
    }
    var rating  = 0{
        didSet{
            updateButtonState()
        }
    }
    
    
    //MARK: -Initiallizers
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: -Button Actions
    @objc func ratingButtonTapped(button: UIButton){
        
        guard let index = ratingButtons.firstIndex(of: button) else{
            fatalError("The button \(button) is not in \(ratingButtons)")
        }
        
        let selectedRating = index+1
        if(selectedRating == rating){
            rating = 0
        }else{
            rating = selectedRating
        }
    }
    
    //MARK: -Private Methods
    private func setupButtons(){
        
        for button in ratingButtons{
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        let bundle = Bundle(for: type(of: self))
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let highlighted  = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0..<starCount {
            let button = UIButton()
            
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlighted, for: .highlighted)
            button.setImage(highlighted, for: [.highlighted, .selected])
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            button.accessibilityLabel = "Set \(index+1) star rating"
            
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            addArrangedSubview(button)
            ratingButtons.append(button)
        }
        
        updateButtonState()
    }
    
    private func updateButtonState(){
        
        for (index, button) in ratingButtons.enumerated() {
            if(index < rating){
                button.isSelected = true
                
                let hintString: String?
                if(rating == index+1){
                    hintString = "Tap to reset the rating to zero."
                }else{
                    hintString = nil
                }
                
                let valueString: String
                switch rating {
                case 0:
                    valueString = "No rating set."
                case 1:
                    valueString = "1 star set."
                default:
                    valueString = "\(rating) stars set."
                }
                
                button.accessibilityHint = hintString
                button.accessibilityValue = valueString
            }else{
                button.isSelected = false
            }
        }
    }
    
}
