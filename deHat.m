function [re_img,img_slice,key]=deHat(detector,img,flag)
%% 使用检测模型以及识别模型对图片进行检测和识别
    if nargin<3
        flag=0;
    end
    %% 测试图像
    [boxes,scores] = detect(detector,img);%%
    %% 调整矩形框
    if(~isempty(boxes))
        key = true;
        x = boxes(1,2);
        y = boxes(1,1);
        h = boxes(1,4);
        w = boxes(1,3); 
%         w = w+10;
        if h+w>size(img,2)
            w = size(img,2)-h;
        end
        img_slice = img(x:x+h,y:y+w,:);
        boxes=[y,x,w,h];
        re_img = drawRect(boxes,img,flag);
%         imshow(re_img);
%         imshow(img_slice);
%         codes_res = segCodes(img_slice);
    else
        key=false;
        img_slice = false;
        re_img=img;
    end    
end
