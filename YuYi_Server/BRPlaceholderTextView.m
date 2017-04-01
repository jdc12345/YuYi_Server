//
//  PlaceholderTextView.m
//  SaleHelper
//
//  Created by gitBurning on 14/12/8.
//  Copyright (c) 2014年 Burning_git. All rights reserved.
//

#import "BRPlaceholderTextView.h"
#import "Masonry.h"
#define kLeftX 5.0

@interface BRPlaceholderTextView()<UITextViewDelegate>
@property(strong,nonatomic) UIColor *placeholder_color;
@property(strong,nonatomic) UIFont * placeholder_font;
/**
 *   显示 Placeholder
 */
@property(strong,nonatomic,readonly)  UILabel *PlaceholderLabel;

@property(strong,nonatomic,readonly)  UIButton *PlaceholderBtn;
@property(assign,nonatomic) float placeholdeWidth;

@property(copy,nonatomic) id eventBlock;
@property(copy,nonatomic) id BeginBlock;
@property(copy,nonatomic) id EndBlock;
@end
@implementation BRPlaceholderTextView


#pragma mark - life cycle

//- (id) initWithFrame:(CGRect)frame {
//    if ((self = [super initWithFrame:frame])) {
//        [self setupUI];
//    }
//    return self;
//}
-(instancetype)init{
    if ((self = [super init])) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidChange:) name:UITextViewTextDidChangeNotification object:self];
    
    //UITextViewTextDidBeginEditingNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewBeginNoti:) name:UITextViewTextDidBeginEditingNotification object:self];
    
    //UITextViewTextDidEndEditingNotification
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEndNoti:) name:UITextViewTextDidEndEditingNotification object:self];
    _PlaceholderBtn = [[UIButton alloc] init];
    [self addSubview:_PlaceholderBtn];
    [_PlaceholderBtn setImage:[UIImage imageNamed:@"title"] forState:UIControlStateNormal];
    _PlaceholderLabel=[[UILabel alloc] init];
    [self addSubview:_PlaceholderLabel];
    _PlaceholderLabel.numberOfLines=0;
    _PlaceholderLabel.lineBreakMode=NSLineBreakByCharWrapping|NSLineBreakByWordWrapping;
     
    [self defaultConfig];
    
}
-(void)layoutSubviews{
    float left=kLeftX,hegiht=30;
    self.placeholdeWidth=CGRectGetWidth(self.frame)-2*left;
    [_PlaceholderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
        make.height.width.offset(30);
    }];
    [_PlaceholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_PlaceholderBtn.mas_right).offset(10);
        make.top.offset(0);
        make.width.offset(_placeholdeWidth-40);
        make.height.offset(hegiht);
    }];
 
}
-(void)dealloc{
    [_PlaceholderBtn removeFromSuperview];
    [_PlaceholderLabel removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
#pragma mark - System Delegate
#pragma mark - custom Delegate
#pragma mark - Event response

-(void)defaultConfig
{
    self.placeholder_color = [UIColor lightGrayColor];
    self.placeholder_font  = [UIFont systemFontOfSize:14];
//    self.maxTextLength=1000;
//    self.layoutManager.allowsNonContiguousLayout=NO;
}

-(void)addMaxTextLengthWithMaxLength:(NSInteger)maxLength andEvent:(void (^)(BRPlaceholderTextView *text))limit
{
    if (maxLength>0) {
        
        _maxTextLength=maxLength;

    }
    
    if (limit) {
        _eventBlock=limit;
        
    }
}

-(void)addTextViewBeginEvent:(void (^)(BRPlaceholderTextView *))begin{
    
    _BeginBlock=begin;
}

-(void)addTextViewEndEvent:(void (^)(BRPlaceholderTextView *))End{
    _EndBlock=End;
}

-(void)setUpdateHeight:(float)updateHeight{
    
    CGRect frame=self.frame;
    frame.size.height=updateHeight;
    self.frame=frame;
    _updateHeight=updateHeight;
}

 //供外部使用的 api

-(void)setPlaceholderFont:(UIFont *)font
{
    self.placeholder_font=font;
}
-(void)setPlaceholderColor:(UIColor *)color
{
    self.placeholder_color=color;

}
-(void)setPlaceholderOpacity:(float)opacity
{
    if (opacity<0) {
        opacity=1;
    }
    self.PlaceholderLabel.layer.opacity=opacity;
}


#pragma mark - Noti Event

-(void)textViewBeginNoti:(NSNotification*)noti{
    
    if (_BeginBlock) {
        void(^begin)(BRPlaceholderTextView*text)=_BeginBlock;
        begin(self);
    }
    
}
-(void)textViewEndNoti:(NSNotification*)noti{
    
    if (_EndBlock) {
        void(^end)(BRPlaceholderTextView*text)=_EndBlock;
        end(self);
    }
}

-(void)DidChange:(NSNotification*)noti{
    
    if (self.placeholder.length == 0 || [self.placeholder isEqualToString:@""]) {
        _PlaceholderLabel.hidden=YES;
        _PlaceholderBtn.hidden = YES;
    }
    
    if (self.text.length > 0) {
        _PlaceholderLabel.hidden=YES;
        _PlaceholderBtn.hidden = YES;
    }
    else{
        _PlaceholderBtn.hidden = NO;
        _PlaceholderLabel.hidden=NO;
    }
    
    NSString *lang = [[self.nextResponder textInputMode] primaryLanguage]; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (self.text.length > self.maxTextLength) {
                self.text = [self.text substringToIndex:self.maxTextLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
    
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (self.text.length > self.maxTextLength) {
             self.text = [ self.text substringToIndex:self.maxTextLength];
        }
    }
    
    if (_eventBlock && self.text.length > self.maxTextLength) {
        
        void (^limint)(BRPlaceholderTextView*text) =_eventBlock;
        
        limint(self);
    }
    
}

#pragma mark - private method

+(float)boundingRectWithSize:(CGSize)size withLabel:(NSString *)label withFont:(UIFont *)font{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    // CGSize retSize;
    CGSize retSize = [label boundingRectWithSize:size
                      options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                      attributes:attribute
                                         context:nil].size;
    return retSize.height;
    
}

#pragma mark - getters and Setters

-(void)setText:(NSString *)tex{
    if (tex.length>0) {
        _PlaceholderLabel.hidden=YES;
        _PlaceholderBtn.hidden = YES;
    }
    [super setText:tex];
}
-(void)setImagePlaceholder:(NSString *)imagePlaceholder{
    if (_placeholder.length == 0 || [_placeholder isEqualToString:@""]) {
        _PlaceholderLabel.hidden=YES;
        _PlaceholderBtn.hidden = YES;
    }
    else
    {
        [_PlaceholderBtn setImage:[UIImage imageNamed:imagePlaceholder] forState:UIControlStateNormal];
        _PlaceholderLabel.text=_placeholder;
        }
 }
-(void)setPlaceholder:(NSString *)placeholder{
    if (placeholder.length == 0 || [placeholder isEqualToString:@""]) {
        _PlaceholderLabel.hidden=YES;
        _PlaceholderBtn.hidden = YES;
    }
    else
    {
        _PlaceholderLabel.text=placeholder;
        _placeholder=placeholder;
        
    }
    
}
-(void)setPlaceholder_font:(UIFont *)placeholder_font
{
    _placeholder_font=placeholder_font;
    _PlaceholderLabel.font=placeholder_font;
}

-(void)setPlaceholder_color:(UIColor *)placeholder_color
{
    _placeholder_color=placeholder_color;
    _PlaceholderLabel.textColor=placeholder_color;
}
@end
