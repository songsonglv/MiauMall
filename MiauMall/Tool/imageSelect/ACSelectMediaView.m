//
//  ACSelectMediaView.m
//
//  Created by caoyq on 16/12/22.
//  Copyright © 2016年 ArthurCao. All rights reserved.
//

#import "ACSelectMediaView.h"
#import "ACMediaImageCell.h"
#import "ACShowMediaTypeView.h"
#import "ACMediaManager.h"
#import "TZImagePickerController.h"
#import "MWPhotoBrowser.h"

@interface ACSelectMediaView ()<UICollectionViewDelegate, UICollectionViewDataSource, TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,MWPhotoBrowserDelegate>
{
    UIViewController *rootVC;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) ACMediaHeightBlock block;
@property (nonatomic, copy) ACSelectMediaBackBlock backBlock;
/** 媒体信息数组 */
@property (nonatomic, strong) NSMutableArray *mediaArray;
/** MWPhoto对象数组 */
@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, assign) float wid;


@end

@implementation ACSelectMediaView

#pragma mark - Init

//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        _mediaArray = [NSMutableArray array];
//        rootVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
//        [self configureCollectionView];
//    }
//    return self;
//}

-(instancetype)initWithFrame:(CGRect)frame andIsEnter:(NSString *)isEnter{
    self = [super initWithFrame:frame];
    if (self) {
        _mediaArray = [NSMutableArray array];
        rootVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
        self.isEnter = isEnter;
        [self configureCollectionView];
    }
    return self;
}


- (void)configureCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
   
    if ([_isEnter isEqualToString:@"comment"]) {
        CGFloat wid = ((WIDTH - 64)/3);
        layout.itemSize = CGSizeMake(wid, wid);
    }else if ([_isEnter isEqualToString:@"wish"]){
        layout.itemSize = CGSizeMake(81, 81);
    }else if ([_isEnter isEqualToString:@"refund"] || [_isEnter isEqualToString:@"hpjt"]){
        layout.itemSize = CGSizeMake(75, 75);
    }else if ([_isEnter isEqualToString:@"assess"] || [_isEnter isEqualToString:@"dm"]){
        layout.itemSize = CGSizeMake(92, 92);
    }else{
        layout.itemSize = CGSizeMake(100, 75);
    }
    
//    layout.minimumInteritemSpacing = 12;
//    layout.minimumLineSpacing = 12;
    layout.sectionInset = UIEdgeInsetsMake(0,12,12, 0);
    if([self.isEnter isEqualToString:@"dm"]){
        layout.sectionInset = UIEdgeInsetsMake(12,10,0, 0);
    }
    _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    [_collectionView registerClass:[ACMediaImageCell class] forCellWithReuseIdentifier:NSStringFromClass([ACMediaImageCell class])];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    if([_isEnter isEqualToString:@"refund"] || [_isEnter isEqualToString:@"assess"]){
        _collectionView.backgroundColor = TCUIColorFromRGB(0xf3f4f4);
    }
    [self addSubview:_collectionView];
}

#pragma mark - public method

- (void)observeViewHeight:(ACMediaHeightBlock)value {
    _block = value;
}

- (void)observeSelectedMediaArray: (ACSelectMediaBackBlock)backBlock {
    _backBlock = backBlock;
}

-(void)setPingUploadUrlString:(NSString *)pingUploadUrlString{
    _pingUploadUrlString = pingUploadUrlString;
    ACMediaModel *model = [[ACMediaModel alloc]init];
    model.image = [self getImageFromURL:_pingUploadUrlString];
    [self.mediaArray addObject:model];
}

-(UIImage *) getImageFromURL:(NSString *)fileURL {

    UIImage*result;

    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];

    result = [UIImage imageWithData:data];

    return result;

}

+ (CGFloat)defaultViewHeight {
    return 104;
}

#pragma mark -  Collection View DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.isVideo == YES) {  //视频
        if (_mediaArray.count == 1) {
            return 1;
        } else {
            return _mediaArray.count + 1;
        }
    } else if (self.isfeed == YES) { //照片
        if (_mediaArray.count == 6) {
            return 6;
        }else if ([self.isEnter isEqualToString:@"hpjt"]){
            if (_mediaArray.count == 3) {
                return 3;
            }else{
                return _mediaArray.count + 1;
            }
        }else {
            return _mediaArray.count + 1;
        }
    } else {
        
        return _mediaArray.count + 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ACMediaImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ACMediaImageCell class]) forIndexPath:indexPath];
    if (indexPath.row == _mediaArray.count) {
        cell.icon.image = [UIImage imageNamed:@"step_add"];
        if ([self.isEnter isEqualToString:@"comment"]) {
            cell.icon.image = [UIImage imageNamed:@"upload_new_icon"];
            cell.isComment = @"1";
        }else if([self.isEnter isEqualToString:@"wish"]){
            cell.icon.image = [UIImage imageNamed:@"upload_pic_icon"];
            cell.isComment = @"0";
        }else if([self.isEnter isEqualToString:@"refund"] ){
            cell.icon.image = [UIImage imageNamed:@"upload_new_icon"];
            cell.isComment = @"2";
        }else if ([self.isEnter isEqualToString:@"assess"]){
            cell.icon.image = [UIImage imageNamed:@"upload_six_icon"];
            cell.isComment = @"3";
        }else if ( [self.isEnter isEqualToString:@"hpjt"]){
            cell.icon.image = [UIImage imageNamed:@"upload_new_icon"];
            cell.isComment = @"4";
        }else if ([self.isEnter isEqualToString:@"dm"]){
            cell.icon.image = [UIImage imageNamed:@"upload_new_icon"];
            cell.isComment = @"5";
//            if(self.pingUploadUrlString){
//                [cell.icon sd_setImageWithURL:[NSURL URLWithString:self.pingUploadUrlString]];
//            }
        }
        cell.videoImageView.hidden = YES;
        cell.deleteButton.hidden = YES;
    }else{
        ACMediaModel *model = [[ACMediaModel alloc] init];
        model = _mediaArray[indexPath.row];
        cell.icon.image = model.image;
        cell.videoImageView.hidden = !model.isVideo;
        cell.deleteButton.hidden = NO;
        [cell setACMediaClickDeleteButton:^{
            [_mediaArray removeObjectAtIndex:indexPath.row];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self layoutCollection:@[]];
            });
        }];
    }
    return cell;
}

#pragma mark - collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"textMiss" object:nil];
    
    //如果是视频
    if (self.isVideo == YES) {
        if (indexPath.row == _mediaArray.count && _mediaArray.count >= 1) {
            [UIAlertController showAlertWithTitle:@"最多只能选择1个" message:nil actionTitles:@[@"确定"] cancelTitle:nil style:UIAlertControllerStyleAlert completion:nil];
            return;
        }
    } else {
        if (self.isfeed == YES) {
            if([self.isEnter isEqualToString:@"hpjt"]){
                if (indexPath.row == _mediaArray.count && _mediaArray.count >= 3) {
                    [UIAlertController showAlertWithTitle:@"最多只能选择3张" message:nil actionTitles:@[@"确定"] cancelTitle:nil style:UIAlertControllerStyleAlert completion:nil];
                    return;
                }
            }else if ([self.isEnter isEqualToString:@"dm"]){
                if (indexPath.row == _mediaArray.count && _mediaArray.count >= 1) {
                    [UIAlertController showAlertWithTitle:@"最多只能选择1张" message:nil actionTitles:@[@"确定"] cancelTitle:nil style:UIAlertControllerStyleAlert completion:nil];
                    return;
                }
            }else{
                if (indexPath.row == _mediaArray.count && _mediaArray.count >= 6) {
                    [UIAlertController showAlertWithTitle:@"最多只能选择6张" message:nil actionTitles:@[@"确定"] cancelTitle:nil style:UIAlertControllerStyleAlert completion:nil];
                    return;
                }
            }
            
        } else {
        
            if (indexPath.row == _mediaArray.count && _mediaArray.count >= 9) {
                [UIAlertController showAlertWithTitle:@"最多只能选择9张" message:nil actionTitles:@[@"确定"] cancelTitle:nil style:UIAlertControllerStyleAlert completion:nil];
                return;
            }
        }
        
    }
    
    //点击的是添加媒体的按钮
    if (indexPath.row == _mediaArray.count) {
        NSString *takePhotoTitle = @"拍照";
        takePhotoTitle = @"相机";
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:takePhotoTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                __block UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
//                //ipc.modalPresentationStyle = 0;
//                ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
//                ipc.delegate = self;
//                ipc.allowsEditing = YES;
//                [vc presentViewController:ipc animated:YES completion:^{
//                    ipc = nil;
//                }];
                UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;

                if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    //设置拍照后的图片可被编辑
                    picker.allowsEditing = YES;
                    picker.sourceType = sourceType;
                    
                    //去除毛玻璃效果 避免被导航栏遮住
                    picker.navigationBar.translucent = NO;
                    picker.modalPresentationStyle =UIModalPresentationOverFullScreen;

                    [rootVC presentViewController:picker animated:YES completion:nil];
                }else{
                    [UIAlertController showAlertWithTitle:@"该设备不支持拍照" message:nil actionTitles:@[@"确定"] cancelTitle:nil style:UIAlertControllerStyleAlert completion:nil];
                }
            }
        }];
                   
        [alertVc addAction:takePhotoAction];
        UIAlertAction *imagePickerAction = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //                [self pushTZImagePickerController];
//            //相册
//            __block UIImagePickerController *picker = [[UIImagePickerController alloc]init];
//            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            //设置选择后的图片可被编辑，即可以选定任意的范围
//            picker.allowsEditing = YES;
//            picker.delegate = self;
//            //    去除毛玻璃效果
//            picker.navigationBar.translucent=NO;
//            picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
//            picker.modalPresentationStyle = 0;
//            [rootVC presentViewController:picker animated:YES completion:^{
//                picker = nil;
//            }];
            TZImagePickerController *imagePickerVc;
            if (self.isfeed == YES) {
                
                if([self.isEnter isEqualToString:@"wish"] || [self.isEnter isEqualToString:@"dm"]){
                    imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 - _mediaArray.count delegate:self];
                }else if ([self.isEnter isEqualToString:@"hpjt"]){
                    imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 - _mediaArray.count delegate:self];
                }else{
                    imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:6 - _mediaArray.count delegate:self];
                }
            } else {
                imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 - _mediaArray.count delegate:self];
            }
            ///是否 在相册中显示拍照按钮
            imagePickerVc.allowTakePicture = NO;
            ///是否可以选择显示原图
            imagePickerVc.allowPickingOriginalPhoto = NO;
            ///是否 在相册中可以选择视频
            imagePickerVc.allowPickingVideo = YES;
            imagePickerVc.modalPresentationStyle =UIModalPresentationOverFullScreen;
            [rootVC presentViewController:imagePickerVc animated:YES completion:nil];
        }];
        
        [alertVc addAction:imagePickerAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVc addAction:cancelAction];
        [rootVC presentViewController:alertVc animated:YES completion:nil];
//        ACShowMediaTypeView *fileView = [[ACShowMediaTypeView alloc] init];
//        //视频
//        if (self.isVideo == YES) {
//            fileView.itemArray = @[@"babyLike_video", @"babyLike_phone"];
//        } else {
//            fileView.itemArray = @[@"camera", @"work_photo"];
//        }
//        [fileView show];
//        __weak typeof(self) weakSelf = self;
//        [fileView selectedIndexBlock:^(NSInteger itemIndex) {
//            if (itemIndex == 0) {
//                if (self.isVideo == YES) {
//                    [weakSelf openVideotape];
//                } else {
//                    [weakSelf openCamera];
//                }
//            }else if (itemIndex == 1) {
//                if (self.isVideo == YES) {
//                    [weakSelf openVideo];
//                } else {
//                    [weakSelf openAlbum];
//                }
//            }else if (itemIndex == 2) {
//                [weakSelf openVideotape];
//            }else {
//                [weakSelf openVideo];
//            }
//        }];
    }
    //展示媒体
    else {
        _photos = [NSMutableArray array];
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = NO;
        browser.alwaysShowControls = NO;
        browser.displaySelectionButtons = NO;
        browser.zoomPhotosToFill = YES;
        browser.displayNavArrows = NO;
        browser.startOnGrid = NO;
        browser.enableGrid = YES;
        for (ACMediaModel *model in _mediaArray) {
            MWPhoto *photo = [MWPhoto photoWithImage:model.image];
            photo.caption = model.name;
            if (model.isVideo) {
                if (model.mediaURL) {
                    photo.videoURL = model.mediaURL;
                }else {
                    photo = [photo initWithAsset:model.asset targetSize:CGSizeZero];
                }
            }
            [_photos addObject:photo];
        }
        [browser setCurrentPhotoIndex:indexPath.row];
        [[self viewController].navigationController pushViewController:browser animated:YES];
    }
}

#pragma mark - <MWPhotoBrowserDelegate>

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count) {
        return [self.photos objectAtIndex:index];
    }
    return nil;
}

#pragma mark - 布局

///添加选中的image，然后重新布局collectionview
- (void)layoutCollection: (NSArray *)images {
    [_mediaArray addObjectsFromArray:images];
    NSInteger allImageCount = _mediaArray.count + 1;
    NSInteger maxRow = (allImageCount - 1) / 3 + 1;
    
    _collectionView.height = maxRow * ACMedia_ScreenWidth/3;
    if ([self.isEnter isEqualToString:@"comment"]) {
        CGFloat wid = ((WIDTH - 64)/3);
         maxRow = (allImageCount - 1) / 4 + 1;
        _collectionView.height = maxRow * (wid + 12);
    }else if ([self.isEnter isEqualToString:@"wish"]){
        _collectionView.height = 81;
    }else if ([self.isEnter isEqualToString:@"refund"]){
        _collectionView.height = maxRow * 87;
    }else if ([self.isEnter isEqualToString:@"assess"]){
        _collectionView.height = maxRow * 96;
        if(_mediaArray.count == 6){
            _collectionView.height = 196;
        }
    }else if ([self.isEnter isEqualToString:@"hpjt"]){
        _collectionView.height = 74;
    }else if ([self.isEnter isEqualToString:@"dm"]){
        _collectionView.height = 104;
    }
    
    
    self.height = _collectionView.height;
    //block回调
    !_block ?  : _block(_collectionView.height);
    !_backBlock ?  : _backBlock(_mediaArray);
    
    [_collectionView reloadData];
}

#pragma mark - actions

/** 相册 */
- (void)openAlbum {
    TZImagePickerController *imagePickerVc;
    if (self.isfeed == YES) {
        if([self.isEnter isEqualToString:@"wish"]){
            imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 - _mediaArray.count delegate:self];
        }else if ([self.isEnter isEqualToString:@"hpjt"]){
            imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 - _mediaArray.count delegate:self];
        }
        else{
            imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:6 - _mediaArray.count delegate:self];
        }
        
    } else {
        imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 - _mediaArray.count delegate:self];
    }
    ///是否 在相册中显示拍照按钮
    imagePickerVc.allowTakePicture = NO;
    ///是否可以选择显示原图
    imagePickerVc.allowPickingOriginalPhoto = NO;
    ///是否 在相册中可以选择视频
    imagePickerVc.allowPickingVideo = YES;
    imagePickerVc.modalPresentationStyle =UIModalPresentationOverFullScreen;
    [rootVC presentViewController:imagePickerVc animated:YES completion:nil];
}

/** 相机 */
- (void)openCamera {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;

    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        
        //去除毛玻璃效果 避免被导航栏遮住
        picker.navigationBar.translucent = NO;
        picker.modalPresentationStyle =UIModalPresentationOverFullScreen;

        [rootVC presentViewController:picker animated:YES completion:nil];
    }else{
        [UIAlertController showAlertWithTitle:@"该设备不支持拍照" message:nil actionTitles:@[@"确定"] cancelTitle:nil style:UIAlertControllerStyleAlert completion:nil];
    }
}

/** 录像 */
- (void)openVideotape {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [NSArray arrayWithObjects:@"public.movie", nil];
        picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        picker.videoQuality = UIImagePickerControllerQualityTypeMedium; //录像质量
        picker.videoMaximumDuration = 30.0f; //录像最长时间
    } else {
        [UIAlertController showAlertWithTitle:@"当前设备不支持录像" message:nil actionTitles:@[@"确定"] cancelTitle:nil style:UIAlertControllerStyleAlert completion:nil];
    }
    picker.modalPresentationStyle =UIModalPresentationOverFullScreen;
    [rootVC presentViewController:picker animated:YES completion:nil];
}

/** 视频 */
- (void)openVideo {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
        ipc=[[UIImagePickerController alloc] init];
        ipc.delegate=self;
        //    去除毛玻璃效果 避免被导航栏遮住
        ipc.navigationBar.translucent = NO;
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.videoQuality = UIImagePickerControllerQualityTypeMedium;
        ipc.mediaTypes = [NSArray arrayWithObjects:@"public.movie", nil];
        UIViewController *vc = [[UIApplication sharedApplication] keyWindow].rootViewController;
        ipc.modalPresentationStyle =UIModalPresentationOverFullScreen;
        [vc presentViewController:ipc animated:YES completion:nil];
    }
}

#pragma mark - TZImagePickerController Delegate

//处理从相册单选或多选的照片
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    NSMutableArray *models = [NSMutableArray array];
    for (NSInteger index = 0; index < assets.count; index++) {
        PHAsset *asset = assets[index];
        [ACMediaManager getMediaInfoFromAsset:asset completion:^(NSString *name, id pathData) {
            ACMediaModel *model = [[ACMediaModel alloc] init];
            model.name = name;
            model.uploadType = pathData;
            model.image = photos[index];
            [models addObject:model];
            if (index == assets.count - 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self layoutCollection:models];
                });
            }
        }];
    }
}

///选取视频后的回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    [ACMediaManager getMediaInfoFromAsset:asset completion:^(NSString *name, id pathData) {
        ACMediaModel *model = [[ACMediaModel alloc] init];
        model.name = name;
        model.uploadType = pathData;
        model.image = coverImage;
        model.isVideo = YES;
        model.asset = asset;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self layoutCollection:@[model]];
        });
    }];
}

#pragma mark - UIImagePickerController Delegate
///拍照、选视频图片、录像 后的回调（这种方式选择视频时，会自动压缩，但是很耗时间）
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];

    //媒体类型
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //原图URL
    NSURL *imageAssetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    ///视频 和 录像
    if ([mediaType isEqualToString:@"public.movie"]) {
        
        NSURL *videoAssetURL = [info objectForKey:UIImagePickerControllerMediaURL];
        PHAsset *asset;
       // 录像没有原图 所以 imageAssetURL 为nil
        if (imageAssetURL) {
            PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[imageAssetURL] options:nil];
            asset = [result firstObject];
        }
        AVURLAsset *URLAsset = [AVURLAsset assetWithURL:videoAssetURL];
//        NSString  *videoPath =  info[UIImagePickerControllerMediaURL];
        
        
        //第二种方法，进行视频导出
        [self startExportVideoWithVideoAsset:URLAsset completion:^(NSString *outputPath) {
            [ACMediaManager getVideoPathFromURL:videoAssetURL PHAsset:asset enableSave:NO completion:^(NSString *name, UIImage *screenshot, id pathData) {
                ACMediaModel *model = [[ACMediaModel alloc] init];
                model.image = screenshot;
                model.name = name;
                model.uploadType = pathData;
                model.isVideo = YES;
                model.videoPath = outputPath;
                model.mediaURL = videoAssetURL;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self layoutCollection:@[model]];
                });
            }];
        }];
    }
    
    else if ([mediaType isEqualToString:@"public.image"]) {
        
        UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
        //如果 picker 没有设置可编辑，那么image 为 nil
        if (image == nil) {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        PHAsset *asset;
        //拍照没有原图 所以 imageAssetURL 为nil
        if (imageAssetURL) {
            PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[imageAssetURL] options:nil];
            asset = [result firstObject];
        }
        [ACMediaManager getImageInfoFromImage:image PHAsset:asset completion:^(NSString *name, NSData *data) {
            ACMediaModel *model = [[ACMediaModel alloc] init];
            model.image = image;
            model.name = name;
            model.uploadType = data;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self layoutCollection:@[model]];
            });
        }];
    }
}

- (void)startExportVideoWithVideoAsset:(AVURLAsset *)videoAsset completion:(void (^)(NSString *outputPath))completion
{
    // Find compatible presets by video asset.
    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:videoAsset];
    
    NSString *pre = nil;
    
    if ([presets containsObject:AVAssetExportPreset3840x2160])
    {
        pre = AVAssetExportPreset3840x2160;
    }
    else if([presets containsObject:AVAssetExportPreset1920x1080])
    {
        pre = AVAssetExportPreset1920x1080;
    }
    else if([presets containsObject:AVAssetExportPreset1280x720])
    {
        pre = AVAssetExportPreset1280x720;
    }
    else if([presets containsObject:AVAssetExportPreset960x540])
    {
        pre = AVAssetExportPreset1280x720;
    }
    else
    {
        pre = AVAssetExportPreset640x480;
    }
    
    // Begin to compress video
    // Now we just compress to low resolution if it supports
    // If you need to upload to the server, but server does't support to upload by streaming,
    // You can compress the resolution to lower. Or you can support more higher resolution.
    if ([presets containsObject:AVAssetExportPreset640x480]) {
        //        AVAssetExportSession *session = [[AVAssetExportSession alloc]initWithAsset:videoAsset presetName:AVAssetExportPreset640x480];
        AVAssetExportSession *session = [[AVAssetExportSession alloc]initWithAsset:videoAsset presetName:AVAssetExportPreset640x480];
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yy-MM-dd-HH:mm:ss"];
        
        NSString *outputPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", [[formater stringFromDate:[NSDate date]] stringByAppendingString:@".mov"]];
        NSLog(@"video outputPath = %@",outputPath);
        //删除原来的 防止重复选
        _timeSecond = 0;
        [[NSFileManager defaultManager] removeItemAtPath:_filePath error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:_imagePath error:nil];
        
        _filePath = outputPath;
        session.outputURL = [NSURL fileURLWithPath:outputPath];
        
        // Optimize for network use.
        session.shouldOptimizeForNetworkUse = true;
        
        NSArray *supportedTypeArray = session.supportedFileTypes;
        if ([supportedTypeArray containsObject:AVFileTypeMPEG4]) {
            session.outputFileType = AVFileTypeMPEG4;
        } else if (supportedTypeArray.count == 0) {
            NSLog(@"No supported file types 视频类型暂不支持导出");
            return;
        } else {
            session.outputFileType = [supportedTypeArray objectAtIndex:0];
        }
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents"]]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents"] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:outputPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:outputPath error:nil];
        }
    
        // Begin to export video to the output path asynchronously.
        [session exportAsynchronouslyWithCompletionHandler:^(void) {
            switch (session.status) {
                case AVAssetExportSessionStatusUnknown:
                    NSLog(@"AVAssetExportSessionStatusUnknown"); break;
                case AVAssetExportSessionStatusWaiting:
                    NSLog(@"AVAssetExportSessionStatusWaiting"); break;
                case AVAssetExportSessionStatusExporting:
                    NSLog(@"AVAssetExportSessionStatusExporting"); break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"AVAssetExportSessionStatusCompleted");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) {
                            completion(outputPath);
                        }
                    });
                }  break;
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"AVAssetExportSessionStatusFailed"); break;
                default: break;
            }
        }];
    }
}

#pragma mark 获得当前view的控制器
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController
                                          class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}



@end
