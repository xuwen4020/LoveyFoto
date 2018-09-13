//
//  XWChooseImageButton.m
//  Project
//
//  Created by xuwen on 2018/7/31.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "XWChooseImageButton.h"

@interface XWChooseImageButton()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic,assign,readwrite) BOOL isChooseImage;
@end

@implementation XWChooseImageButton

- (instancetype)initWithFrame:(CGRect)frame eventViewController:(UIViewController *)eventVC
{
    self = [super initWithFrame:frame];
    if(self){
        self.eventVC = eventVC;
        [self addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


#pragma mark -
- (void)chooseImage
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Please choose" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing = YES;
            picker.delegate = self;
            [self.eventVC presentViewController:picker animated:YES completion:^{
            }];
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"photo album" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //相册
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] || [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary | UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            picker.allowsEditing = YES;
            picker.delegate = self;
            [self.eventVC presentViewController:picker animated:YES completion:^{
            }];
        }
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //取消
    }];
    
    //把action添加到actionSheet里
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:action3];
    
    [self.eventVC presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [self setBackgroundImage:image forState:UIControlStateNormal];
    self.isChooseImage = YES;
    if(self.chooseImageBlock){
        self.chooseImageBlock(image);
    }
}


@end
