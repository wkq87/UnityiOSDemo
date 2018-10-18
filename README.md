# UnityiOSDemo
这个demo会把平时用到的unity调用iOS的例子加进来，主要是unity和iOS之间的一些调用！
＜/br＞1、keychain
＜/br＞keychain的使用场景：理论上我们保存一个数据到手机本地存储空间，如果应用卸载后，数据就会丢失。但是用keychain保存数据，数据在应用卸载后，仍然可以恢复。
＜/br＞具体在xcode中使用时，在target -> Capabilities里面，需要打开Keychain Sharing的标签即可
＜/br＞在General中，需要加入Security.framework。
＜/br＞调用非常简单
＜/br＞SaveDataInstanceCtrl.instance.SaveData(key,value);
＜/br＞SaveDataInstanceCtrl.instance.GetDataByKey(key);
