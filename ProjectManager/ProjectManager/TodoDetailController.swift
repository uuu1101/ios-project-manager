import UIKit

class TodoDetailController: UIViewController {
    private let model: Item?
    private let addOnly: Bool
    
    private var titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.layer.shadowOpacity = 1.0
        return view
    }()
    private var titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .preferredFont(forTextStyle: .headline)
        return textField
    }()
    private var deadlineDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .wheels
        return datePicker
    }()
    private var bodyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.layer.shadowOpacity = 1.0
        return view
    }()
    private var bodyTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .body)
        return textView
    }()
    
    
    init(todo: Item? = nil, addOnly: Bool) {
        model = todo // 이게 먼저 나와야하는 이유.. ?
        self.addOnly = addOnly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupUI()
    }
    
    private func setupNavigationBar() {
        if addOnly {
            title = State.todo.rawValue.uppercased()
        } else {
            title = model!.state.rawValue.uppercased()
        }
    }
    
    private func setupUI() {
        titleView.addSubview(titleTextField)
        bodyView.addSubview(bodyTextView)
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 15),
            titleTextField.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -15),
            titleTextField.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 10),
            titleTextField.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -10),
            bodyTextView.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: 10),
            bodyTextView.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor, constant: -10),
            bodyTextView.topAnchor.constraint(equalTo: bodyView.topAnchor, constant: 15),
            bodyTextView.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: -15),
        ])
        
        view.addSubview(titleView)
        view.addSubview(deadlineDatePicker)
        view.addSubview(bodyView)
        
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            titleView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            //titleView.heightAnchor.constraint(equalToConstant: 50),
            deadlineDatePicker.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 25),
            deadlineDatePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            deadlineDatePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            deadlineDatePicker.heightAnchor.constraint(equalToConstant: 150),
            bodyView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            bodyView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            bodyView.topAnchor.constraint(equalTo: deadlineDatePicker.bottomAnchor, constant: 25),
            bodyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}
