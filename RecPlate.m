function [re_img,texts]=RecPlate(detector,img,st0,chs,st1,ens,flag)
    [re_img,img_slice,key] = deHat(detector,img,0);
    if key
        [strs,key] = SegCodes(img_slice);
        if key
            texts = decCodes(strs,st0,chs,st1,ens);
            seg_codes = reshape(strs,[50,140]);
            if flag
                imshow(seg_codes),title(texts);
            end
        else
            texts = '0';
%             msgbox('the codes can not be extracted because of the poor quality of pic');
        end
    else
%         msgbox('there is no plate detected.'); 
        texts = '0';
    end
end