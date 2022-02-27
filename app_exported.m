classdef app_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        TabGroup                    matlab.ui.container.TabGroup
        VideoTab                    matlab.ui.container.Tab
        RecResultsEditField         matlab.ui.control.EditField
        RecResultsEditFieldLabel    matlab.ui.control.Label
        exitButton                  matlab.ui.control.Button
        startButton                 matlab.ui.control.StateButton
        openButton                  matlab.ui.control.Button
        Video                       matlab.ui.control.UIAxes
        CamTab                      matlab.ui.container.Tab
        RecResultsEditField_2       matlab.ui.control.EditField
        RecResultsEditField_2Label  matlab.ui.control.Label
        exitButton_2                matlab.ui.control.Button
        startButton_2               matlab.ui.control.StateButton
        openButton_2                matlab.ui.control.Button
        Video_2                     matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        Property % Description
        detector
        st0
        st1
        chs
        ens
        recKey
        camkey
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            model=load('models\obj_model.mat');
            [app.st0,app.st1,app.chs,app.ens]=GetDb();
            app.detector = model.detector;
            app.recKey=false;
        end

        % Button pushed function: openButton
        function openButtonPushed(app, event)
            [file,path] = uigetfile({'*.mp4';'*.avi';'*.3gp';'*.*'},'MLR','open video');
            if ~file==0
                img_path = fullfile(path,file); 
                video =VideoReader(img_path);
                if ~isempty(video)
                    msgbox("read successfully");
                    nframe = video.NumberOfframe;
                    k=1;
                    while true
                        frame = read(video,k);
                        k=k+1;
                        if app.recKey
                            [frame,texts]=RecPlate(app.detector,frame,app.st0,app.chs,app.st1,app.ens,0);                          
                            if strcmp(texts,'0')
                                app.RecResultsEditField.Value = 'detecting';
                            else
                                app.RecResultsEditField.Value = texts;
                            end   
                        end
%                         frame= imresize(frame,[180 320]);%
                            cla(app.Video);
                            axis(app.Video, 'tight'); %%
                            image(app.Video,frame);
                            drawnow;
                        if k>=nframe
                            break;%%
                        end
                    end
                else
                    msgbox("The video does not exist");
                end
                
            end
        end

        % Value changed function: startButton
        function startButtonPushed(app, event)
            if app.recKey
                app.recKey=false;
                app.startButton.Text = 'start';
            else
                app.recKey=true;
                app.startButton.Text = 'stop';
            end
        end

        % Callback function: UIFigure, exitButton, exitButton_2
        function UIFigureCloseRequest(app, event)
            delete(app);
        end

        % Button pushed function: openButton_2
        function openButton_2Pushed(app, event)
            cam = ipcam('http://192.168.2.22:4747/video/mjpg.cgi');
            app.camkey=true;
%             h1=preview(cam);%预览视频
            while true
                frame=snapshot(cam);     %捕获图像（ctrl+x保存图像）
%                 frame=ycbcr2rgb(frame);
                if app.recKey
                    [frame,texts]=RecPlate(app.detector,frame,app.st0,app.chs,app.st1,app.ens,0);                          
                    if strcmp(texts,'0')
                        app.RecResultsEditField_2.Value = 'detecting';
                    else
                        app.RecResultsEditField_2.Value = texts;
                    end   
                end
                %                         frame= imresize(frame,[180 320]);%
                cla(app.Video_2);
                axis(app.Video_2, 'tight'); %%
                image(app.Video_2,frame);
                drawnow;
                if ~app.camkey
                    break;%%
                end
            end
            delete(cam); %删除对象
        end

        % Value changed function: startButton_2
        function startButton_2ValueChanged(app, event)
            if app.recKey
                app.recKey=false;
                app.startButton_2.Text = 'start';
            else
                app.recKey=true;
                app.startButton_2.Text = 'stop';
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 421 480];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 1 426 480];

            % Create VideoTab
            app.VideoTab = uitab(app.TabGroup);
            app.VideoTab.Title = 'Video';

            % Create Video
            app.Video = uiaxes(app.VideoTab);
            title(app.Video, 'video')
            app.Video.XTick = [];
            app.Video.YTick = [];
            app.Video.Position = [64 250 300 185];

            % Create openButton
            app.openButton = uibutton(app.VideoTab, 'push');
            app.openButton.ButtonPushedFcn = createCallbackFcn(app, @openButtonPushed, true);
            app.openButton.Position = [169 132 100 22];
            app.openButton.Text = 'open';

            % Create startButton
            app.startButton = uibutton(app.VideoTab, 'state');
            app.startButton.ValueChangedFcn = createCallbackFcn(app, @startButtonPushed, true);
            app.startButton.Text = 'start';
            app.startButton.Position = [170 86 100 22];

            % Create exitButton
            app.exitButton = uibutton(app.VideoTab, 'push');
            app.exitButton.ButtonPushedFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);
            app.exitButton.Position = [171 37 100 22];
            app.exitButton.Text = 'exit';

            % Create RecResultsEditFieldLabel
            app.RecResultsEditFieldLabel = uilabel(app.VideoTab);
            app.RecResultsEditFieldLabel.HorizontalAlignment = 'right';
            app.RecResultsEditFieldLabel.Position = [187 212 70 22];
            app.RecResultsEditFieldLabel.Text = 'Rec Results';

            % Create RecResultsEditField
            app.RecResultsEditField = uieditfield(app.VideoTab, 'text');
            app.RecResultsEditField.HorizontalAlignment = 'center';
            app.RecResultsEditField.Position = [172 178 100 22];
            app.RecResultsEditField.Value = 'X000000';

            % Create CamTab
            app.CamTab = uitab(app.TabGroup);
            app.CamTab.Title = 'Cam';

            % Create Video_2
            app.Video_2 = uiaxes(app.CamTab);
            title(app.Video_2, 'cam')
            app.Video_2.XTick = [];
            app.Video_2.YTick = [];
            app.Video_2.Position = [64 250 300 185];

            % Create openButton_2
            app.openButton_2 = uibutton(app.CamTab, 'push');
            app.openButton_2.ButtonPushedFcn = createCallbackFcn(app, @openButton_2Pushed, true);
            app.openButton_2.Position = [169 132 100 22];
            app.openButton_2.Text = 'open';

            % Create startButton_2
            app.startButton_2 = uibutton(app.CamTab, 'state');
            app.startButton_2.ValueChangedFcn = createCallbackFcn(app, @startButton_2ValueChanged, true);
            app.startButton_2.Text = 'start';
            app.startButton_2.Position = [170 86 100 22];

            % Create exitButton_2
            app.exitButton_2 = uibutton(app.CamTab, 'push');
            app.exitButton_2.ButtonPushedFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);
            app.exitButton_2.Position = [171 37 100 22];
            app.exitButton_2.Text = 'exit';

            % Create RecResultsEditField_2Label
            app.RecResultsEditField_2Label = uilabel(app.CamTab);
            app.RecResultsEditField_2Label.HorizontalAlignment = 'right';
            app.RecResultsEditField_2Label.Position = [187 212 70 22];
            app.RecResultsEditField_2Label.Text = 'Rec Results';

            % Create RecResultsEditField_2
            app.RecResultsEditField_2 = uieditfield(app.CamTab, 'text');
            app.RecResultsEditField_2.HorizontalAlignment = 'center';
            app.RecResultsEditField_2.Position = [172 178 100 22];
            app.RecResultsEditField_2.Value = 'X000000';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end