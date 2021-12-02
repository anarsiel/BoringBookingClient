import UIKit

class StyledButton: UIButton {
    init(title: String, frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBlue
        self.setTitle(title, for: .normal)
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
