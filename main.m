clc;
clear all;
close all;

%% 训练模型
img_labeled_path = 'labels.mat';%%标签路径

if ~isfile('models\obj_model.mat')%判断当前路径是否存在检测模型，如果存在，则不训练
    disp('未检测到当前路径已经训练好车牌检测检测的模型，开始训练');
    detector = trainModel(img_labeled_path);
else
   disp('检测到当前路径已经训练好的车牌检测模型，读取模型');
   load  'models\obj_model.mat';%存在模型，直接载入
end

num=30;
store0 = char(['闽青']);
store1 = char(['0':'9' 'A':'H' 'J':'N' 'P':'Z' ]);
[st0,st1,chs,ens]=readChEn(store0,store1,num);

%% 
for i=1:8
   img = imread(fullfile("test",strcat(num2str(i),".png")));  
   [re_img,texts]=RecPlate(detector,img,st0,chs,st1,ens,0);
   figure(),imshow(re_img),title(texts);
end

% close all