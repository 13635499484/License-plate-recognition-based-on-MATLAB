function area = getarea(bw,imb_tmp)
    resmat = GetBox(bw);
    area = imb_tmp(resmat(1):resmat(3),resmat(2):resmat(4));
%     imshow(area);
    area = imresize(area,[50,50]);
end
