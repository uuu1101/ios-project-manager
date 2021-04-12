import UIKit

class TodoDetailController: UIViewController {
    private let model: Item?
    private let addOnly: Bool
    
//    private var titleView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.shadowColor = UIColor.gray.cgColor
//        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
//        view.layer.shadowOpacity = 1.0
//        view.layer.shouldRasterize = true
//        view.layer.rasterizationScale = UIScreen.main.scale
//        return view
//    }()
//    private var bodyView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.shadowColor = UIColor.gray.cgColor
//        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
//        view.layer.shadowOpacity = 1.0
//        return view
//    }()
    private var titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .preferredFont(forTextStyle: .headline)
        // 여기서 아직 textField의 frame 이 잡히지 않아서 없을거 같은데 잘되는 이유.. ?
        let paddingView = UIView(frame: CGRect(x: 0,y: 0,width: 20,height: textField.frame.height))
        textField.placeholder = "Title"
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.rightView = paddingView
        textField.rightViewMode = .always
        textField.backgroundColor = .systemBackground
        textField.layer.shadowColor = UIColor.gray.cgColor
        textField.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        textField.layer.shadowOpacity = 1.0
        return textField
    }()
    private var deadlineDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    private var bodyTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .body)
        textView.layer.shadowColor = UIColor.gray.cgColor
        textView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        textView.layer.shadowOpacity = 1.0
        return textView
    }()
    
    private lazy var editBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
    private lazy var cancelBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
    
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
            navigationItem.leftBarButtonItem = cancelBarButtonItem
        } else {
            guard let model = model else { return }
            title = model.state.rawValue.uppercased()
            navigationItem.leftBarButtonItem = editBarButtonItem
            disableInput()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
    }
    
    @objc private func cancelTapped() {
        navigationItem.leftBarButtonItem = editBarButtonItem
        disableInput()
    }
    
    @objc private func editTapped() {
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        activateInput()
    }
    
    @objc private func doneTapped() {
        // 추가 API call
        // 수정 API call
        dismiss(animated: true, completion: nil)
    }
    
    private func disableInput() {
        titleTextField.isUserInteractionEnabled = false
        //bodyTextView.isUserInteractionEnabled = false
        deadlineDatePicker.isUserInteractionEnabled = false
    }
    
    private func activateInput() {
        titleTextField.isUserInteractionEnabled = true
        //bodyTextView.isUserInteractionEnabled = true
        deadlineDatePicker.isUserInteractionEnabled = true
    }
    
    private func setupUI() {
//        titleView.addSubview(titleTextField)
//        bodyView.addSubview(bodyTextView)
//        NSLayoutConstraint.activate([
//            titleTextField.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 5),
//            titleTextField.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -5),
//            titleTextField.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 5),
//            titleTextField.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -5),
//            bodyTextView.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: 10),
//            bodyTextView.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor, constant: -10),
//            bodyTextView.topAnchor.constraint(equalTo: bodyView.topAnchor, constant: 15),
//            bodyTextView.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: -15),
//        ])
        
        view.addSubview(titleTextField)
        view.addSubview(deadlineDatePicker)
        view.addSubview(bodyTextView)
        
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            deadlineDatePicker.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 12),
            deadlineDatePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            deadlineDatePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            //deadlineDatePicker.heightAnchor.constraint(equalToConstant: 150),
            bodyTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            bodyTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            bodyTextView.topAnchor.constraint(equalTo: deadlineDatePicker.bottomAnchor, constant: 8),
            bodyTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}
