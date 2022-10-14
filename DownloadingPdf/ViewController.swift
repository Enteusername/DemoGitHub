//
//  ViewController.swift
//  DownloadingPdf
//
//  Created by GGKU6MAC042 on 12/10/22.
//

import UIKit

class ViewController: UIViewController,URLSessionTaskDelegate,URLSessionDownloadDelegate,URLSessionDelegate{
    
    @IBOutlet var progressIndicator: UIProgressView!
    @IBOutlet var percentageLbl: UILabel!
    var dataTask = URLSessionDownloadTask()
    //let task = URLSessionDataTask()
    var resumeData: Data? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        guard let url = URL(string: "https://www.africau.edu/images/default/sample.pdf") else{
//            return
//        }
        //downloadingFile()
        //getData(url: url)
        if let progress = UserDefaults.standard.value(forKey: "progressValue"){
            progressIndicator.progress = progress as! Float
        }else{
            progressIndicator.progress = 0
        }
        //progressIndicator.progress = 0
        

    }
    @IBAction func downloadButnAction(_ sender: Any) {
        UserDefaults.standard.setValue(nil, forKey: "ResumedData")
        UserDefaults.standard.setValue(nil, forKey: "progressValue")
        guard let url = URL(string: "https://hpread.scholastic.com/HP_Book1_Chapter_Excerpt.pdf") else{
            return
        }
        let session = URLSession(configuration: .default,delegate: self,delegateQueue: .main)
        dataTask = session.downloadTask(with: url)
        dataTask.resume()

    }

    
    @IBAction func pauseButnAction(_ sender: Any) {
        print("Pausing")
        //dataTask.cancel()
        dataTask.cancel(byProducingResumeData: { resumedData in
            guard resumedData != nil else{ return}
            //self.resumeData = resumedData
            print("\(String(describing: resumedData))")
        })
           
    }

    @IBAction func resumeButnAction(_ sender: Any) {
        let session = URLSession(configuration: .default,delegate: self,delegateQueue: .main)
        let resumedData1 = UserDefaults.standard.value(forKey: "ResumedData") as? Data
        guard let resumeData = resumedData1 else{
            print("no resumed data")
            return
            
        }
        print("resumebutn: \(resumeData)")
        dataTask = session.downloadTask(withResumeData: resumeData)
        dataTask.taskDescription = "https://hpread.scholastic.com/HP_Book1_Chapter_Excerpt.pdf"
        dataTask.resume()
        
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("\(location)")
        guard let data = try? Data(contentsOf: location) else{
            return
        }
        let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        let destinationUrl = documentUrl.appendingPathComponent("harryPotter.pdf")
        try? data.write(to: destinationUrl!,options: .atomic)
        print("\(destinationUrl!.path)")

    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            self.percentageLbl.text = "\(Int(progress*100))%"
            self.progressIndicator.progress = progress
        }
        UserDefaults.standard.setValue(progress, forKey: "progressValue")
        //print("entered")
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print(".........wifi stopped........")
        guard let error = error else {
                // Handle success case.
            print("No Error")
                return
            }
            let userInfo = (error as NSError).userInfo
        print("nothing")
       // print("\(userInfo[NSURLSessionDownloadTaskResumeData] ?? "nothing")")
            if let resumeData = userInfo[NSURLSessionDownloadTaskResumeData] as? Data {
                self.resumeData = resumeData
                UserDefaults.standard.setValue(resumeData, forKey: "ResumedData")
                print("resumeData:\(resumeData)")
                let dataValue = UserDefaults.standard.value(forKey: "ResumedData") as! Data
                //print("value: \(String(describing: UserDefaults.standard.value(forKey: "ResumedData")))")
                print("DATA VALUE: \(dataValue)")
            }
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("resumeing data")
    }
    
}
//https://hpread.scholastic.com/HP_Book1_Chapter_Excerpt.pdf//guard let data = try? Data(contentsOf: location) else{
//            return
//        }
//        guard let url = URL(string: "https://hpread.scholastic.com/HP_Book1_Chapter_Excerpt.pdf") else{
//            return
//        }
//        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
//        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
//        try? data.write(to: destinationUrl!,options: .atomic)
//        print("\(destinationUrl!.path)")

//func downloadingFile(){
//    //progressIndicator.progress = 0
//
//
//}
//func getData(url: URL){
//    URLSession.shared.dataTask(with: url, completionHandler: { data,response,error in
//
//        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
//        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
//        guard let data = data,error == nil else{
//            return
//        }
//        do{
//            debugPrint("downloding the pdf")
//            try! data.write(to: destinationUrl!,options: .atomic)
//            debugPrint("\(destinationUrl!.path)")
//            DispatchQueue.main.async {
//                self.view.backgroundColor = .systemGreen
//            }
//
//            debugPrint("PDF is downloaded")
//        }
//        catch{
//            debugPrint("\(error.localizedDescription)")
//        }
//
//    }).resume()
//}


