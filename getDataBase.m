function [store,data]=getDataBase(store,num)
    folder = '模板';
%     store = char(['0':'9' 'A':'H' 'J':'N' 'P':'Z' '沪京闽青苏粤浙']);
    data=zeros([50,20,num,length(store)]);
    for i=1:length(store)
        files = dir(fullfile(folder,store(i)));
        files = files(3:end);
        for j=1:num
            file_path = fullfile(folder,store(i),files(j).name);
            img = imread(file_path);
            if length(size(img))>2
                img = rgb2gray(img);
            end
            img = img*1;
            img = imbinarize(img,0.1);
            resmat = GetBox(img);
            img = img(resmat(1):resmat(3),resmat(2):resmat(4));
            img = imresize(img,[50,20]);
            data(:,:,j,i) = img;
        end
    end
    data = reshape(data,50,20,[]);
    
end