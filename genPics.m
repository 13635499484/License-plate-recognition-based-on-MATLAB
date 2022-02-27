function genPics(video_path)
    % video_path = "十段视频\\1.mp4";
    video = VideoReader(video_path);
    video_name = split(video_path,'\');
    video_name = video_name{length(video_name)};
    Item_key = 1;
    if ~isempty(video)
%         msgbox("read successfully");
        nframe = video.NumberOfframe;
        k=1;
        while k<nframe
            frame = read(video,k);
            save_name = strcat(video_name,"_",num2str(k),".jpg");
            save_path = fullfile("MorePics0",save_name);
            k=k+20;
%             frame = imresize(frame,[256,256]);
            imwrite(frame,save_path);

        end
    else
        msgbox("The video does not exist");
    end
end
