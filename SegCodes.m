function [strs,key] = SegCodes(img_slice)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% 1.预处理图片
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
strs=[];
% img_slice = jiaozheng(img_slice);
img=img_slice;%输入原始图像
key = true;
I = rgb2gray(img);
I1 = imbinarize(I);
I1 = imfill(I1,'holes');
se = strel('disk',1);
I1 = imerode(I1,se);
I1 = bwareaopen(I1,100);
% imshow(I1);
[c,n] = bwlabel(I1);
ups = [];
downs = [];
for i=1:n
    tmp = c==i;
    bbox = GetBox(tmp);
    ups(i) = bbox(1);
    downs(i) = bbox(3);
end
%% 求相似众数去除上下边框
up_cals = zeros([1,n]);
down_cals = zeros([1,n]);
for i=1:n
    for j=1:n
        if abs((ups(j)-ups(i)))/ups(i)<0.1
            up_cals(i) = up_cals(i)+1;
        end
         if abs((downs(j)-downs(i)))/downs(i)<0.1
            down_cals(i) = down_cals(i)+1;
         end
    end
end

up_idx = up_cals==max(up_cals);
down_idx = down_cals==max(down_cals);

up_val = floor(mean(ups(up_idx)));
down_val = floor(mean(downs(down_idx)));
slice = img(up_val:down_val,:,:);
[w,h,c] = size(slice);
k = 50/w;
slice = imresize(slice,[w,floor(h*k)]);
% imshow(slice);
%% 根据小圆点定位分割字符
gray = rgb2gray(slice);
im = imbinarize(gray);
se = strel('disk',2);
im_tmp = imdilate(im,se);
im_tmp = bwareaclose(im_tmp,200);
im_tmp = bwareaopen(im_tmp,50);
% imshow(im);
% imshow(im_tmp);
[c,n] = bwlabel(im_tmp);
[h,w]=size(im_tmp);
ke=false;
for i=1:n
    tmp = c==i;
    resmat = GetBox(tmp);
    loc = floor((resmat(2)+resmat(4))/2);
    if loc<w/4 || loc>w/3
        ke=false;
    else
        ke=true;
        break;
    end 
end
if ~ke
    key=false;
    return
end

im2_t = im(:,1:loc);
im5_t = im(:,loc:end);

im2 = bwareaopen(im2_t,50);
im5 = bwareaopen(im5_t,50);
im2 = imdilate(im2,se);
im5 = imdilate(im5,se);
im2 = imfill(im2,'holes');
im5 = imfill(im5,'holes');
% subplot(1,2,1),imshow(im2),subplot(1,2,2),imshow(im5);

%%%%%% 分割字符（垂直投影法）
% im2_w = sum(im2,1);
% im2_w = repmat(im2_w,2,1);
% im5_w = sum(im5,1);
% im5_w = repmat(im5_w,2,1);
% subplot(1,2,1),plot(im2_w),subplot(1,2,2),,plot(im5_w);
% subplot(1,2,1),imshow(im2_w),subplot(1,2,2),imshow(im5_w);
% 从右到左分割前两个字符
[c,n0] = bwlabel(im2);
if n0<2
    key=false;
end
strs=zeros([50,20,7]);
j=0;
for i=n0:-1:1
    if j==2
        break
    end
    resmat = GetBox(c==i);
    tm = im2_t(:,resmat(2):resmat(4));
    strs(:,:,i) = imresize(tm,[50,20]);
%     figure(),imshow(tm);
    j=j+1;
end
% 从左到右分割后五个字符
[c,n1] = bwlabel(im5);
if n1<5
    key=false;
end

for i=1:n1
    if i>5
        break
    end
    resmat = GetBox(c==i);
    tm = im5_t(:,resmat(2):resmat(4));
    resmat = GetBox(tm);
    tm = tm(resmat(1):resmat(3),resmat(2):resmat(4));
    strs(:,:,i+2) = imresize(tm,[50,20]);
%         figure(),imshow(tm);
end
% imshow(reshape(strs,[50,140]));
end