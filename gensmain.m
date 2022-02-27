clc
clear all
close all

load models\obj_model.mat;
list = dir("10段视频");

for i=3:length(list)
    disp(i)
    video_path = fullfile(list(i).folder,list(i).name);
    gens(detector,video_path);
end


function gens(detector,vid_path)
% vid_path = "十段视频\\1.mp4";
    video = VideoReader(vid_path);
    video_name = split(vid_path,'\');
    video_name = video_name{length(video_name)};
    if ~isempty(video)
%         msgbox("read successfully");
        nframe = video.NumberOfframe;
        k=1;
        while k<nframe
            frame = read(video,k);
            save_name = strcat(video_name,"_",num2str(k),".jpg");
            save_path = fullfile("MB",save_name);
            k=k+10;
            hanzi = GenPlate(detector,frame,1);
            if ~isempty(hanzi)
                imwrite(hanzi,save_path);
            end
        end
    else
        msgbox("The video does not exist");
    end


    
    
    
    

function hanzi=GenPlate(detector,img,flag)
    [~,img_slice,key] = deHat(detector,img,0);
    if key
        [strs,key] = SegCodes(img_slice);
        if key
            hanzi = strs(:,:,1);
            if flag
                imshow(hanzi);
            end
        else
            hanzi = [];
%             msgbox('the codes can not be extracted because of the poor quality of pic');
        end
    else
%         msgbox('there is no plate detected.'); 
        hanzi = [];
    end
end


end


