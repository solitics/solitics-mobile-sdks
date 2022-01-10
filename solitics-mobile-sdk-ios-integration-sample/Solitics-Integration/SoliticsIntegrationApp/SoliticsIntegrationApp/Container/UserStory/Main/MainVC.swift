//
//  MainVC.swift
//  SoliticsDevelopmentApp
//
//  Created by Serg Liamthev on 04.11.2020.
//
import UIKit
///
///
///
final class MainVC : BaseViewController
{
    private lazy var contentView: MainVCView   = MainVCView()
    private lazy var  scrollView: UIScrollView = UIScrollView()
    
    private lazy var   viewModel: MainVCViewModel = MainVCViewModel()
    
    // MARK: - Life cycle
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .default }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Private functions
    private func setup()
    {
        setupLayout()
        setupKeyboardObserving()
        setupNavBar()
        contentView.delegate = self
        viewModel.delegate = self
        viewModel.setupSocketConnection()
    }
    
    private func setupNavBar()
    {
        navigationItem.title = "SDK Sample"
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    private func setupLayout()
    {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let containerViewTopConstrains: NSLayoutConstraint
        if #available(iOS 11.0, *)
        {
            containerViewTopConstrains = scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16)
        }
        else
        {
            containerViewTopConstrains = scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16)
        }
        
        let containerViewBottomConstrains: NSLayoutConstraint
        if #available(iOS 11.0, *)
        {
            containerViewBottomConstrains = scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        }
        else
        {
            containerViewBottomConstrains = scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16)
        }
        
        let containerViewConstraints: [NSLayoutConstraint] = [
            containerViewTopConstrains, containerViewBottomConstrains,
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(containerViewConstraints)
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentViewHeightConstraint: NSLayoutConstraint = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0)
        contentViewHeightConstraint.priority = .defaultLow
        
        let contentViewConstraints: [NSLayoutConstraint] = [
            contentView.topAnchor     .constraint(equalTo: scrollView.topAnchor     , constant: 0),
            contentView.leadingAnchor .constraint(equalTo: scrollView.leadingAnchor , constant: 0),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            contentView.bottomAnchor  .constraint(equalTo: scrollView.bottomAnchor  , constant: 0),
            contentView.widthAnchor   .constraint(equalTo: scrollView.widthAnchor   , constant: 0),
            contentViewHeightConstraint
        ]
        NSLayoutConstraint.activate(contentViewConstraints)
    }
    
}
// MARK: - Keyboard handling
extension MainVC
{
    private func setupKeyboardObserving()
    {
        let content = [
            (selector: #selector(MainVC.keyboardDidShow ), name: UIResponder.keyboardDidShowNotification ),
            (selector: #selector(MainVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification)
        ]
        
        let strong = self
        let center = NotificationCenter.default
        content.forEach { center.addObserver(strong, selector: $0.selector, name: $0.name, object: nil) }
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification)
    {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
     
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        let height: CGFloat = keyboardFrame.size.height
        let contentInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
        adjustScrollViewInsets(contentInset)
        
        guard let view = contentView.getFirstResponser() else {
            return
        }
        scrollToRect(view.frame)
    }

    @objc
    private func keyboardDidShow(notification: NSNotification)
    {
        let info = (notification as NSNotification).userInfo
        let value = info?[UIResponder.keyboardFrameEndUserInfoKey]
        guard let rawFrame = (value as? NSValue)?.cgRectValue else {
            return
        }
        let keyboardFrame = self.view.convert(rawFrame, from: nil)
        
        let height: CGFloat = keyboardFrame.size.height
        let contentInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
        
        adjustScrollViewInsets(contentInset)
        
        guard let view = contentView.getFirstResponser() else {
            return
        }
        scrollToRect(view.frame)
    }
    
    @objc
    private func keyboardWillHide(notification: NSNotification)
    {
        let inset: UIEdgeInsets = UIEdgeInsets.zero
        adjustScrollViewInsets(inset)
    }
    
    private func adjustScrollViewInsets(_ inset: UIEdgeInsets)
    {
        scrollView.contentInset = inset
        scrollView.scrollIndicatorInsets = inset
    }
    
    private func scrollToRect(_ rect: CGRect)
    {
        let options: UIView.AnimationOptions = [.curveEaseOut, .beginFromCurrentState, .preferredFramesPerSecond60, .allowUserInteraction, .allowAnimatedContent]
        UIView.animate(withDuration: CATransaction.animationDuration(), delay: 0.0, options: options, animations: { [weak self] in
            
            self?.scrollView.scrollRectToVisible(rect, animated: false)
            
        }, completion: { _ in })
    }
}

// MARK: - MainVCViewDelegate
extension MainVC: MainVCViewDelegate
{
    func didTapSendEventButton()
    {
        showProgress()
        let inputData: OnEmitEventUserInput = contentView.getUserInput()
        viewModel.sendEventRequest(inputData: inputData)
    }
    
    func didTapLogOutButton()
    {
        guard let navVC = self.navigationController else {
            return
        }
        viewModel.signOut()
        AppRouter.popToSignInScreen(from: navVC)
    }
}

// MARK: - MainVCViewModelDelegate
extension MainVC: MainVCViewModelDelegate
{
    func didReceiveError(_ error: Error)
    {
        executeOnMain { [weak self] in
            
            guard let `self` = self else { return }
            self.hideProgress()
            self.showToast(error.localizedDescription)
        }
    }
    
    func didReceiveEventResponse(response: String)
    {
        
        executeOnMain { [weak self] in
            
            guard let `self` = self else { return }
            self.hideProgress()
            self.showToast(response)
        }
    }
}
