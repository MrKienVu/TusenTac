//
//  InformationViewController.swift
//  TusenTac
//
//  Created by Paul Philip Mitchell on 06/01/16.
//  Copyright © 2016 ingeborg ødegård oftedal. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController, UIPageViewControllerDataSource {
    
    var pageViewController: UIPageViewController!
    let pageTitles = ["TusenTac", "Datalagring", "Personvern", "Påminnelser"]
    let pageImages = ["tusentac-logo", "tusentac-security", "tusentac-privacy", "tusentac-notification"]
    let pageTexts = [
        "Velkommen til Min Dag! Dette forskningsprosjektet er i regi av NORMENT-senteret ved fakultetet for medisin, Universitetet i Oslo. På de neste sidene vil du kunne lese litt mer om hvordan vi håndterer datalagring osv..",
        "All data du genererer vil bli lagret på Universitetet i Oslo sine sikre servere, og ingen andre enn forskere tilkoblet dette prosjektetet vil ha tilgang til dataene. Ingen data vil bli lagret lokalt på din enhet.",
        "For å ivareta ditt personvern, vil vi ikke samle inn noe informasjon som kan identifisere deg som person. Dette er viktig fordi blabla.",
        "Denne applikasjonen baserer seg på å gi deg påminnelser når du har ting du må gjøre i appen, som å fylle ut et kort spørreskjema. Det er derfor viktig at du tillater appen å gi deg påminnelser. Klikk på knappen nedenfor for å tillate påminnelser."
    ]

    @IBOutlet weak var configureButton: UIButton!
    
    @IBAction func configureClicked(sender: AnyObject) {
        if Notification.sharedInstance.isNotificationsEnabled() {
            UserDefaults.setBool(true, forKey: UserDefaultKey.NotificationsEnabled)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPageControl()
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("InformationPageController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let startVC = self.viewControllerAtIndex(0) as InformationPageContentViewController
        let viewControllers = NSArray(object: startVC) as! [InformationPageContentViewController]
        
        self.pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRect(x: 0, y: 30, width: self.view.frame.width, height: self.view.frame.size.height - 80)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }
    
    
    func viewControllerAtIndex(index: Int) -> InformationPageContentViewController {
        if (self.pageTitles.count == 0) || (index >= self.pageTitles.count) {
            return InformationPageContentViewController()
        }
        
        let vc: InformationPageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("InformationPageContentViewController") as! InformationPageContentViewController
        
        vc.imageFile = self.pageImages[index]
        vc.titleIndex = self.pageTitles[index]
        vc.textViewText = self.pageTexts[index]
        vc.pageIndex = index
        
        return vc
    }
    
    // MARK: PageViewController Data Source
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! InformationPageContentViewController
        var index = vc.pageIndex as Int
        
        if (index == 0 || index == NSNotFound) {
            return nil
        }
        
        index--
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! InformationPageContentViewController
        var index = vc.pageIndex as Int
        
        if (index == NSNotFound) {
            return nil
        }
        
        index++
        if (index == self.pageTitles.count) {
            configureButton.enabled = true
            vc.permissionButton.enabled = true
            vc.permissionButton.hidden = false
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.lightGrayColor()
        appearance.currentPageIndicatorTintColor = UIColor.blackColor()
        appearance.backgroundColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
