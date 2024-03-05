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
    var photoData = Data(count: 0)
    
    @IBOutlet weak var flashBtnBg: UIButton!
    
    var flashMode: AVCaptureDevice.FlashMode = .off
    
    let hapticImpact = UIImpactFeedbackGenerator()
    
    var currentZoomFactor: CGFloat = 1.0
    var lastScale: CGFloat = 1.0
    
    @Published var recentImage: UIImage?
    @Published var isCameraBusy = false
    
    @Published var showPreview = false
    @Published var shutterEffect = false
    @Published var isFlashOn = false
    
    @IBOutlet weak var flashbtn: UIButton!
    @IBAction func flashBtn(_ sender: Any) { //flash 버튼 클릭시
        switchFlash()
        print("flash")
    }
    @IBAction func captureBtn(_ sender: Any) { //카메라 버튼 클릭시
        if isCameraBusy == false {
            hapticImpact.impactOccurred()
            withAnimation(.easeInOut(duration: 0.1)) {
                shutterEffect = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    self.shutterEffect = false
                }
            }
            
            let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            photoSettings.flashMode = self.flashMode
            
            
            stillImageOutput.capturePhoto(with: photoSettings, delegate: self)
            
            
            print("[Camera]: Photo's taken")
            print("[CameraViewModel]: Photo captured!")
        } else {
            print("[CameraViewModel]: Camera's busy.")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Pretendard-bold", size: 20)!]
        self.navigationItem.title = "포착하기"
        
 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Setup your camera here...
        requestAndCheckPermissions()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else {
                return
            }
        
////         이미지 저장 코드 (옵션)
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//        print("[Camera]: Photo saved")
        
        // 이미지 전달 및 페이지 전환
        let uploadViewController = storyboard?.instantiateViewController(withIdentifier: "UploadViewController") as! UploadViewController
        uploadViewController.receivedImage = image
        navigationController?.pushViewController(uploadViewController, animated: true)

    }
    
    func requestAndCheckPermissions() {
        // 카메라 권한 상태 확인
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            // 권한 요청
            AVCaptureDevice.requestAccess(for: .video) { [weak self] authStatus in
                if authStatus {
                    DispatchQueue.main.async {
                        self?.setUpCamera()
                    }
                }
            }
        case .restricted:
            break
        case .authorized:
            // 이미 권한 받은 경우 셋업
            setUpCamera()
        default:
            // 거절했을 경우
            print("Permession declined")
        }
    }
    // 플래시 온오프
    func switchFlash() {
        isFlashOn.toggle()
        flashMode = isFlashOn == true ? .on : .off
        
        // 이미지 설정
        let buttonImageName = isFlashOn ? "flashActiveBg" : "flashBg"
        flashBtnBg.setImage(UIImage(named: buttonImageName), for: .normal)
        
    }
    //카메라 세팅
    func setUpCamera(){

        captureSession = AVCaptureSession()
        captureSession.startRunning()
        
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            
            let photoSettings = AVCapturePhotoSettings()
            photoSettings.isHighResolutionPhotoEnabled = false // 고해상도 비활성화
            
            if backCamera.supportsSessionPreset(.photo) {
                captureSession.sessionPreset = .photo
            }
            
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
            // 비디오 출력의 해상도를 4:3 비율로 설정
            let previewSize = CGSize(width: 640, height: 480) // 4:3 비율로 원하는 해상도 설정
            videoPreviewLayer.frame = CGRect(origin: .zero, size: previewSize)
            videoPreviewLayer.position = CGPoint(x: previewView.bounds.midX, y: previewView.bounds.midY)
            
            previewView.layer.addSublayer(videoPreviewLayer)
            
            DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
                self.captureSession.startRunning()
                DispatchQueue.main.async {
                    self.videoPreviewLayer.frame = self.previewView.bounds
                }
            }
        }
    }
}
