# FYVideoPlayerDemo
AVPlayer视频播放器
基于AVPlayer的视频播放器,支持横竖屏切换、音量和亮度的手动调节、手势拖动改变进度等。目前功能还在各种完善中。 

![image](https://github.com/SingleSun/FYVideoPlayerDemo/blob/master/FYVideoPlayer.gif)

## 使用
``` FYPlayerView * play = [[FYPlayerView alloc]initWithFrame:CGRectMake(0, 100,FYScreenWidth , 200)];
    play.url = [NSURL URLWithString:@"http://wvideo.spriteapp.cn/video/2016/1203/58425ad2a0c1d_wpd.mp4"];
    play.videoName = @"百思不得姐第52期";
    [self.view addSubview:play];
 
 
