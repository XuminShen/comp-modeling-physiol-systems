classdef HW_1_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        Y2Spinner                       matlab.ui.control.Spinner
        Y2SpinnerLabel                  matlab.ui.control.Label
        X2Spinner                       matlab.ui.control.Spinner
        X2SpinnerLabel                  matlab.ui.control.Label
        Y1Spinner                       matlab.ui.control.Spinner
        Y1SpinnerLabel                  matlab.ui.control.Label
        X1Spinner                       matlab.ui.control.Spinner
        X1SpinnerLabel                  matlab.ui.control.Label
        PLAYButton                      matlab.ui.control.Button
        SAVEasEDButton                  matlab.ui.control.Button
        VideoButtonGroup                matlab.ui.container.ButtonGroup
        ShortAxis_PapaviButton          matlab.ui.control.RadioButton
        ShortAxis_MitralValveaviButton  matlab.ui.control.RadioButton
        ShortAxis_ApexaviButton         matlab.ui.control.RadioButton
        Apical4chaviButton              matlab.ui.control.RadioButton
        SAVEasESButton                  matlab.ui.control.Button
        TimelineSlider                  matlab.ui.control.Slider
        TimelineSliderLabel             matlab.ui.control.Label
        UIAxes_2                        matlab.ui.control.UIAxes
        UIAxes                          matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
%         obj = VideoReader('ShortAxis_MitralValve.avi');
        video = VideoReader('ShortAxis_MitralValve.avi').read();
%         video_size = size(video);

    end
    
    methods (Access = private)
        
        function [] = plot_point_line(app)
            plot_2(app)
%             text(app.UIAxes,app.X1Spinner.Value,app.Y1Spinner.Value,'\Delta','Color','red','FontSize',14)
%             text(app.UIAxes,app.X2Spinner.Value,app.Y2Spinner.Value,'\diamondsuit','Color','green','FontSize',14)
%             text(app.UIAxes_2,app.X1Spinner.Value,app.Y1Spinner.Value,'\Delta','Color','red','FontSize',14)
            x1 = app.X1Spinner.Value;
            x2 = app.X2Spinner.Value;
            y1 = app.Y1Spinner.Value;
            y2 = app.Y2Spinner.Value;
            length_points = sqrt((x1-x2)^2+(y1-y2)^2)/48.7955;
            if app.VideoButtonGroup.SelectedObject.Text == "Apical4ch.avi"
                length_points = length_points*1.5;
            end

            text(app.UIAxes,mean([x1,x2]),mean([y1,y2]),num2str(length_points),'Color','green','FontSize',10)
            text(app.UIAxes_2,mean([x1,x2]),mean([y1,y2]),num2str(length_points),'Color','green','FontSize',10)
            line(app.UIAxes,[x1,x2],[y1,y2],'Color','white','LineStyle',':','LineWidth',1,'Marker','.','MarkerSize',10)
            line(app.UIAxes_2,[x1,x2],[y1,y2],'Color','white','LineStyle',':','LineWidth',1,'Marker','.','MarkerSize',10)
            
        end
        
        function [] = plot_2(app)
                kernal = [0,1,0;1,-4,1;0,1,0];
                t = app.TimelineSlider.Value;
                t = round(t);
                image(app.UIAxes, app.video(:,:,:,t))
                edge = uint8(conv2(app.video(:,:,2,t)/255,kernal)*255);
                image(app.UIAxes_2, reshape([edge,edge,edge],[size(edge),3]))
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)

            kernal = [0,1,0;1,-4,1;0,1,0];

            image(app.UIAxes, app.video(:,:,:,1))
            edge = uint8(conv2(app.video(:,:,2,1)/255,kernal)*255);
            image(app.UIAxes_2, reshape([edge,edge,edge],[size(edge),3]))
        end

        % Value changing function: TimelineSlider
        function TimelineSliderValueChanging2(app, event)
            changingValue = event.Value;
            changingValue = floor(changingValue);
            kernal = [0,1,0;1,-4,1;0,1,0];
            image(app.UIAxes, app.video(:,:,:,changingValue))
            edge = uint8(conv2(app.video(:,:,2,changingValue)/255,kernal)*255);
            image(app.UIAxes_2, reshape([edge,edge,edge],[size(edge),3]))
        end

        % Button pushed function: SAVEasESButton
        function SAVEasESButtonPushed(app, event)
            filename = app.VideoButtonGroup.SelectedObject.Text;
            filename = filename(1:end-4);
            filename = [filename,'_ES.png'];
            fig = figure;
            fig.Visible = 'off';
            figAxes = axes(fig);
            % Copy all UIAxes children, take over axes limits and aspect ratio.            
            allChildren = app.UIAxes.XAxis.Parent.Children;
            copyobj(allChildren, figAxes)
            figAxes.XLim = app.UIAxes.XLim;
            figAxes.YLim = app.UIAxes.YLim;
            figAxes.ZLim = app.UIAxes.ZLim;
            figAxes.DataAspectRatio = app.UIAxes.DataAspectRatio;
%             lgndName1 = app.UIAxes.Legend.String{1};
%             lgd = legend(lgndName1);
%             lgd.Box = app.UIAxes.Legend.Box;
%             lgd.Location = app.UIAxes.Legend.Location;
            fig.CurrentAxes.YLabel.String = app.UIAxes.YLabel.String;
            fig.CurrentAxes.YLabel.FontSize = app.UIAxes.YLabel.FontSize;
            fig.CurrentAxes.XLabel.String = app.UIAxes.XLabel.String;
            fig.CurrentAxes.XLabel.FontSize = app.UIAxes.XLabel.FontSize;
            fig.CurrentAxes.Title.String = app.UIAxes.Title.String;
            fig.CurrentAxes.Title.FontSize = app.UIAxes.Title.FontSize;
%             axis off
            set(gca,'YDir','reverse') ;
            % Save as png and fig files.
            saveas(fig, filename);
%             savefig(fig, filename);
            % Delete the temporary figure.
            delete(fig);
        end

        % Selection changed function: VideoButtonGroup
        function VideoButtonGroupSelectionChanged(app, event)
            selectedButton = app.VideoButtonGroup.SelectedObject.Text;
            app.video = VideoReader(selectedButton).read();
            video_size = size(app.video);

            app.TimelineSlider.Limits = [1,video_size(4)];
            plot_2(app)
%             kernal = [0,1,0;1,-4,1;0,1,0];
%             changingValue = app.TimelineSlider.Value;
%             changingValue = round(changingValue);
%             image(app.UIAxes, app.video(:,:,:,changingValue))
%             edge = uint8(conv2(app.video(:,:,2,changingValue)/255,kernal)*255);
%             image(app.UIAxes_2, reshape([edge,edge,edge],[size(edge),3]))
        end

        % Button pushed function: SAVEasEDButton
        function SAVEasEDButtonPushed(app, event)
            filename = app.VideoButtonGroup.SelectedObject.Text;
            filename = filename(1:end-4);
            filename = [filename,'_ED.png'];
            fig = figure;
            fig.Visible = 'off';
            figAxes = axes(fig);
            % Copy all UIAxes children, take over axes limits and aspect ratio.            
            allChildren = app.UIAxes.XAxis.Parent.Children;
            copyobj(allChildren, figAxes)
            figAxes.XLim = app.UIAxes.XLim;
            figAxes.YLim = app.UIAxes.YLim;
            figAxes.ZLim = app.UIAxes.ZLim;
            figAxes.DataAspectRatio = app.UIAxes.DataAspectRatio;
%             lgndName1 = app.UIAxes.Legend.String{1};
%             lgd = legend(lgndName1);
%             lgd.Box = app.UIAxes.Legend.Box;
%             lgd.Location = app.UIAxes.Legend.Location;
            fig.CurrentAxes.YLabel.String = app.UIAxes.YLabel.String;
            fig.CurrentAxes.YLabel.FontSize = app.UIAxes.YLabel.FontSize;
            fig.CurrentAxes.XLabel.String = app.UIAxes.XLabel.String;
            fig.CurrentAxes.XLabel.FontSize = app.UIAxes.XLabel.FontSize;
            fig.CurrentAxes.Title.String = app.UIAxes.Title.String;
            fig.CurrentAxes.Title.FontSize = app.UIAxes.Title.FontSize;
%             axis off
            set(gca,'YDir','reverse') ;
            % Save as png and fig files.
            saveas(fig, filename);
%             savefig(fig, filename);
            % Delete the temporary figure.
            delete(fig);
        end

        % Button pushed function: PLAYButton
        function PLAYButtonPushed(app, event)
            time = app.TimelineSlider.Limits(2);
            for i = 1:time
                app.TimelineSlider.Value = i;
                plot_2(app)
                pause(1/12);
            end
        end

        % Value changed function: X1Spinner
        function X1SpinnerValueChanged(app, event)
            plot_point_line(app)
            
        end

        % Value changed function: Y1Spinner
        function Y1SpinnerValueChanged(app, event)
            plot_point_line(app)
            
        end

        % Value changed function: X2Spinner
        function X2SpinnerValueChanged(app, event)
            plot_point_line(app)
            
        end

        % Value changed function: Y2Spinner
        function Y2SpinnerValueChanged(app, event)
            plot_point_line(app)
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Original Video')
            app.UIAxes.XLim = [0 800];
            app.UIAxes.YLim = [0 600];
            app.UIAxes.XColor = 'none';
            app.UIAxes.XTick = [];
            app.UIAxes.YColor = 'none';
            app.UIAxes.YTick = [];
            app.UIAxes.ZColor = 'none';
            app.UIAxes.ZTick = [];
            app.UIAxes.Position = [52 208 262 246];

            % Create UIAxes_2
            app.UIAxes_2 = uiaxes(app.UIFigure);
            title(app.UIAxes_2, 'Edge Detection')
            app.UIAxes_2.XLim = [0 800];
            app.UIAxes_2.YLim = [0 600];
            app.UIAxes_2.XColor = 'none';
            app.UIAxes_2.XTick = [];
            app.UIAxes_2.YColor = 'none';
            app.UIAxes_2.YTick = [];
            app.UIAxes_2.ZColor = 'none';
            app.UIAxes_2.ZTick = [];
            app.UIAxes_2.Position = [338 208 262 246];

            % Create TimelineSliderLabel
            app.TimelineSliderLabel = uilabel(app.UIFigure);
            app.TimelineSliderLabel.HorizontalAlignment = 'right';
            app.TimelineSliderLabel.Position = [26 155 50 22];
            app.TimelineSliderLabel.Text = 'Timeline';

            % Create TimelineSlider
            app.TimelineSlider = uislider(app.UIFigure);
            app.TimelineSlider.Limits = [1 72];
            app.TimelineSlider.ValueChangingFcn = createCallbackFcn(app, @TimelineSliderValueChanging2, true);
            app.TimelineSlider.Position = [97 164 503 7];
            app.TimelineSlider.Value = 1;

            % Create SAVEasESButton
            app.SAVEasESButton = uibutton(app.UIFigure, 'push');
            app.SAVEasESButton.ButtonPushedFcn = createCallbackFcn(app, @SAVEasESButtonPushed, true);
            app.SAVEasESButton.Position = [492 23 109 44];
            app.SAVEasESButton.Text = 'SAVE as ES';

            % Create VideoButtonGroup
            app.VideoButtonGroup = uibuttongroup(app.UIFigure);
            app.VideoButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @VideoButtonGroupSelectionChanged, true);
            app.VideoButtonGroup.Title = 'Video';
            app.VideoButtonGroup.Position = [27 9 144 126];

            % Create Apical4chaviButton
            app.Apical4chaviButton = uiradiobutton(app.VideoButtonGroup);
            app.Apical4chaviButton.Text = 'Apical4ch.avi';
            app.Apical4chaviButton.Position = [11 88 93 22];

            % Create ShortAxis_ApexaviButton
            app.ShortAxis_ApexaviButton = uiradiobutton(app.VideoButtonGroup);
            app.ShortAxis_ApexaviButton.Text = 'ShortAxis_Apex.avi';
            app.ShortAxis_ApexaviButton.Position = [11 65 126 22];

            % Create ShortAxis_MitralValveaviButton
            app.ShortAxis_MitralValveaviButton = uiradiobutton(app.VideoButtonGroup);
            app.ShortAxis_MitralValveaviButton.Text = 'ShortAxis_MitralValve.avi';
            app.ShortAxis_MitralValveaviButton.Position = [11 40 157 22];

            % Create ShortAxis_PapaviButton
            app.ShortAxis_PapaviButton = uiradiobutton(app.VideoButtonGroup);
            app.ShortAxis_PapaviButton.Text = 'ShortAxis_Pap.avi';
            app.ShortAxis_PapaviButton.Position = [12 13 120 22];
            app.ShortAxis_PapaviButton.Value = true;

            % Create SAVEasEDButton
            app.SAVEasEDButton = uibutton(app.UIFigure, 'push');
            app.SAVEasEDButton.ButtonPushedFcn = createCallbackFcn(app, @SAVEasEDButtonPushed, true);
            app.SAVEasEDButton.Position = [492 75 109 44];
            app.SAVEasEDButton.Text = 'SAVE as ED';

            % Create PLAYButton
            app.PLAYButton = uibutton(app.UIFigure, 'push');
            app.PLAYButton.ButtonPushedFcn = createCallbackFcn(app, @PLAYButtonPushed, true);
            app.PLAYButton.FontSize = 18;
            app.PLAYButton.FontWeight = 'bold';
            app.PLAYButton.Position = [211 22 117 96];
            app.PLAYButton.Text = 'PLAY';

            % Create X1SpinnerLabel
            app.X1SpinnerLabel = uilabel(app.UIFigure);
            app.X1SpinnerLabel.HorizontalAlignment = 'right';
            app.X1SpinnerLabel.Position = [359 110 46 22];
            app.X1SpinnerLabel.Text = 'X-1';

            % Create X1Spinner
            app.X1Spinner = uispinner(app.UIFigure);
            app.X1Spinner.ValueChangedFcn = createCallbackFcn(app, @X1SpinnerValueChanged, true);
            app.X1Spinner.Position = [420 107 70 27];
            app.X1Spinner.Value = 400;

            % Create Y1SpinnerLabel
            app.Y1SpinnerLabel = uilabel(app.UIFigure);
            app.Y1SpinnerLabel.HorizontalAlignment = 'right';
            app.Y1SpinnerLabel.Position = [359 79 46 22];
            app.Y1SpinnerLabel.Text = 'Y-1';

            % Create Y1Spinner
            app.Y1Spinner = uispinner(app.UIFigure);
            app.Y1Spinner.ValueChangedFcn = createCallbackFcn(app, @Y1SpinnerValueChanged, true);
            app.Y1Spinner.Position = [420 76 70 27];
            app.Y1Spinner.Value = 400;

            % Create X2SpinnerLabel
            app.X2SpinnerLabel = uilabel(app.UIFigure);
            app.X2SpinnerLabel.HorizontalAlignment = 'right';
            app.X2SpinnerLabel.Position = [359 48 46 22];
            app.X2SpinnerLabel.Text = 'X-2';

            % Create X2Spinner
            app.X2Spinner = uispinner(app.UIFigure);
            app.X2Spinner.ValueChangedFcn = createCallbackFcn(app, @X2SpinnerValueChanged, true);
            app.X2Spinner.Position = [420 45 70 27];
            app.X2Spinner.Value = 400;

            % Create Y2SpinnerLabel
            app.Y2SpinnerLabel = uilabel(app.UIFigure);
            app.Y2SpinnerLabel.HorizontalAlignment = 'right';
            app.Y2SpinnerLabel.Position = [359 17 46 22];
            app.Y2SpinnerLabel.Text = 'Y-2';

            % Create Y2Spinner
            app.Y2Spinner = uispinner(app.UIFigure);
            app.Y2Spinner.ValueChangedFcn = createCallbackFcn(app, @Y2SpinnerValueChanged, true);
            app.Y2Spinner.Position = [420 14 70 27];
            app.Y2Spinner.Value = 400;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = HW_1_exported

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