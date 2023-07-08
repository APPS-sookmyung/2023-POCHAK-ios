//
//  CameraViewController.swift
//  pochak
//
//  Created by 장나리 on 2023/07/02.
//

import UIKit
import AVFoundation
import SwiftUI


class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var previewView: UIView!
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!

    @IBOutlet weak var flashbtn: UIButton!
    @IBAction func flashBtn(_ sender: Any) { //flash 버튼 클릭시
        
    }
    @IBAction func captureBtn(_ sender: Any) { //카메라 버튼 클릭시
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
                stillImageOutput.capturePhoto(with: settings, delegate: self)
        
        
        guard let toupload = self.storyboard?.instantiateViewController(withIdentifier: "UploadViewController") else {return}
        self.navigationController?.pushViewController(toupload, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //네비게이션바 세팅
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes=[.font:UIFont.boldSystemFont(ofSize: 20)]
        navigationItem.standardAppearance = appearance
        navigationController?.navigationBar.topItem?.title = "포착하기"



        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Setup your camera here...
        captureSession = AVCaptureSession()
        captureSession.startRunning()
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        
        func setupLivePreview() {
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer.videoGravity = .resizeAspectFill

            videoPreviewLayer.connection?.videoOrientation = .portrait
            previewView.layer.addSublayer(videoPreviewLayer)
            
            DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
                self.captureSession.startRunning()
                DispatchQueue.main.async {
                    self.videoPreviewLayer.frame = self.previewView.bounds
                }
            }
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation() //이미지 저장 부분
            else { return }
        
        let image = UIImage(data: imageData)
        
    }
}
