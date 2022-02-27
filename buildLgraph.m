function lgraph = buildLgraph(ipt_shape)
% 创建层次图
% 创建层次图变量以包含网络层。
lgraph = layerGraph();

% 添加层分支
% 将网络分支添加到层次图中。每个分支均为一个线性层组。
tempLayers = [
    imageInputLayer([ipt_shape(1) ipt_shape(2) 3],"Name","input","Normalization","none")
    convolution2dLayer([4 4],32,"Name","conv","Padding","same","Stride",[2 2])];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    batchNormalizationLayer("Name","BN1_2")
    reluLayer("Name","relu_1_2")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","addition_1")
    convolution2dLayer([3 3],16,"Name","conv_1","Padding",[1 1 1 1],"WeightsInitializer","narrow-normal")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    batchNormalizationLayer("Name","BN1_1")
    reluLayer("Name","relu_1_1")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","addition_2")
    maxPooling2dLayer([2 2],"Name","maxpool1","Stride",[2 2])
    convolution2dLayer([3 3],32,"Name","conv_2","Padding",[1 1 1 1],"WeightsInitializer","narrow-normal")
    batchNormalizationLayer("Name","BN2")
    reluLayer("Name","relu_2")
    maxPooling2dLayer([2 2],"Name","maxpool2","Stride",[2 2])
    convolution2dLayer([3 3],64,"Name","conv_3","Padding",[1 1 1 1],"WeightsInitializer","narrow-normal")
    batchNormalizationLayer("Name","BN3")
    reluLayer("Name","relu_3")
    maxPooling2dLayer([2 2],"Name","maxpool3","Stride",[2 2])
    convolution2dLayer([3 3],128,"Name","conv_4","Padding",[1 1 1 1],"WeightsInitializer","narrow-normal")
    batchNormalizationLayer("Name","BN4")
    reluLayer("Name","relu_4")
    convolution2dLayer([3 3],128,"Name","yolov2Conv1","Padding","same","WeightsInitializer","narrow-normal")
    batchNormalizationLayer("Name","yolov2Batch1")
    reluLayer("Name","yolov2Relu1")
    convolution2dLayer([3 3],128,"Name","yolov2Conv2","Padding","same","WeightsInitializer","narrow-normal")
    batchNormalizationLayer("Name","yolov2Batch2")
    reluLayer("Name","yolov2Relu2")
    convolution2dLayer([1 1],24,"Name","yolov2ClassConv","WeightsInitializer","narrow-normal")
    yolov2TransformLayer(4,"Name","yolov2Transform")
    yolov2OutputLayer([8 8;32 48;40 24;72 48],"Name","yolov2OutputLayer")];
lgraph = addLayers(lgraph,tempLayers);

% % 清理辅助函数变量
clear tempLayers;

% 连接层分支
% 连接网络的所有分支以创建网络图。
lgraph = connectLayers(lgraph,"conv","BN1_2");
lgraph = connectLayers(lgraph,"conv","addition_1/in2");
lgraph = connectLayers(lgraph,"relu_1_2","addition_1/in1");
lgraph = connectLayers(lgraph,"conv_1","BN1_1");
lgraph = connectLayers(lgraph,"conv_1","addition_2/in2");
lgraph = connectLayers(lgraph,"relu_1_1","addition_2/in1");

% 绘制层
% plot(lgraph);
end