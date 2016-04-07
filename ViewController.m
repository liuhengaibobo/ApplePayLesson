

#import "ViewController.h"
#import <PassKit/PassKit.h>
#import <AddressBook/AddressBook.h>

@interface ViewController ()<PKPaymentAuthorizationViewControllerDelegate>
- (IBAction)payAction:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//APPLEPay支付响应事件
- (IBAction)payAction:(UIButton *)sender {
    
    //创建请求对象,用来承载请求的信息
    PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
    
    //商品列表
    
   
    
    PKPaymentSummaryItem *item1 = [PKPaymentSummaryItem summaryItemWithLabel:@"宝马车一辆" amount: [NSDecimalNumber decimalNumberWithString:@"200"]];
    
    PKPaymentSummaryItem *item2 = [PKPaymentSummaryItem summaryItemWithLabel:@"真皮座椅" amount:[NSDecimalNumber decimalNumberWithString:@"300"]];
    
    PKPaymentSummaryItem *item3 = [PKPaymentSummaryItem summaryItemWithLabel:@"corder qi" amount:[NSDecimalNumber decimalNumberWithString:@"500"]];
    
    request.paymentSummaryItems = @[item1,item2,item3];
    
    //设置支付的货币信息,国家信息,US,USD
    
    request.countryCode = @"CN";
    request.currencyCode = @"CNY";
    
    //支持的网络支付类型
    
    request.supportedNetworks = @[PKPaymentNetworkChinaUnionPay,PKPaymentNetworkMasterCard,PKPaymentNetworkVisa];
    
    
    request.merchantIdentifier = @"...";
    
    request.merchantCapabilities = PKMerchantCapabilityEMV;
    
    //将我们地址信息绑定到request上
    
    request.requiredBillingAddressFields = PKAddressFieldEmail|PKAddressFieldPostalAddress;
    
    
    
    
    
    
    //界面显示对象,用来显示所有的订单信息
    
    PKPaymentAuthorizationViewController *pavc = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
    
    
    pavc.delegate = self;
    
    if (!pavc) {
        NSLog(@"出错了");
    }else
    {
        //将控制器模态推出来
        [self presentViewController:pavc animated:YES completion:nil];
    }
    
    
}

//在执行过程中进行调用的
//这个是核心方法,有三个参数
//第一个是代表订单信息显示页面
//第二个是代表订单详细信息
//第三个参数用来确定界面显示什么样的支付结果
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion
{
    
    //拿到token
    
    PKPaymentToken *token = payment.token;
    
    //拿到订单地址
    
    NSString *city = payment.billingContact.postalAddress.city;
    
    NSLog(@"city:%@",city);
    
    //用token和订单地址发送到自己的服务器,由自己的服务器与银联接口进行账单交易,返回结果
    
    //将结果显示到界面上
    
    PKPaymentAuthorizationStatus status = PKPaymentAuthorizationStatusFailure;
    
    completion(status);
    
    
    
}

//请求结束后调用
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    //将订单界面模态退出
    [controller dismissViewControllerAnimated:YES completion:nil];
}
@end
