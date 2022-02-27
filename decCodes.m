function texts = decCodes(strs,st0,chs,st1,ens,num)   
%% 模板匹配识别数字和英文
if nargin<6
    num=30;
end

  tex = matchEn(strs(:,:,1),st0,chs,num);
  tex0 = matchEn(strs(:,:,2:end),st1,ens,num);
  texts = strcat(tex,tex0);
  
end