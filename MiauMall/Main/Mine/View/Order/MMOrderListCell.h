//
//  MMOrderListCell.h
//  MiauMall
//
//  Created by 吕松松 on 2023/1/15.
//

#import <UIKit/UIKit.h>
#import "MMOrderListModel.h"

NS_ASSUME_NONNULL_BEGIN
//自己定义的一个状态 0 待支付 1 待发货 2 代收货 3 待评价 4 售后 5 关闭
@interface MMOrderListCell : UITableViewCell
@property (nonatomic, strong) MMOrderListModel *model;
@property (nonatomic, copy) void(^tapCopyBlock)(NSString *OrderNo);//点击复制按钮回调
@property (nonatomic, copy) void(^tapGoodsBlock)(NSString *router);//点击商品回调
@property (nonatomic, copy) void(^tapReceiptBlock)(MMOrderListModel *model);//点击收货
@property (nonatomic, copy) void(^tapPayBlock)(MMOrderListModel *model);//点击支付
@property (nonatomic, copy) void(^tapResultBlock)(MMOrderListModel *model);//点击结果
@property (nonatomic, copy) void(^tapRefundBlock)(MMOrderListModel *model);//点击退款//
@property (nonatomic, copy) void(^tapLogisticBlock)(MMOrderListModel *model);//点击物流
@property (nonatomic, copy) void(^tapSaleServiceBlock)(MMOrderListModel *model);//点击售后
@property (nonatomic, copy) void(^tapAssessBlock)(MMOrderListModel *model);//点击评价
@property (nonatomic, copy) void(^tapTxfhBlock)(MMOrderListModel *model);//点击提醒发货
@property (nonatomic, copy) void(^tapAddressBlock)(MMOrderListModel *model);//点击地址
@property (nonatomic, copy) void(^tapAddCartBlock)(MMOrderListModel *model);//点击加购
@property (nonatomic, copy) void(^tapCancleBlock)(MMOrderListModel *model);//点击取消
@property (nonatomic, copy) void(^tapDeleteBlock)(MMOrderListModel *model);//点击删除
@property (nonatomic, copy) void(^tapKefuBlock)(MMOrderListModel *model);//点击删除
//@property (nonatomic, copy) void(^tapRigthBlock)(NSString *btType);//点击右边按钮的类型
//@property (nonatomic, copy) void(^tapCenterBlock)(NSString *btType);//点击中间按钮的类型
//@property (nonatomic, copy) void(^tapLeftBlock)(NSString *btType);//点击中间按钮的类型
//@property (nonatomic, copy) void(^tapAddCarBlock)(NSString *btType);//点击最左边按钮的类型
@property (nonatomic, copy) void(^tapShowBlock)(MMOrderListModel *model);
@end

NS_ASSUME_NONNULL_END
