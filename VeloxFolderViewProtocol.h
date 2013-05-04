@protocol VeloxFolderViewProtocol
+(int)folderHeight;
-(UIView *)initWithFrame:(CGRect)aFrame;
@optional
-(void)unregisterFromStuff; //Not necessary, use to unregister from notification centers
-(float)realHeight; //Optional, used to make a folder with a dynamic height. Caled right after -initWithFrame
@end