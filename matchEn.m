function texts = matchEn(strs,st1,ens,num)
n = size(ens,3);
texts='';
% imshow(strs);
ns = size(strs,3);
for i=1:ns
    str_temp = strs(:,:,i);
%     imshow(str_temp);
    res = abs(str_temp-ens);
    res = sum(res,1);
    res = sum(res,2);
    res = reshape(res,1,[]);
    [b,idx] = sort(res);
    idx = idx(1:20);
    idx = ceil(idx/num);
    md = mode(idx);
    res_idx=md;
    if idx(1)~=md
        tmmd = sum(idx==idx(1));
        if tmmd==md
            res_idx=tmmd;
        end
    end
    texts(i) = st1(res_idx);
end
end