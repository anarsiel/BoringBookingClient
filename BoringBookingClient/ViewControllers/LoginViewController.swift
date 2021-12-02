import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    var loginTextField: UITextField!
    var passTextField: UITextField!
    var successAuth: Bool = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginTextField = StyledTextField(
            placeholder: "Your Login",
            frame: CGRect(x: 50, y: 200, width: 300, height: 40)
        )
        loginTextField.delegate = self
        
        self.passTextField = StyledTextField(
            placeholder: "Your Password",
            frame: CGRect(x: loginTextField.frame.minX, y: loginTextField.frame.maxY + 20, width: loginTextField.frame.width, height: loginTextField.frame.height)
        )
        passTextField.delegate = self
        
        let button = StyledButton(title: "login", frame: CGRect(x: loginTextField.frame.minX + loginTextField.frame.width / 2 - 50, y: passTextField.frame.maxY + 20, width: 100, height: 50))
        button.addTarget(self, action: #selector(didLogin), for: .touchUpInside)
        
        self.view.addSubview(loginTextField)
        self.view.addSubview(passTextField)
        self.view.addSubview(button)
    }
    
    @objc func didLogin(sender: UIButton!) {
        let login = loginTextField.text!
        let pass = passTextField.text!
        
        if !setData(login: login, pass: pass) {
            print("NO")
            return
        }
        
        let restaurantsViewController = RestaurantsViewController(userLogin: login)
        restaurantsViewController.modalPresentationStyle = .fullScreen
        self.present(restaurantsViewController, animated: true, completion: nil)
    }
    
    func setData(login: String, pass: String) -> Bool {
        let url = URL(string: "https://boring-booking.herokuapp.com/users/byLogin/\(login)")!

        let (data, _, _) = URLSession.shared.synchronousDataTask(with: url)
        
        guard let _ = data else { return false }
        let decoder = JSONDecoder()
                    
        if let user = try? decoder.decode(User.self, from: data!) {
            return user.password == pass
        }
        return false
    }
}

extension LoginViewController: UITextFieldDelegate {}

class StyledTextField: UITextField {
    init(placeholder: String, frame: CGRect) {
        super.init(frame: frame)
        self.placeholder = placeholder
        self.font = UIFont.systemFont(ofSize: 15)
        self.borderStyle = UITextField.BorderStyle.roundedRect
        self.backgroundColor = .systemFill
        self.autocorrectionType = UITextAutocorrectionType.no
        self.keyboardType = UIKeyboardType.default
        self.returnKeyType = UIReturnKeyType.done
        self.clearButtonMode = UITextField.ViewMode.whileEditing
        self.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        self.autocapitalizationType = .none
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
