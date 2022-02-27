function resmat=GetBox(IM)
%输入二值图，获取外接矩形框坐标
    [w,h]=size(IM);
    loc = find(IM==1);
    ws = [];
    hs = [];
    for i =1:length(loc)
        ws(i)=mod(loc(i,1),w);
        hs(i)=(loc(i,1)-ws(i))/w;
    end
    resmat = [min(ws),min(hs),max(ws),max(hs)];
    if ~isnan(resmat)
        if resmat(1)==0
            resmat(1)=1;
        end

        if resmat(2)==0
            resmat(2)=1;
        end

        if resmat(3)==0
            resmat(2)=w/2;
        end

        if resmat(4)==0
            resmat(4)=h/2;
        end
    end
    
    % imshow(IM(resmat(1):resmat(3),resmat(2):resmat(4)))
end

