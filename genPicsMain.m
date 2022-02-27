clc
clear all;
close all;

list = dir("10段视频");

for i=3:length(list)
    disp(i)
    video_path = fullfile(list(i).folder,list(i).name);
    genPics(video_path);
end