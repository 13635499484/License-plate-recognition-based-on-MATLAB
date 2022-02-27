function [st0,st1,chs,ens]=GetDb()
num=30;
store0 = char(['闽青']);
store1 = char(['0':'9' 'A':'H' 'J':'N' 'P':'Z' ]);
[st0,st1,chs,ens]=readChEn(store0,store1,num);
end