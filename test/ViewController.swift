import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,EAIntroDelegate,HttpProtocol {
    
    var tableView: UITableView!
    var dataArray = [String]()
    var header: XHPathCover!
    var isEding = NSMutableArray()
    
    var returnKeyHandler: IQKeyboardReturnKeyHandler!
    var eHttp = HttpRequest()
    

    func didResponse(result: NSDictionary) {
        print(result)
       
    }
    
    func didResponseByNSData(result: NSData) {
    
      //解析XML
      let xml = SWXMLHash.parse(result)
 
        print(xml["soap:Envelope"]["soap:Body"]["ns1:getAppContentListResponse"]["return"].element!.children.count)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let url = "http://172.16.10.86:8080/jeecms/webService/getAppChannelList/getAppContentList"
//        eHttp.delegate = self
//        let params = ["channelId":"13"]
//        eHttp.getResponseByNSData(.GET, url: url, parameters: params)
        
        //键盘监听事件
        returnKeyHandler = IQKeyboardReturnKeyHandler.init(controller: self)
        returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyType.Done
        returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarManageBehaviour.BySubviews
        
        SweetAlert().showAlert("这是标题", subTitle: "swift移动架构设计demo", style: AlertStyle.Warning)
        let rightBarItem = UIBarButtonItem(title: "+", style: UIBarButtonItemStyle.Done, target: self, action: "addAction")
        
        
        self.navigationItem.rightBarButtonItem = rightBarItem
        self.title = "what"
        var tableFrame = self.view.frame
        tableFrame.origin.y += 64
        tableView = UITableView(frame: tableFrame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerClass(SwipeableCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
          //下拉刷新
         // tableView.addLegendHeaderWithRefreshingTarget(self, refreshingAction: "headRefresh")
        
        header = XHPathCover(frame: CGRectMake(0, 0, self.view.frame.width, 200))
        header.setBackgroundImage(UIImage(named: "BG"))
        header.setAvatarImage(UIImage(named: "cute_girl.jpg"))
        header.isZoomingEffect = true
        header.avatarButton.layer.cornerRadius = 33
        header.avatarButton.layer.masksToBounds = true
        header.avatarButton.addTarget(self, action: "doImage", forControlEvents: UIControlEvents.TouchUpInside)
        header.setInfo(NSDictionary(objects: ["yuy","ios工程师"], forKeys: [XHUserNameKey,XHBirthdayKey]) as [NSObject : AnyObject])
        
        header.handleRefreshEvent = {
            self.headRefresh()
        }
        tableView.tableHeaderView = header
        
        //上拉加载
        tableView.addGifFooterWithRefreshingTarget(self, refreshingAction: "addMoreData")
        self.view.addSubview(tableView)
        
        //加载数据
        addData("")
        
        //判断当前版本是否是最新的
        guard !CustomVersion.isLastVersion() else {
            guideView()
            return
        }
    }
    
    func addAction(){
        let alertAction = UIAlertController(title: "添加", message: "请输入要添加的内容", preferredStyle: UIAlertControllerStyle.Alert)
        let action1 = UIAlertAction(title: "保存", style: UIAlertActionStyle.Default) { (action) -> Void in
            let text = alertAction.textFields![0] as UITextField
            self.addData(text.text!)
            let indexPath = NSIndexPath(forRow: (self.dataArray.count - 1), inSection: 0)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
        }
        let action2 = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        alertAction.addAction(action1)
        alertAction.addAction(action2)
        alertAction.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in
            
        }
        self.presentViewController(alertAction, animated: true, completion: nil)
    }
    
    func headRefresh(){
        self.delay(2) { () -> () in
            self.dataArray.removeAll()
            self.addData()
            //self.tableView.header.endRefreshing()
            self.header.stopRefresh()
            self.tableView.reloadData()
        }
    }
    
    func photoBrowser(){
        
        let browserViewController = HZPhotoBrowser()
        browserViewController.sourceImagesContainerView = header.avatarButton
        browserViewController.imageCount = 1
        browserViewController.currentImageIndex = 0
        browserViewController.delegate = self
        browserViewController.show()
    }
    
    func doImage(){
        let picker = DoImagePickerController(nibName: "DoImagePickerController", bundle: nil)
        picker.delegate = self
        picker.nMaxCount = 1
        picker.nColumnCount = 3
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func addMoreData(){
        self.delay(2) { () -> () in
            self.addData("")
            self.tableView.footer.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func delay(time:Double,closure:()->()){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))),dispatch_get_main_queue(), closure)
    }
    
    func addData(){
        for var i = 0 ; i < 10; i++ {
            dataArray.append("\(i)")
        }
    }
    
    func addData(string:String){
        dataArray.append(string)
    }
    
    
   
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SwipeableCell
        
        for view in cell.containerView.subviews {
            view.removeFromSuperview()
        }
        let imageView = UIImageView(frame: CGRectMake(10, 10, 60, 60))
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.sd_setImageWithURL(NSURL(string: ""), placeholderImage: UIImage(named: "cute_girl.jpg"))
        cell.containerView.addSubview(imageView)
        let label = UILabel(frame:CGRectMake(80, 30, 100, 20))
        label.text = "这是第\(indexPath.row)行"
        cell.containerView.addSubview(label)
        cell.delegate = self
        cell.dataSource = self
        cell.setNeedsUpdateConstraints()
        if isEding.containsObject(indexPath){
            cell.openCell(false)
        }else{
            cell.closeCell(false)
        }
        return cell
    }
    
    func guideView(){
        self.navigationController?.navigationBar.hidden = true
        
        let page1 = EAIntroPage()
        page1.bgImage = UIImage(named: "image1.jpg")
        page1.title = "华于形，美于心"
        page1.titleColor = UIColor.grayColor()
        page1.titlePositionY = 400
        page1.titleFont = UIFont.systemFontOfSize(20)
        
        let page2 = EAIntroPage()
        page2.bgImage = UIImage(named: "image2.jpg")
        page2.title = "德艺双馨，妙手天成"
        page2.titleColor = UIColor.grayColor()
        page2.titlePositionY = 400
        page2.titleFont = UIFont.systemFontOfSize(20)
        
        let page3 = EAIntroPage()
        page3.bgImage = UIImage(named: "image3.jpg")
        page3.title = "表面文章，内在功夫"
        page3.titleColor = UIColor.grayColor()
        page3.titlePositionY = 400
        page3.titleFont = UIFont.systemFontOfSize(20)
        
        let intro = EAIntroView(frame: self.view.frame, andPages: [page1,page2,page3])
        intro.delegate = self
        
        intro.showInView(self.view)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func introDidFinish(introView: EAIntroView!) {
        self.navigationController?.navigationBar.hidden = false
    }
    

    
    
}

extension ViewController:HZPhotoBrowserDelegate {
    //        - (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;
    //        - (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;
    func photoBrowser(browser: HZPhotoBrowser!, placeholderImageForIndex index: Int) -> UIImage! {
        return header.avatarButton.currentImage
    }
    func photoBrowser(browser: HZPhotoBrowser!, highQualityImageURLForIndex index: Int) -> NSURL! {
        let url = NSURL(string: "http://i6.topit.me/6/5d/45/1131907198420455d6o.jpg")
        return url
    }
}
// MARK: - 扩展支持PathCover的方法
extension ViewController {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        header.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        header.scrollViewDidEndDecelerating(scrollView)
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        header.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        header.scrollViewWillBeginDragging(scrollView)
    }
}

extension ViewController: DoImagePickerControllerDelegate {

    func didCancelDoImagePickerController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func didSelectPhotosFromDoImagePickerController(picker: DoImagePickerController!, result aSelected: [AnyObject]!) {
        let image = aSelected.first as! UIImage
        header.avatarButton.setImage(image, forState: UIControlState.Normal)
         self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ViewController: SwipeableCellDelegate,SwipeableCellDataSource{
    
    func swipeableCell(cell: SwipeableCell!, didSelectButtonAtIndex index: Int) {
        print(index)
    }
    
    func swipeableCellDidOpen(cell: SwipeableCell!) {
        let indexPath = tableView.indexPathForCell(cell)
        isEding.addObject(indexPath!)
    }
    
    func swipeableCellDidClose(cell: SwipeableCell!) {
        let indexPath = tableView.indexPathForCell(cell)
        isEding.removeObject(indexPath!)
    }
    
    func numberOfButtonsInSwipeableCell(cell: SwipeableCell!) -> Int {
        return 3
    }
    
    func swipeableCell(cell: SwipeableCell!, buttonForIndex index: Int) -> UIButton! {
        let btn = UIButton(frame: CGRectMake(0, 0, 60, 60))
        if index == 0 {
            btn.backgroundColor = UIColor.redColor()
            btn.setTitle("Delete", forState: UIControlState.Normal)
        }
        if index == 1 {
            btn.backgroundColor = UIColor.greenColor()
            btn.setTitle("Add", forState: UIControlState.Normal)
        }
        if index == 2 {
            btn.backgroundColor = UIColor.orangeColor()
            btn.setTitle("More", forState: UIControlState.Normal)
        }
        return btn
    }
}


