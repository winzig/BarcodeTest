//
//  BarcodeViewController.swift
//
//
//  Created by Tom on 7/8/15.
//
//

import UIKit
import MTBBarcodeScanner
import PermissionScope

class BarcodeViewController: UIViewController {
	
	@IBOutlet var barcodeView : UIView!
	
	//@IBOutlet var redline : UIView!
	
	let pscope = PermissionScope()
	
	var scanner : MTBBarcodeScanner?

	var overlayViews : [String:UIView] = [:]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//redline.hidden = true // for now we're going with our smart reader
		
		scanner = MTBBarcodeScanner(metadataObjectTypes: [AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeDataMatrixCode], previewView: barcodeView)
		
		pscope.addPermission(PermissionConfig(type: .Camera, demands: .Required, message: "We need this to scan barcodes", notificationCategories: .None))
		
		if PermissionScope().statusCamera() == .Authorized {
			scanForBarcodes()
		} else {
			
			pscope.authChangeClosure = { (finished, results) -> Void in
				println("Camera request was finished with results \(results)")
				if results[0].status == .Authorized {
					// they've authorized our use of the camera
					println("They've authorized the use of the camera")
					
					self.scanForBarcodes()
					
					self.pscope.viewControllerForAlerts = self.pscope as UIViewController
				}
			}
			pscope.cancelClosure = { (results) -> Void in
				println("Camera request was cancelled with results \(results)")
			}
			pscope.disabledOrDeniedClosure = { (results) -> Void in
				println("Camera request was denied or disabled with results \(results)")
			}
			
			pscope.viewControllerForAlerts = self
			pscope.requestCamera()
		}
		
	}
	
	override func shouldAutorotate() -> Bool {
		return false
	}
	
	
	override func supportedInterfaceOrientations() -> Int {
		return Int(UIInterfaceOrientationMask.LandscapeRight.rawValue)
	}
	

	func scanForBarcodes() {
		if MTBBarcodeScanner.cameraIsPresent() {
			//redline.hidden = false
			scanner?.startScanningWithResultBlock({ (codes) -> Void in
				
				for code in codes {
					println("Found code \(code.stringValue)")
				}
			})
		}
	}
	
	/** Draw a green (if valid) or red (if invalid) highlight on the given bounds, for highlighting barcodes. */
	func overlayForCodeString(codeString: String, bounds: CGRect, valid: Bool) -> UIView {
		var viewColor = valid ? UIColor.greenColor() : UIColor.redColor()
		var view = UIView(frame: bounds)
		view.layer.borderWidth = 5.0;
		view.backgroundColor = viewColor.colorWithAlpha(0.75)
		view.layer.borderColor = viewColor.CGColor
		
		return view
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
		
		scanner?.stopScanning()
	}
	
}

extension UIColor {
	func colorWithAlpha(newAlpha: CGFloat) -> UIColor {
		var hue: CGFloat = 1.0, saturation: CGFloat = 1.0, brightness: CGFloat = 1.0
		self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
		return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: newAlpha)
	}
}
