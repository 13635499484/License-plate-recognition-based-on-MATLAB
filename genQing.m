pics = dir('H:\zephyr\Documents\WeChat Files\wxid_ooxxtylplmbj12\FileStorage\File\2022-02\图片');
pics = pics(3:end);
ll = length(pics);
for i=11:ll
    path = fullfile(pics(i).folder,pics(i).name);
    savepath = fullfile('F:\Matlab\MLR\模板\青',pics(i).name);
    im = imread(path);
    gray = rgb2gray(im);
    im = imbinarize(gray);
    imwrite(im,savepath);
end