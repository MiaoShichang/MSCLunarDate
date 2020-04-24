# 简介 
MSCLunarDate 中国农历日期  实现了农历和阳历互转

# 安装方式

  在文件 `Podfile` 中加入以下内容：
 ```
 pod 'MSCLunarDate'
 ``` 
  然后在终端中运行以下命令：
 ```
 pod install
 ```

# 使用方式

  ```
  // 阳历转农历
  NSDate *date = [NSDate date];
  MSCLunarDate *toLunarDate = [MSCLunarDate lunarDateWithDate:date];
  NSLog(@"lunarDate = %@", toLunarDate);
  ```
  
  ```
  // 农历转阳历
  MSCLunarDate *lunarDate = [MSCLunarDate lunarDate];
  lunarDate.year = 2020;
  lunarDate.month = 4;
  lunarDate.day = 3;
  lunarDate.bLeap = YES;
  NSDate *toDate = [lunarDate toSolarDate];
  NSLog(@"date = %@", toDate);
  ```

  
