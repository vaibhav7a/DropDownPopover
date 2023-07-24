//
//  PopoverView.swift
//  RBCCompanion
//
//  Created by Vaibhav Jain on 06/07/23.
//  Copyright © 2023 Mayuri Patil. All rights reserved.
//
import UIKit

public enum PopoverDirection {
    case topTobottom
    case bottomToTop
}
public class iOSPopoverView: UIView {
    let textFieldHeight: CGFloat = 35
    private var _shadowView: UIView = UIView()
    private var _contentView: UIView = UIView()
    private var _table: UITableView!
    private var _searchTextField: UITextField!
    private var _headingLabel: UILabel!
    private var _arrowImageView: UIImageView = UIImageView()
    private var _titles: [String]?
    private var _cellCount: Int = 0
    private var _shadowTopAnchor: NSLayoutConstraint?
    private  var dataArray = [String]()
    public  var selectedIndex: Int?
    public var textFieldText = ""
    public var selectedRowColor: UIColor = UIColor.black.withAlphaComponent(0.20)
    public var rowBackgroundColor: UIColor = .white
    public var listHeight: CGFloat = 250
    public var arrowSize: CGFloat = 10
    public var cellIndex: Int = 0
    public var parentBackView: UIView?
    public var headingLabel: UILabel?
    public var placeHolderLabel: CATextLayer?
    public var placeHolderLabelText: String?
    public var isRightToLeft: Bool = false
    public var searchImage: UIImage?
    public var rightArrowImage: UIImage?
    public var clearTextImage: UIImage?
    public var searchTextFieldColor: UIColor?
    public var cellTextFont: UIFont?
    public var headerLabelFont: UIFont?
    public var searchTextFieldFont: UIFont?
    
    public var optionArray = [String]() {
        didSet {
            self.dataArray = self.optionArray
        }
    }
    
    public var searchDefaulttText: String = "" {
        didSet {
            //self.placeholder = self.searchDefaulttText
        }
    }
    
    var searchText: String = String() {
        didSet {
            if searchText == GlobalConstants.defaultString {
                self.setupTextFieldRightView(isCrossShow: false)
                self.updateDataSourceArray()
                self.selectedIndex = self.dataArray.firstIndex(of: self.searchDefaulttText)
            } else {
                //                self.dataArray = optionArray.filter {
                //                    return $0.range(of: searchText, options: .caseInsensitive) != nil
                //                }
                self.setupTextFieldRightView(isCrossShow: true)
                let filteredArray = optionArray.filter { $0.lowercased().contains(searchText.lowercased()) }
                self.dataArray = filteredArray.sorted { (($0.lowercased().index(of: self.searchText.lowercased())!)) < (($1.lowercased().index(of:searchText.lowercased())!))
                }
//                self.dataArray = optionArray
//                    .filter { $0.lowercased().contains(searchText.lowercased()) }
//                    .sorted { ($0.lowercased().hasPrefix(searchText.lowercased()) ? 0 : 1) < ($1.lowercased().hasPrefix(searchText.lowercased()) ? 0 : 1) }
               
                self.selectedIndex = -1
            }
            self.sizeToFit()
            //selectedIndex = 0
            self._table.reloadData()
        }
    }
    
    public var rowHeight: CGFloat = 40
    
    open var popoverViewPadding: CGFloat = 8
    open var popoverDirection: PopoverDirection = .topTobottom
    open var popoverBackgroundColor: UIColor = UIColor.black {
        didSet(newValue) {
            _contentView.backgroundColor = newValue
            if newValue.isEqual(UIColor.white) {
                _shadowView.layer.shadowColor = UIColor.black.cgColor
            } else {
                _shadowView.layer.shadowColor = UIColor.clear.cgColor
            }
        }
    }
    open var textColor = UIColor.white
    open var separatorColor = UIColor.white
    
    public weak var delegate: iOSPopoverViewDelegate?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureSubviews()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    convenience public init(frame: CGRect, titles: [String]) {
    
        self.init(frame: frame)
        resetTitles(titles: titles)
    }
    
    func configureSubviews() {
        self.backgroundColor = .clear
        self.clipsToBounds = false
        _shadowView.translatesAutoresizingMaskIntoConstraints = false
        _shadowView.backgroundColor = UIColor.init(white: 1, alpha: 1)
        _shadowView.layer.cornerRadius = 8.0
        _shadowView.layer.shadowColor = popoverBackgroundColor.cgColor
        _shadowView.layer.shadowOffset = CGSize.zero
        _shadowView.layer.shadowOpacity = 0.3
        _shadowView.layer.shadowRadius = 2
        _shadowView.layer.masksToBounds = false
        addSubview(_shadowView)
        _shadowTopAnchor = _shadowView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        self.addConstraints([
            _shadowTopAnchor!,
            _shadowView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 2),
            _shadowView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -2),
             _shadowView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -2)
        ])
        _contentView.frame = self.frame
        _contentView.translatesAutoresizingMaskIntoConstraints = false
        _contentView.clipsToBounds = true
        _contentView.backgroundColor = popoverBackgroundColor
        _contentView.layer.cornerRadius = 8.0
        addSubview(_contentView)
        
        self.addConstraints([
            _contentView.topAnchor.constraint(equalTo: _shadowView.topAnchor),
            _contentView.leftAnchor.constraint(equalTo: _shadowView.leftAnchor),
            _contentView.bottomAnchor.constraint(equalTo: _shadowView.bottomAnchor),
            _contentView.rightAnchor.constraint(equalTo: _shadowView.rightAnchor)
        ])
    }
    var frameworkBundle:Bundle? {
        let bundleId = "com.framework.bundleId"
        return Bundle(identifier: bundleId)
    }
    
    func configureItemView() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        if self.headingLabel != nil {
            if self.isRightToLeft {
                _headingLabel = UILabel.init(frame: CGRect(x: 0, y: 10, width: _contentView.frame.size.width - 30, height: 20.0))
            } else {
                _headingLabel = UILabel.init(frame: CGRect(x: 30, y: 10, width: _contentView.frame.size.width - 30, height: 20.0))
            }
            _headingLabel.text = self.headingLabel?.text ?? GlobalConstants.defaultString
            _headingLabel.textColor = self.headingLabel?.textColor ?? .black
            _headingLabel.font = self.headingLabel?.font ?? self.headerLabelFont//UIFont.systemFont(ofSize: 14.0)
            _contentView.addSubview(_headingLabel)
        }
        if self.placeHolderLabel != nil {
            if self.isRightToLeft {
                _headingLabel = UILabel.init(frame: CGRect(x: 0, y: 10, width: _contentView.frame.size.width - 30, height: 20.0))
            } else {
                _headingLabel = UILabel.init(frame: CGRect(x: 30, y: 10, width: _contentView.frame.size.width - 30, height: 20.0))
            }
            _headingLabel.text = placeHolderLabelText ?? GlobalConstants.defaultString
            _headingLabel.textColor = self.headingLabel?.textColor ?? UIColor.black
            _headingLabel.font = self.headingLabel?.font ?? self.headerLabelFont//UIFont.systemFont(ofSize: 14.0)
            _contentView.addSubview(_headingLabel)
        }
        _searchTextField = UITextField(frame: CGRect(x: 0, y: (self.headingLabel != nil || self.placeHolderLabel != nil) ? 30 : 0, width: _contentView.frame.size.width, height: textFieldHeight))
        _searchTextField.backgroundColor = UIColor.white
        _searchTextField.textColor = self.searchTextFieldColor
        _searchTextField.tintColor = self.searchTextFieldColor
        _searchTextField.font = self.searchTextFieldFont ?? UIFont.systemFont(ofSize: 14.0)
        _searchTextField.delegate = self
        _contentView.addSubview(_searchTextField)
        if self.isRightToLeft {
            _searchTextField.semanticContentAttribute = .forceRightToLeft
            _searchTextField.textAlignment = .right
        } else {
            _searchTextField.semanticContentAttribute = .forceLeftToRight
            _searchTextField.textAlignment = .left
        }
        self._contentView.addConstraints([
            _searchTextField.topAnchor.constraint(equalTo: _contentView.topAnchor, constant: 0),
            _searchTextField.leftAnchor.constraint(equalTo: _contentView.leftAnchor, constant: 0),
            _searchTextField.rightAnchor.constraint(equalTo: _contentView.rightAnchor, constant: 0),
            _searchTextField.heightAnchor.constraint(equalToConstant: 35.0)
        ])
        
        _table = UITableView.init(frame: CGRect.init(x: 0, y: (self.headingLabel != nil || self.placeHolderLabel != nil) ? textFieldHeight + 30 : textFieldHeight, width: _contentView.frame.size.width, height: _contentView.frame.size.height))
        _contentView.addSubview(_table)
        _table.dataSource = self
        _table.delegate = self
        _table.separatorStyle = .none
        _table.rowHeight = rowHeight
        let bundle  = Bundle(for: DropDownTableViewCell.self  )
        _table.register(UINib(nibName: "DropDownTableViewCell", bundle:  bundle), forCellReuseIdentifier: "DropDownTableViewCell")
        _table.backgroundColor = .white
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if self.selectedIndex != nil && self.selectedIndex! > 4 {
                if self.selectedIndex! + 2 < self.dataArray.count {
                    self._table.scrollToRow(at: IndexPath.init(row: self.selectedIndex! + 2, section: 0), at: .none, animated: false)
                } else {
                    self._table.scrollToRow(at: IndexPath.init(row: self.selectedIndex!, section: 0), at: .none, animated: false)
                }
                
            }
        }
        self._contentView.addConstraints([
            _table.topAnchor.constraint(equalTo: _searchTextField.topAnchor, constant: 0),
            _searchTextField.leftAnchor.constraint(equalTo: _contentView.leftAnchor, constant: 0),
            _searchTextField.rightAnchor.constraint(equalTo: _contentView.rightAnchor, constant: 0),
            _searchTextField.bottomAnchor.constraint(equalTo: _contentView.bottomAnchor, constant: 0)
        ])
        
        let size = self._searchTextField.frame.height
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: size, height: size))
        self._searchTextField.leftView = leftView
        self._searchTextField.leftViewMode = .whileEditing
        let leftContainerView = UIView(frame: leftView.frame)
        self._searchTextField.leftView?.addSubview(leftContainerView)
        let leftCenter = leftContainerView.center
        let searchImage = UIImageView(frame: CGRect(origin: CGPoint(x: 8, y: leftCenter.y - 8), size: CGSize.init(width: 15, height: 15)))
        searchImage.image = self.searchImage
        leftContainerView.addSubview(searchImage)
        self.setupTextFieldRightView(isCrossShow: false)
        sizeToFit()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let heightScreenAccording = UIScreen.main.bounds.size.height - (self.frame.origin.y + keyboardHeight)
            if heightScreenAccording < self.listHeight &&  self.frame.size.height > heightScreenAccording {
                let tableHeightCalculation = (self.headingLabel != nil || self.placeHolderLabel != nil) ? textFieldHeight + 30 : textFieldHeight
                self.frame.size.height = heightScreenAccording
                self._contentView.frame = self.frame
                self._table.frame.size.height = self._contentView.frame.size.height - tableHeightCalculation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    if self.selectedIndex != nil && self.selectedIndex! >= 4 {
                        if self.selectedIndex! + 2 < self.dataArray.count {
                            self._table.scrollToRow(at: IndexPath.init(row: self.selectedIndex! + 2, section: 0), at: .none, animated: false)
                        } else {
                            self._table.scrollToRow(at: IndexPath.init(row: self.selectedIndex!, section: 0), at: .none, animated: false)
                        }
                        
                    }
                }
                self.layoutIfNeeded()
            }
        }
    }
    
    func setupTextFieldRightView(isCrossShow: Bool) {
        let size = self._searchTextField.frame.height
        var rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 25, height: size))
        if isCrossShow {
            rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 60, height: size))
        }
        if self.isRightToLeft {
            self._searchTextField.rightView = rightView
            self._searchTextField.rightViewMode = .whileEditing
            let arrowContainerView = UIView(frame: rightView.frame)
            self._searchTextField.rightView?.addSubview(arrowContainerView)
            let center = arrowContainerView.center
            let arrowImage = UIImageView(frame: CGRect(origin: CGPoint(x: 10, y: center.y - 12), size: CGSize.init(width: 24, height: 24)))
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(dismissButtonTapped))
            arrowImage.isUserInteractionEnabled = true
            _searchTextField.rightView?.addGestureRecognizer(tapGesture)
            arrowImage.image = self.rightArrowImage
            //arrow = Arrow(origin: CGPoint(x: center.x - arrowSize/2, y: center.y - arrowSize/2), size: arrowSize)
            arrowContainerView.addSubview(arrowImage)
            if isCrossShow {
                let crossButton = UIButton(frame: CGRect(origin: CGPoint(x: 35, y: 0), size: CGSize.init(width: 25, height: size)))
                crossButton.setImage(clearTextImage, for: .normal)
                crossButton.addTarget(self, action: #selector(self.crossButtonTapped), for: .touchUpInside)
                crossButton.isEnabled = true
                crossButton.isUserInteractionEnabled = true
                arrowContainerView.addSubview(crossButton)
            }
        } else {
            self._searchTextField.rightView = rightView
            self._searchTextField.rightViewMode = .whileEditing
            let arrowContainerView = UIView(frame: rightView.frame)
            self._searchTextField.rightView?.addSubview(arrowContainerView)
            let center = arrowContainerView.center
            let arrowImage = UIImageView(frame: CGRect(origin: CGPoint(x: isCrossShow ? 30 : -5, y: center.y - 12), size: CGSize.init(width: 24, height: 24)))
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(dismissButtonTapped))
            arrowImage.isUserInteractionEnabled = true
            _searchTextField.rightView?.addGestureRecognizer(tapGesture)
            arrowImage.image = self.rightArrowImage
            //arrow = Arrow(origin: CGPoint(x: center.x - arrowSize/2, y: center.y - arrowSize/2), size: arrowSize)
            arrowContainerView.addSubview(arrowImage)
            if isCrossShow {
                let crossButton = UIButton(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize.init(width: 25, height: size)))
                crossButton.setImage(self.clearTextImage, for: .normal)
                crossButton.addTarget(self, action: #selector(self.crossButtonTapped), for: .touchUpInside)
                crossButton.isEnabled = true
                crossButton.isUserInteractionEnabled = true
                arrowContainerView.addSubview(crossButton)
            }
        }
    }
    @objc func dismissButtonTapped() {
        dismiss()
    }
    
    @objc func crossButtonTapped() {
        self._searchTextField.text = GlobalConstants.defaultString
        searchText = GlobalConstants.defaultString
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        let extraMargin = (self.headingLabel != nil || self.placeHolderLabel != nil) ? 72 : 37
        if self.dataArray.count <= 5 {
            return CGSize(width: size.width, height: CGFloat(self.dataArray.count) * rowHeight + CGFloat(extraMargin)) //37 - textfiled height 35 + padding 2
        }
        return CGSize(width: size.width, height: self.listHeight  + CGFloat(extraMargin)) //37 - textfiled height 35 + padding 2 + 30 heading label
    }
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        let touchInside = super.point(inside: point, with: event)
        guard touchInside else {
            
            dismiss()
            return touchInside
        }
        return touchInside
    }

    public func resetTitles(titles: [String]) {
        _titles = titles
        _cellCount = titles.count
        self.optionArray = titles
        configureItemView()
        self.selectedIndex = self.dataArray.firstIndex(of: self.searchDefaulttText)
        self._table.reloadData()
    }
    
    func setPopoverDirection(direction: PopoverDirection) {
        popoverDirection = direction
        if popoverDirection == .topTobottom {
            _shadowTopAnchor?.constant = 0
            _arrowImageView.transform = CGAffineTransform.identity
            _arrowImageView.top = 0.5
        } else if popoverDirection == .bottomToTop {
            _shadowTopAnchor?.constant = 2
        }
        layoutIfNeeded()
    }
    
    func showFromRect(rect: CGRect) {
        
        let popoverFrame = layoutPopoverFrameFromRect(rect: rect)
        var fromY = popoverFrame.minY
        if popoverDirection == .bottomToTop {
            fromY = popoverFrame.maxY
        }
        self.frame = CGRect(x: popoverFrame.minX, y: fromY, width: popoverFrame.width, height: 0)
        self.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.frame = popoverFrame
            self._searchTextField.becomeFirstResponder()
        }
        self.layoutIfNeeded()
    }
    
    public func showFromSourceView(source: UIView, baseView: UIView) {
        let targedPoints = self.getConvertedPoint(source, baseView: baseView)
        let popoverFrame = layoutPopoverFrameFromRect(rect: CGRect.init(origin: targedPoints, size: source.frame.size))
        var fromY = popoverFrame.minY
        if popoverDirection == .bottomToTop {
            fromY = popoverFrame.maxY
        }
        self.frame = CGRect(x: popoverFrame.minX, y: fromY, width: popoverFrame.width, height: 0)
        self.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.frame = popoverFrame
            self._searchTextField.becomeFirstResponder()
        }
        self.layoutIfNeeded()
    }
    
    func layoutPopoverFrameFromRect(rect: CGRect) -> CGRect {
        
        sizeToFit()
        var originFrame = frame
        let midX = rect.midX
        let halfWidth = originFrame.width/2.0
        let cornerPadding: CGFloat = 4.5
        _arrowImageView.centerX = halfWidth
        
        if midX < halfWidth {
            
            originFrame.origin.x = popoverViewPadding
            _arrowImageView.left = cornerPadding
            if midX > popoverViewPadding {
                _arrowImageView.centerX = max(midX - popoverViewPadding, popoverViewPadding + cornerPadding)
            }
        } else if midX > (superview?.width)! - halfWidth {
            
            originFrame.origin.x = (self.superview?.width)! - originFrame.width - popoverViewPadding
            _arrowImageView.right = originFrame.width - cornerPadding
            if midX < (superview?.width)! - popoverViewPadding {
                _arrowImageView.centerX = min(midX - originFrame.minX, originFrame.width - _arrowImageView.width/2.0 - cornerPadding)
            }
        } else {
            originFrame.origin.x = midX - halfWidth
        }
        
        var fromY = max(0, rect.midY)
        if fromY + originFrame.height < (superview?.height)! {
            
            setPopoverDirection(direction: .topTobottom)
            fromY = max(0, rect.origin.y)
            originFrame.origin.y = fromY

        } else {
            
            setPopoverDirection(direction: .bottomToTop)
            fromY = rect.minY - 5
            originFrame.origin.y = fromY - originFrame.height - popoverViewPadding
        }
        return originFrame
    }
    
    func dismiss() {
        self.parentBackView?.isHidden = false
        self.delegate?.popoverViewDismiss(index: self.cellIndex)
        self.isHidden = true
        self.removeFromSuperview()
        
    }
    
    private func updateDataSourceArray() {
        self.dataArray = self.optionArray
    }
}
extension iOSPopoverView: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownTableViewCell") as? DropDownTableViewCell else {
            return UITableViewCell()
        }
        if indexPath.row != selectedIndex {
            cell.backgroundColor = rowBackgroundColor
        } else {
            cell.backgroundColor = selectedRowColor
        }
        cell.titleLabel.font = self.cellTextFont ?? UIFont.systemFont(ofSize: 14.0)
        cell.titleLabel.text = dataArray[indexPath.row]
        cell.titleLabel.textColor = UIColor.black
        //cell!.accessoryType = (indexPath.row == selectedIndex) && checkMarkEnabled  ? .checkmark : .none
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.rowHeight
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = (indexPath as NSIndexPath).row
        let selectedText = self.dataArray[self.selectedIndex!]
        self.searchDefaulttText = selectedText
        self._searchTextField.text = ""
        self.selectedIndex = 0
        self.delegate?.popoverView(self, index: indexPath.row, selectedText: selectedText, sourceIndex: self.cellIndex)
        self.dismiss()

    }
}
extension iOSPopoverView: UITextFieldDelegate {
    //MARK: UITextFieldDelegate
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //self.dismiss(animated: false)
        dismiss()
        textField.resignFirstResponder()
        return true
    }
    public func  textFieldDidBeginEditing(_ textField: UITextField) {
        self.updateDataSourceArray()
        self.dataArray = self.optionArray
        self.selectedIndex = self.dataArray.firstIndex(of: self.searchDefaulttText)
        self.textFieldText = textField.text ?? GlobalConstants.defaultString
        textField.text = GlobalConstants.defaultString
        self.parentBackView?.isHidden = true
        //self.selectedIndex = nil
        //self.dataArray = self.optionArray
    }
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string != GlobalConstants.defaultString {
            self.searchText = self._searchTextField.text! + string
            //self.selectedIndex = -1
        } else {
            //self.selectedIndex = 0
            let subText = self._searchTextField.text?.dropLast()
            self.searchText = String(subText!)
        }
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            if updatedText == GlobalConstants.defaultString {
                //self.selectedIndex = 0
            } else {
                //self.selectedIndex = -1
            }
        }
        return true
    }
}
