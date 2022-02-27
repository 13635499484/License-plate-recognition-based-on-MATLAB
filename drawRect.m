function re_img = drawRect(boxes,img,flag)
%% 传入bboxes信息，和原图，在原图上进行标记
if nargin<3
    flag=0;
end
[w,h,c]=size(img);
scale = min(w,h);
ftsize = max(2*(scale-mod(scale,100))/100,8);
ftsize = min(ftsize,25);
re_img = insertObjectAnnotation(img,'rectangle',...
        boxes,[""],...
        'LineWidth',3,...
        'FontSize',ftsize);

if flag==1
    figure();
    imshow(re_img);
end

end