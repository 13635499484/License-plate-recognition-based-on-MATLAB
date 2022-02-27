function detector = trainModel(img_labeled_path)

%% 读取数据
ds = load(img_labeled_path);
path_list = ds.gTruth.DataSource.Source;%提取文件列表
label_list = ds.gTruth.LabelData;%提取标签列表
imgds = imageDatastore(path_list);
blbs = boxLabelDatastore(label_list);
ds = combine(imgds, blbs);
%% 加载模型
lgraph = buildLgraph([256,256]);
%% %% 训练参数
options = trainingOptions('sgdm',...
          'InitialLearnRate',0.001,...
          'Verbose',true,...
          'MiniBatchSize',16,...
          'MaxEpochs',50,...
          'VerboseFrequency',30,...
          "Plots","training-progress",...
          'CheckpointPath',tempdir);
%% 训练
[detector,info] = trainYOLOv2ObjectDetector(ds,lgraph,options);
save('models\\obj_model.mat','detector');%保存训练好的模型
%% 查看训练loss
figure();
plot(info.TrainingLoss);
grid on;
xlabel('Number of Iterations');
ylabel('Training Loss for Each Iteration');
end