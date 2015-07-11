//
//  BarcodeViewController.swift
//
//
//  Created by Tom on 7/8/15.
//
//

import UIKit
import MTBBarcodeScanner

class BarcodeViewController: UIViewController {
	
	@IBOutlet var barcodeView : UIView!
	
	var scanner : MTBBarcodeScanner?

	var overlayViews : [String:UIView] = [:]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		scanner = MTBBarcodeScanner(metadataObjectTypes: [AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeDataMatrixCode], previewView: barcodeView)
		
		MTBBarcodeScanner.requestCameraPermissionWithSuccess { (success) -> Void in
			if success {
				self.scanForBarcodes()
			} else {
				println("Camera permission denied")
			}
		}
	}
	
	func scanForBarcodes() {
		if MTBBarcodeScanner.cameraIsPresent() {
			scanner?.startScanningWithResultBlock({ (codes) -> Void in
				
				for code in codes {
					println("Found code \(code.stringValue)")
				}
			})
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
		
		scanner?.stopScanning()
	}
	
}

