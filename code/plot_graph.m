function [] = plot_graph(Y, E, trajectory_list)
    figure;
    
    
    
%     plot3(Y.coords{3}(1,:), ...
%           Y.coords{3}(2,:), ...
%           Y.coords{3}(3,:), ...
%           'o', ...
%           'MarkerFaceColor', [0.843 0.850 0.86],...
%           'Color', [0.843 0.850 0.86]);
    
    if isempty(trajectory_list)
        
        % this is an 2D embeddings plotting
        
        % defining distinct colors for each of the 16 trajectory
        colors = [0.12941176470588237, 0.06666666666666667, 0.18823529411764706;
                  0.11764705882352941, 0.12156862745098039, 0.2;
                  0.10980392156862745, 0.17647058823529413, 0.21176470588235294;
                  0.10196078431372549, 0.23137254901960785, 0.2235294117647059;
                  0.09411764705882353, 0.28627450980392155, 0.23529411764705882;
                  0.08627450980392157, 0.3411764705882353, 0.24705882352941178;
                  0.0784313725490196, 0.396078431372549, 0.25882352941176473;
                  0.07058823529411765, 0.45098039215686275, 0.27058823529411763;
                  0.06274509803921569, 0.5058823529411764, 0.2823529411764706;
                  0.054901960784313725, 0.5607843137254902, 0.29411764705882354;
                  0.047058823529411764, 0.615686274509804, 0.3058823529411765;
                  0.0392156862745098, 0.6705882352941176, 0.3176470588235294;
                  0.03137254901960784, 0.7254901960784313, 0.32941176470588235;
                  0.023529411764705882, 0.7803921568627451, 0.3411764705882353;
                  0.01568627450980392, 0.8352941176470589, 0.35294117647058826;
                  0.00784313725490196, 0.8901960784313725, 0.36470588235294116;
                  0.0, 0.9490196078431372, 0.3764705882352941];
        
        % plot graph edges
        gplot(E(Y.index, Y.index), [Y.coords{2}(1,:); Y.coords{2}(2,:)]', 'c'); 
        hold on;
        
        % making modifications when there < 16 trajectories
        %trajectory_list = linspace(0,15, 16);
        trajectory_list = [0,1];
        colors = [0.12941176470588237, 0.06666666666666667, 0.18823529411764706;
                  0.0, 0.9490196078431372, 0.3764705882352941];

        for i=1:length(trajectory_list)
            multiplier = trajectory_list(i);
            % the 30 below should be 80
            plot(Y.coords{2}(1,(30*multiplier)+1:(30*multiplier)+30),...
                  Y.coords{2}(2,(30*multiplier)+1:(30*multiplier)+30),...
                  'o',...
                  'MarkerFaceColor', colors(multiplier+1,:),...
                  'Color',           colors(multiplier+1,:))
        end
        
        title('Two-dimensional Isomap embedding (with neighborhood graph).'); 
        hold off;

    else
        % The non-empty trajectory list contains the trajectories to be
        % plotted

        if length(trajectory_list) > 5
            error("Trajectory List cannot be greater than 5");
        end
        colors = [1,   1,   0.2;...
                  0.28627450980392155,  0.5882352941176471,   0.7764705882352941;...
                  0.08235294117647059,  0.3176470588235294,   0.4666666666666667;...
                  0.047058823529411764, 0.1843137254901961,   0.26666666666666666;...
                  0.011764705882352941, 0.047058823529411764, 0.06666666666666667];
        
        % base plotting of all the trajectories
        plot3(Y.coords{3}(1,:),Y.coords{3}(2,:),Y.coords{3}(3,:), 'o', 'MarkerFaceColor', [0.86 0.86 0.86], 'Color', [0.86 0.86 0.86])
        hold on;
        
        
        % plotting all the mentioned trajectories
        for i=1:length(trajectory_list)
            multiplier = trajectory_list(i);
            plot3(Y.coords{3}(1,(30*multiplier)+1:(30*multiplier)+30),...
                  Y.coords{3}(2,(30*multiplier)+1:(30*multiplier)+30),...
                  Y.coords{3}(3,(30*multiplier)+1:(30*multiplier)+30),...
                  'o',...
                  'MarkerFaceColor', colors(mod(multiplier,5)+1,:),...
                  'Color',           colors(mod(multiplier,5)+1,:))
        end
        title(strcat('Three-dimensional Isomap embedding ', mat2str(trajectory_list))); 
        hold off;
        grid on;
    end
    
    
    
    
    
end



%     hold on
%     while multiplier < 5
% %         disp("range: ");
% %         disp(multiplier)
% %         disp((30*multiplier)+1);
% %         disp((30*multiplier)+30);
%         plot3(Y.coords{3}(1,(30*multiplier)+1:(30*multiplier)+30),...
%               Y.coords{3}(2,(30*multiplier)+1:(30*multiplier)+30),...
%               Y.coords{3}(3,(30*multiplier)+1:(30*multiplier)+30),...
%               'o',...
%               'MarkerFaceColor', colors(multiplier+1,:),...
%               'Color',           colors(multiplier+1,:))
%         multiplier = multiplier + 1;
%     end
%     hold off
%     
%     
%     
%     grid on
%     plot3(Y.coords{3}(1,:),Y.coords{3}(2,:),Y.coords{3}(3,:), 'o', 'MarkerFaceColor', [0.843 0.850 0.86], 'Color', [0.843 0.850 0.86])    
%     multiplier = 0;
%     % colors = [165, 176, 217;120, 137, 198;83, 101, 170;67, 81, 136;42, 51, 85];
%     colors = [0.6470588235294118, 0.6901960784313725, 0.8509803921568627;0.47058823529411764, 0.5372549019607843, 0.7764705882352941;0.3254901960784314, 0.396078431372549, 0.6666666666666666;0.2627450980392157, 0.3176470588235294, 0.5333333333333333;0.16470588235294117, 0.2, 0.3333333333333333];
% 
%    