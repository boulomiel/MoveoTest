//
//  NotesEditViewController.swift
//  tabsandpage
//
//  Created by Ruben Mimoun on 11/11/2021.
//

import Foundation
import UIKit

class NotesEditViewController : UIViewController, NotesStoryBoard{
    
    @IBOutlet weak var titleField: UITextField?
    @IBOutlet weak var contentField: AuthTextField?
    @IBOutlet weak var removeButtonOutlet: AuthButton?
    @IBOutlet weak var removePicButtont: AuthButton!
    @IBOutlet weak var addedImageView: LoadingImageView?
    @IBOutlet weak var notefieldLabel: AuthTextField!
    let indicator : UIProgressView?  = UIProgressView()
    var uploadingLabel : UILabel?  =  UILabel()
    var imagePicker: ImagePicker!
    var viewModel : NoteCellViewModel?
    let collectionName = "\(Collections.notes)\(FirebaseAuthManager.shared.currentUser!.email)"
    lazy var editHandler =  NoteEditHandler(delegate: self)
    var location : NoteLocation?{
        if let location = LocManager.shared.getCurrentLocation(){
            return NoteLocation(lat: location.coordinate.latitude, long: location.coordinate.longitude)
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(false, animated: true)
        addSaveNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initButtons()
        setupUiWithViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    private func addSaveNavigationItem(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "icloud.and.arrow.up"), style: .plain, target: self, action: #selector(saveNote))
    }
    
    private func initButtons(){
        removePicButtont.isHidden = true
        removePicButtont.backgroundColor = .systemRed
        removeButtonOutlet?.backgroundColor = .systemRed
    }
    
    private func setupUiWithViewModel(){
        if let vm = viewModel{
            removeButtonOutlet?.isHidden = false
            removeButtonOutlet?.backgroundColor = .systemRed
            titleField?.text = vm.observer.value?.title
            contentField?.text = vm.observer.value?.content
            if let imgURL = vm.observer.value?.imageURL{
                addedImageView?.setImage(url: imgURL)
                removePicButtont.isHidden = false
            }else{
                addedImageView?.isHidden = true
            }
        }else{
            removeButtonOutlet?.isHidden = true
        }
    }
    private func uploadPictureNavigationButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: createProgressView())
    }
    
    private func createProgressView() -> UIView{
        let progressViewHolder = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 100)))
        indicator?.progressViewStyle = .default
        
        indicator?.frame =  CGRect(origin: .zero, size: CGSize(width: progressViewHolder.frame.width, height: progressViewHolder.frame.height / 2))
        uploadingLabel?.frame = CGRect(origin: CGPoint(x: 0, y: indicator!.frame.maxY), size: CGSize(width: progressViewHolder.frame.width, height: progressViewHolder.frame.height / 2))
        
        uploadingLabel?.text =  "Uploading..."
        uploadingLabel?.adjustsFontSizeToFitWidth = true
        uploadingLabel?.textAlignment = .center
        uploadingLabel?.numberOfLines = 3
        
        progressViewHolder.addSubview(uploadingLabel!)
        progressViewHolder.addSubview(indicator!)
        return progressViewHolder
    }
    
    private func updateProgressView(progress : Float){
        indicator?.setProgress(progress/100, animated: true)
        self.uploadingLabel?.text = "Uploading \n \(Int(progress))%"
        if Int(progress) == 100{
            UIView.animate(withDuration: 2.0, delay: 0, options: .autoreverse) {[weak self] in
                self?.uploadingLabel?.text = "Uploaded"
                self?.navigationItem.rightBarButtonItem?.customView?.layer.opacity = 0
            } completion: { [weak self]  completed in
                self?.navigationItem.rightBarButtonItem?.customView?.removeFromSuperview()
            }
        }
    }
    
    private func createNote(timeStamp : TimeInterval, url : URL?) -> Note{
        let titleText = titleField?.text ?? FallDown.noTitle
        let contentText = contentField?.text ?? FallDown.noContent
        let saveLocation = location
        
        if var note =  viewModel?.observer.value{
            note.imageURL = url?.absoluteString
            note.title = titleText
            note.content = contentText
            note.location = saveLocation
            return note
        }
        let note = Note(id: UUID().uuidString, title: titleText, content: contentText, location: saveLocation, timestamp: Int(timeStamp), imageURL: url?.absoluteString)
        return note
    }
    
    private func uploadOrUpdate(timeStamp : TimeInterval, url : URL?){
        let note = createNote(timeStamp: timeStamp, url: url)
        if note.timestamp != Int(timeStamp){
            editHandler.updateNote(note: note, collectionName: collectionName)
        }else{
            editHandler.uploadNote(note: note, collectionName: collectionName)
        }
    }
    
    @objc func saveNote(){
        navigationItem.setHidesBackButton(true, animated: true)
        let timeStamp = Date().timeIntervalSince1970
        if let image = addedImageView?.imageHolder.image{
            uploadPictureNavigationButton()
            editHandler.uploadWithImage(image: image)
        }else{
            uploadOrUpdate(timeStamp: timeStamp, url: nil)
        }
    }
    
    @IBAction func removePixAction(_ sender: Any) {
        addedImageView?.imageHolder.image = nil
        addedImageView?.isHidden = true
        removePicButtont.isHidden =  true
    }
    
    @IBAction func removeButtonAction(_ sender: Any) {
        editHandler.removeNote(id: viewModel?.observer.value?.id, collectionName: collectionName)
    }
    
    @IBAction func addAPictureAction(_ sender: UIButton) {
        imagePicker.present(from: sender)
    }
}

extension NotesEditViewController : ImagePickerDelegate{
    func didSelect(image: UIImage?) {
        addedImageView?.imageHolder.image =  image
        removePicButtont.isHidden = false
    }
}


extension NotesEditViewController : NoteHandlerDelegate{
    func removedNote() {
        Router.showError(title: Title.removed, messageString: Message.removed){
            Router.pop()
        }
    }
    
    func addUploadObserver(result : Float) {
        updateProgressView(progress: result)
    }
    
    func imageUploaded(timestamp: TimeInterval, url: URL?) {
        uploadOrUpdate(timeStamp: timestamp, url: url)
    }
    
    func showError(title: String, message: String) {
        Router.showError(title: title, messageString: message){[weak self] in
            self?.navigationItem.setHidesBackButton(false, animated: true)
        }
    }
    
    func onSuccess() {
        Router.pop()
    }
}
