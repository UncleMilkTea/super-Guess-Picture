//
//  ViewController.m
//  超级猜图
//
//  Created by 侯玉昆 on 15/12/21.
//  Copyright © 2015年 侯玉昆. All rights reserved.
//

#import "ViewController.h"
#import "dataModel.h"
#define SCREEN [UIScreen mainScreen].bounds

@interface ViewController ()
/**
 *  图片序号
 */
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
/**
 *  金币按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *coinButton;
/**
 *  图片标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**
 *  头像按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *headButton;
/**
 *  答案界面
 */
@property (weak, nonatomic) IBOutlet UIView *answer;
/**
 *  选择界面
 */

@property (weak, nonatomic) IBOutlet UIView *select;
/**
 *  下一题
 */
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
/**
 *  下标
 */
@property(assign,nonatomic) NSInteger index;
/**
 *  懒加载数组
 */
@property(strong,nonatomic) NSArray<dataModel *> *dataArray;

/**
 *  选择按钮的计数器
 */
@property(assign,nonatomic) NSInteger answerIndex;
//自定义属性
/**
 *  蒙版按钮
 */
@property(strong,nonatomic) UIButton *cover;
/**
 *  原头像的尺寸
 */
//@property(assign,nonatomic) CGRect headFrame;
/**
 *  放大
 */
- (IBAction)big:(id)sender;
/**
 *  下一题
 */
- (IBAction)next:(id)sender;
/**
 *  中间图片
 */
- (IBAction)head:(id)sender;
/**
 *  提示
 */
- (IBAction)tip:(id)sender;



@end

@implementation ViewController

/**
 *  懒加载
 */
- (NSArray<dataModel *> *)dataArray{

    if (nil == _dataArray) {
        NSArray *tempArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"questions.plist" ofType:nil]];
        
        NSMutableArray *dataArray = [NSMutableArray array];
        
        for (NSDictionary *object in tempArray) {
            
            dataModel *model= [dataModel dataWithModel:object];
            
            [dataArray addObject:model];
        }
        _dataArray =dataArray;
    }
    return _dataArray;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.index = -1;
    //设置显示第一张图片为nil自然就跳到第二张图片
    [self next:nil];
}


/**
 *  放大的方法
 */
- (void)bigToImage{
//    _headFrame = _headButton.frame;
    
    _cover = [[UIButton alloc]initWithFrame:SCREEN];
    //把背景设置透明就可以省去透明度设置而且点击任何地方头像都可以回去,不用把头像前置
    _cover.backgroundColor = [UIColor clearColor];
    
//    _cover.alpha = 0;
    
    [self.view addSubview:_headButton];
    
    [self.view addSubview:_cover];
    
    
    //[self.view bringSubviewToFront:_headButton];//把头像加到前面
    
    //动画播放
    [UIView animateWithDuration:.5 animations:^{
        
        //_cover.alpha = .8;
        
      //把头像放大2倍利用transform可以节省中间变量
    _headButton.transform = CGAffineTransformScale(self.headButton.transform, 2, 2);
        
/**********************************************************************
*   这里可以用一个属性来存储原始头像坐标也可以用transform来实现坐标的还原
*********************************************************************/
//        _headButton.frame = CGRectMake(0, (SCREEN.size.height-SCREEN.size.width)/2, SCREEN.size.width, SCREEN.size.width);
        
    }];
    
    //要想按钮生效记住必须添加点击事件
    [_cover addTarget:self action:@selector(smallToImage) forControlEvents:UIControlEventTouchUpInside];
}
/**
 *  缩小的方法
 */
- (void)smallToImage{
    
//    _cover.alpha = 0;
    
[UIView animateWithDuration:1 animations:^{
    //把图片归位
    _headButton.transform = CGAffineTransformIdentity;
    
    //_headButton.frame = _headFrame;
    
} completion:^(BOOL finished) {
    
//    移除蒙版
    [_cover removeFromSuperview];
    //同时把属性赋值nil销毁;
    _cover = nil;
    
    }];

}

/**
 *  放大
 */
- (IBAction)big:(id)sender {
    
    [self bigToImage];
    
    
    
    
    
}
/**
 *  下一题
 */
- (IBAction)next:(UIButton *)sender {
    
    self.index++;
    
    dataModel *model = self.dataArray[self.index];
    //清除所选按钮
    for (UIButton *answer in _answer.subviews) {
        [self clickAnswerButton:answer];
    }
    
    self.select.userInteractionEnabled = YES;
    
    self.view.userInteractionEnabled = YES;
    
    self.numLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.index+1,self.dataArray.count];
    
    self.titleLabel.text = model.title;
    
    
    
    [self.headButton setImage:[UIImage imageNamed:model.icon] forState:UIControlStateNormal];
    
    sender.enabled = self.index < self.dataArray.count - 1;
    
    //生成答案选框
    //循环查找删除上一道题留下的选框
    for (UIButton *btn in self.answer.subviews) {
        [btn removeFromSuperview];
    }
    
    NSInteger answerCount = model.answer.length;
    CGFloat answerW = 40;
    CGFloat answerH = answerW;
    CGFloat answerMargin = 20;
    CGFloat leftAndRightMaigin = (SCREEN.size.width - answerCount*answerW - (answerCount - 1)*answerMargin)/2;
    CGFloat answerY = 0;
    
    for (NSInteger i=0; i<answerCount; i++) {
        
        UIButton *answerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat answerX = leftAndRightMaigin + (i%answerCount)*(answerW+answerMargin);
        
        answerButton.frame = CGRectMake(answerX, answerY, answerW, answerH);
        
        [answerButton setBackgroundImage:[UIImage
                                          imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        
        [answerButton setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
        
        [answerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_answer addSubview:answerButton];
        
        [answerButton addTarget:self action:@selector(clickAnswerButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    //生成选择选框
    for (UIButton *btn in self.select.subviews) {
        [btn removeFromSuperview];
    }
    
    NSInteger selectCount = 7;
    CGFloat selectW = answerW;
    CGFloat selectH = selectW;
    CGFloat margin = 10;
    CGFloat selectMaigin = (SCREEN.size.width - selectCount*selectW - (selectCount - 1)*margin)/2;

    for (NSInteger i=0; i<model.options.count; i++) {
        
        UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat selectX = selectMaigin + (i%selectCount)*(selectW+margin);
        CGFloat selectY = answerMargin + (i/selectCount)*(selectH+margin);
        selectButton.frame = CGRectMake(selectX, selectY, selectW, selectH);
        
        [selectButton setBackgroundImage:[UIImage
                                          imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        
        [selectButton setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
        
        [selectButton setTitle:model.options[i] forState:UIControlStateNormal];
        
        [selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_select addSubview:selectButton];
        
        [selectButton addTarget:self action:@selector(clickSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}
/**
 *  为选择框添加点击事件
 */
- (void)clickSelectButton:(UIButton *)sender{
    _answerIndex ++;
    NSString *str = [sender titleForState:UIControlStateNormal];
//    NSString *str = sender.titleLabel.text;这种获取的按钮状态不确定
//清空按钮的文本
//    [sender setTitle:nil forState:UIControlStateNormal];
    //点击将文本加载到答案按钮中
    //遍历答案中的所有元素然后找到第一个没有答案的空白按钮
    for (UIButton *answerButton in self.answer.subviews) {
        NSString *temp = [answerButton titleForState:UIControlStateNormal];
        if (temp == nil&&temp.length == 0) {
            [answerButton setTitle:str forState:UIControlStateNormal];
            break;
        }
    }
    //隐藏点击待选按钮
    sender.hidden = YES;
    //点击的同时可以判断答案
    dataModel *model = self.dataArray[self.index];
    
    if (_answerIndex == model.answer.length) {
        //如果框已经填满就禁用整个answerView交互
        _select.userInteractionEnabled = NO;
        //对比答案如果正确就为蓝色错误就为红色
        NSMutableString *userAnswer = [NSMutableString string];
        //遍历用户的答案然后全部加载到一个可变数组中
        for (UIButton *btn in _answer.subviews) {
            [userAnswer appendString:[btn titleForState:UIControlStateNormal]];
        }
        //开始判断和数据的答案是否相同,相同的为蓝色不通为蓝色
        if ([userAnswer isEqual:model.answer]) {//正确
            
            for (UIButton *answerbtn in _answer.subviews) {
                
                [answerbtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }
                //正确的时候要禁用交互
                self.view.userInteractionEnabled = NO;
                //答对加一百分
                [self updataScore:100];
                
                //点击答案计数器归零
                _answerIndex = 0;
                
                //等待几秒跳转到下一题
//                [self performSelector:@selector(next:) withObject:nil afterDelay:1];
            if (  self.index < self.dataArray.count-1   ) {
                [self performSelector:@selector(next:) withObject:nil afterDelay:1];
            }else{
            
                _nextButton.enabled = NO;
            }
            
        }else{//错误
            
            for (UIButton *answerbtn in _answer.subviews) {
                
                [answerbtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }
    }
}




/**
 *  点击答案中按钮回到选择中
 */
- (void)clickAnswerButton:(UIButton *)sender{
    //判断答案按钮是否为空
    NSString *temp = [sender titleForState:UIControlStateNormal];
    
    if (temp == nil || temp.length == 0) {return;}
    
    _answerIndex --;

    //取出答案文本,遍历选择区的按钮,如果文本相同就改变隐藏属性
    
    NSString *str = [sender titleForState:UIControlStateNormal];
    //清空按钮文本
    [sender setTitle:nil forState:UIControlStateNormal];
//遍历select按钮找到隐藏的按钮
    for (UIButton *selectBtn in _select.subviews) {
        
        //重新设置答案区按钮为黑色
        for (UIButton *answerbtn in _answer.subviews) {
            [answerbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }

        //取出遍历的每隐藏按钮文本准备比较
        NSString *selectStr = [selectBtn titleForState:UIControlStateNormal];
        //比较
        if ([str isEqualToString:selectStr] && selectBtn.isHidden) {
            
            selectBtn.hidden = NO; break;
        }
    }
//启用交互
    _select.userInteractionEnabled = YES;
}


/**
 *  改变分数的方法
 */
- (void)updataScore:(NSInteger)score{

    NSInteger num = [_coinButton titleForState:UIControlStateNormal].integerValue;

    num += score;
    
    [_coinButton setTitle:[NSString stringWithFormat:@"%ld",num] forState:UIControlStateNormal];




}





/**
 *  点击图片
 */
- (IBAction)head:(id)sender {
    
    [self bigToImage];
    
}
/**
 *  提示
 */
- (IBAction)tip:(id)sender {
    // 先扣分
    [self updataScore:-500];
    // 选处答案中的第一个字
    dataModel *question = _dataArray [self.index];
    NSString *first = [question.answer substringToIndex:1];
    
    // 清除所选按钮
    for (UIButton *answer in _answer.subviews) {
        [self clickAnswerButton:answer];
    }
    // 填到答案按钮中
    for (UIButton *option in _select.subviews) {
        if([[option titleForState:UIControlStateNormal] isEqualToString:first]) {
            
            [self clickSelectButton:option];
            
            break;
        }
    }

}
@end
