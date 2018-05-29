function plot_brt(time,brt,receiver_name)
    global dateStr;global figure_num;
    figure_num = figure_num + 1;
    average_value = mean(brt);
    std_value = std(brt);
    pp_value = max(brt) - min(brt);
    xData = linspace(time(1),time(end),5);
    channel_num = 0;
    for num = 1:2
        figure('name',[num2str(num),receiver_name,'-亮温曲线']);
        for fig_num = 1 : 4
            channel_num = channel_num + 1;
            subplot(2,2,fig_num);
            plot(datenum(time) ,brt(:,channel_num));
            ax = gca;
            ax.XTick = datenum(xData);
            datetick(ax,'x','HH:MM','keepticks');
            minValue = floor(min(brt(:,channel_num))*10)/10;maxValue= max(ceil(brt(:,channel_num)));
            if maxValue - minValue <= 2
                maxValue = minValue + 1;
                set(gca,'ytick',minValue:0.2:maxValue);
            end
            set(gca, 'Ylim', [minValue maxValue]);
            xlabel('时间/(时:分)');
            ylabel('亮温/K');
            title(['通道',num2str(channel_num)]);
            set(gca,'FontSize',14);
            grid on;
            hold on;
        end
        suptitle([receiver_name,...
            '波段接收机各通道的亮温曲线（测量日期：',dateStr,'）']);
        set (gcf,'Position',[100,100,1000,800], 'color','w');
        saveas(gcf,[dateStr,'-f',num2str(figure_num)],'png');
        hold off;        
    end
    if receiver_name == 'k' || receiver_name == 'K'
        K_data_brt = [average_value;std_value;pp_value];
        save('data_brt.mat', 'K_data_brt');
    else
        V_data_brt = [average_value;std_value;pp_value];
        save('data_brt.mat', 'V_data_brt','-append');
    end
end