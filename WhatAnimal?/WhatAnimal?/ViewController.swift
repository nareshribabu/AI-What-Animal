//
//  ViewController.swift
//  WhatAnimal?
//  Created by Nareshri Babu on 2020-05-03.
//  Copyright © 2020 Nareshri Babu. All rights reserved.
//  This app was created for learning purposes.
//  All images were only used for learning purposes and do not belong to me.
//  All sounds were only used for learning purposes and do not belong to me.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        //allows the user to use the front or rear camera to take pictures
        imagePicker.sourceType = .camera
        
        //allows the user to use images from their photo library
        //imagePicker.sourceType = .photoLibrary
        
        //if you want the users to be able to crop the image then you can set this to true
        imagePicker.allowsEditing = true
        
        navigationItem.title = "What Animal?"
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           
       if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           imageView.image = userPickedImage
           
           //allows us to use core image image
           guard let ciimage = CIImage(image: userPickedImage) else {
               fatalError("Could not convert UIImage to CIImage")
           }
           
           detect(image: ciimage)
           
       }
       
       imagePicker.dismiss(animated: true, completion: nil)
       
       

    }
       
       
       func detect(image: CIImage) {
           
           guard let model = try? VNCoreMLModel(for: ImageClassifier().model) else {
               fatalError("Loading CoreML Model Failed.")
           }
           
           let request = VNCoreMLRequest(model: model) { (request, error) in
               guard let results = request.results as? [VNClassificationObservation] else {
                   fatalError("Model failed to process Image.")
               }
               
               if let firstResult = results.first {
                   
                   if firstResult.identifier.contains("Dog") {
                    self.label.text = "Dog"
                   }
                   else if firstResult.identifier.contains("Cat") {
                    self.label.text = "Cat"
                   }
                   else if firstResult.identifier.contains("Rabbit"){
                    self.label.text = "Rabbit"
                   }
               }
           }
           
           let handler = VNImageRequestHandler(ciImage: image)
           
           do {
               try handler.perform([request])
           }
           catch {
               print(error)
           }
          
       }
    
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
}

