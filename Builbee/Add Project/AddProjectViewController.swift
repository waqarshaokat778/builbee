//
//  AddProjectViewController.swift
//  Builbee
//
//  Created by Khawar Khan on 22/10/2020.
//  Copyright © 2020 KK. All rights reserved.
//

import UIKit
import AlamofireImage
import JEKScrollableSectionCollectionViewLayout
import NVActivityIndicatorView

class AddProjectViewController: BaseClass, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegateFlowLayout, UITextViewDelegate, selectedAreaOfInterestDelegate, getLoacitonDelegate {
    
    func getLoaction(address: String, lat: String, lng: String) {
        self.lat = lat
        self.lng = lng
        addressLbl.text = address
    }
    
    
    func selectedListAreaOfInterest(list: [Int]) {
        
        areaOfInterestList = list
        selectedAreaCount.isHidden = true
        if list.count > 0 {
            selectedAreaCount.isHidden = false
            selectedAreaCount.text = "\(list.count)"
        }
    }
    
    @IBOutlet weak var titleOuterVu: UIView!
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var descriptionTxtVu: UITextView!
    @IBOutlet weak var collectionVu: UICollectionView!
    @IBOutlet weak var selectImgBtn: UIButton!
    @IBOutlet weak var addprojectBtn: UIButton!
    @IBOutlet weak var areaOfInterestContainer: UIView!
    @IBOutlet weak var selectedAreaCount: UILabel!
    
    @IBOutlet weak var addressContainer: UIView!
    @IBOutlet weak var addressLbl: UILabel!
    
    var ImagesDataArray = [UIImage]()
    var areaOfInterestList: [Int] = []
    var imagePicker = UIImagePickerController()
    
    var lat: String = ""
    var lng: String = ""
    var isForUpdate = false
    var isCusotmer = false
    var jobDetail: PostData? = nil
    var projectDetail: ProjectData? = nil
    var loadingIndicator : NVActivityIndicatorView? = nil
    
    var imgListForDel: [String] = []
//    var imgListForAdd: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setCollectionLayout()
        setUpLayout()
        if isForUpdate {
            setDataInFields()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add Description"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func setupcollectionvuLayout(){
        
        let layout = JEKScrollableSectionCollectionViewLayout()
        layout.itemSize = CGSize(width: 200, height: 200);
        layout.headerReferenceSize = CGSize(width: 0, height: 22)
        layout.minimumInteritemSpacing = 5
        collectionVu.collectionViewLayout = layout
    }
    
   func setCollectionLayout() {
               
       let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
       layout.scrollDirection = .horizontal
       layout.itemSize = CGSize(width:200, height: 200)
       collectionVu.isPagingEnabled = true
       collectionVu.collectionViewLayout = layout
    
   }
    
       func setupCollectionvu(){
           let nib = UINib(nibName: "AddProductCollectionViewCell", bundle: nil)
           collectionVu.register(nib, forCellWithReuseIdentifier:
               "AddProductCollectionViewCell")
           
           collectionVu.dataSource = self
           collectionVu.delegate = self
           
       }
       

    
    @IBAction func backBtnTpd(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func selectImgBtnTpd(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            ImagesDataArray.append(image)
            collectionVu.reloadData()
        }
        
            self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func createNewProject(_ sender: Any) {
        
        guard let title = titleTxtField.text, !title.isEmpty, let detail = descriptionTxtVu.text, !detail.isEmpty, let address = addressLbl.text, !address.isEmpty else {
            showAlertWith(title: AlertConstants.Error, message: AlertConstants.AllFieldNotFilled)
            return
        }
        
        var parameters = [:] as [String: Any]
        var imageKey = ""
        
        if isCusotmer {
            print("customer request going to created")
            parameters = ["title": title, "body": detail, "area_of_exp_id[]": areaOfInterestList,"location": address  ] as [String: Any]
            imageKey = "post_img[]"
            
            if isForUpdate {
//                addProject(APIUrl.updateProject, parameters, imageKey)
            } else {
                addProject(APIUrl.post, parameters, imageKey)
            }
            
        } else  {
            print("new Project api call  going to hit")
            parameters = ["project_name": title, "project_detail": detail, "area_of_exp_id[]": areaOfInterestList, "location": address ] as [String: Any]
            
            if isForUpdate {
                imageKey = "img_to_add[]"
                parameters["project_id"] = String(describing: (projectDetail?.id)! as Int) 
                if projectDetail?.project_images?.count ?? 0 > 0 {
                    parameters["img_to_delete[]"] = projectDetail?.project_images
                }
                
                addProject(APIUrl.updateProject, parameters, imageKey)
            } else {
                imageKey = "project_img[]"
                addProject(APIUrl.project, parameters, imageKey)
            }
            
        }
    }
    
    func addProject(_ apiUrl: String, _ parmas: [String: Any],_ imageKey: String) {
        
        self.loadingIndicator?.startAnimating()

        let dict = UserDefaults.standard.object(forKey: "ProfileModal") as? [String: Any]
        let token  = dict?["token"] as! String
        print(apiUrl, parmas)
        CommonAPIs.shared().uploadImage(apiUrl: apiUrl, parameters: parmas, token: token, imagesData: ImagesDataArray, imageKey: imageKey) { (response) in
            
            self.loadingIndicator?.stopAnimating()
            
            let alertController = UIAlertController(title: response.status ?? false ? AlertConstants.Success : "Request Failed", message: response.status ?? false ? "Data Save Successfully." : AlertConstants.SomeThingWrong, preferredStyle: .alert)

                // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                self.resetField()
                self.dismiss(animated: true)
                
            }

                // Add the actions
                alertController.addAction(okAction)

                // Present the controller
                self.present(alertController, animated: true, completion: nil)
            
            
        } onFailure: { (error) in
            self.loaderIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: error?.localizedDescription ?? AlertConstants.SomeThingWrong )
        } onError: { (errorMessage) in
            self.loaderIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: errorMessage?.description ?? AlertConstants.SomeThingWrong )
        }
      
    }
    
    func getAreaofInterestList() {
        
        loaderIndicator?.startAnimating()
        AreaOfInterestAPIs.shared().getUserList(token: getToken()) { (result) in
            self.loaderIndicator?.stopAnimating()
            if result?.status ?? false {
                let getAreaOfListId : [Int] = (result?.data?
                                        .enumerated()
                                        .map { result  in
                                            return result.element.id
                                        }) as! [Int]
                print("lis",getAreaOfListId)
                self.areaOfInterestList = getAreaOfListId
                
                if self.areaOfInterestList.count > 0 {
                    self.selectedAreaCount.isHidden = false
                    self.selectedAreaCount.text = "\(self.areaOfInterestList.count)"
                }
                
                
            } else {
                self.showAlertWith(title: AlertConstants.Error, message: AlertConstants.SomeThingWrong)
            }
        } onFailure: { (error) in
            self.loaderIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: error?.localizedDescription ?? AlertConstants.SomeThingWrong )
        } onError: { (errorMessage) in
            self.loaderIndicator?.stopAnimating()
            self.showAlertWith(title: AlertConstants.Error, message: errorMessage!)
        }


    }
    
    func setUpLayout() {
        
        loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2 - 25, y: self.view.frame.height/2 - 50, width: 50, height: 50), type: .ballScaleRippleMultiple, color: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), padding: 1)
        view.addSubview(loadingIndicator!)
        
        addprojectBtn.layer.cornerRadius = 5
        addprojectBtn.layer.borderWidth = 3
        addprojectBtn.layer.borderColor = UIColor().colorForHax("#FDC11B").cgColor
        
        selectImgBtn.layer.cornerRadius = 5
        selectImgBtn.layer.borderWidth = 3
        selectImgBtn.layer.borderColor = UIColor().colorForHax("#FDC11B").cgColor
        
        selectedAreaCount.isHidden = true
        
        setUpShadow(view: titleOuterVu)
        setUpShadow(view: descriptionTxtVu)
        setUpShadow(view: areaOfInterestContainer)
        setUpShadow(view: addressContainer)
        
        // Do any additional setup after loading the view.
        setupCollectionvu()
        setCollectionLayout()
        
        descriptionTxtVu.text = "Add Description"
        descriptionTxtVu.textColor = UIColor.lightGray
        descriptionTxtVu.delegate = self
        
        let areaOfInterestTap = UITapGestureRecognizer(target: self, action: #selector(self.showAreaOfExperience(_:)))
        areaOfInterestContainer.isUserInteractionEnabled = true
        self.areaOfInterestContainer.addGestureRecognizer(areaOfInterestTap)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        addressContainer.isUserInteractionEnabled = true
        addressContainer.addGestureRecognizer(tap)
    }
    
    @objc func showAreaOfExperience(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "fromAddProjrct", sender: self)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GetAddressVC") as! GetAddressVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setUpShadow(view: UIView) {
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 8
    }
    
    func setDataInFields() {
        addprojectBtn.setTitle("Update", for: .normal)
        titleTxtField.text = projectDetail?.project_name
        descriptionTxtVu.text = projectDetail?.project_detail
        if projectDetail?.project_images?.count ?? 0 > 0 {
            let getImageList = (projectDetail?.project_images?
                             .enumerated()
                                    .map { try! UIImage(data: Data(contentsOf: URL(string: $0.element)!))! })!
            
            
            DispatchQueue.main.async {
                self.ImagesDataArray.removeAll()
                self.ImagesDataArray = getImageList
                self.collectionVu.reloadData()
            }
        }
        
//            getAreaofInterestList()
   }
   
    func resetField() {
        self.titleTxtField.text = ""
        self.descriptionTxtVu.text = ""
        self.addressLbl.text = "Address"
        self.ImagesDataArray = []
        self.areaOfInterestList = []
        self.selectedAreaCount.isHidden = true
        self.collectionVu.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromAddProjrct" {
            let vc = segue.destination as? AreaOfInterestListVC
            vc?.delegate = self
            vc?.selectedUser = areaOfInterestList
            print(areaOfInterestList)
        }
    }
}


extension AddProjectViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
         return 1
    }
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImagesDataArray.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionVu.dequeueReusableCell(withReuseIdentifier: "AddProductCollectionViewCell", for: indexPath) as! AddProductCollectionViewCell
         cell.contentView.layer.cornerRadius = 5
         cell.contentView.layer.borderWidth = 3
         cell.contentView.layer.borderColor = UIColor().colorForHax("#FFFFFF").cgColor
         cell.deleteBtn.tag = indexPath.item
         cell.deleteBtn.addTarget(self, action: #selector(deleteBtnTapped), for: .touchUpInside)
      
         cell.imgVu.image = ImagesDataArray[indexPath.item]
     
     return cell

    }
  
    @objc func deleteBtnTapped(sender: UIButton!) {
        ImagesDataArray.remove(at: sender.tag)
        collectionVu.reloadData()
    }
    
}
