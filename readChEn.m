function [st0,st1,chs,ens]=readChEn(store0,store1,num)
if nargin<1  
    store0 = char(['闽青']);
    store1 = char(['0':'9' 'A':'H' 'J':'N' 'P':'Z' ]);
end
[st0,chs] = getDataBase(store0,num);
[st1,ens] = getDataBase(store1,num);
end