function plot_brt(brt,receiver_name)
    load checkdata_xtick.mat xticklabel
    load('checkdata_num.mat','lineNum', 'splitNum', 'timeNum');
    global dateStr;
    channel_num = 0;
    for num = 1:2
        figure('name',[num2str(num),receiver_name,'-亮温曲线']);
        for fig_num = 1 : 4
            channel_num = channel_num + 1;
            average_value(channel_num) = mean(brt(:,channel_num));
            std_value(channel_num) = std(brt(:,channel_num));
            pp_value(channel_num) = max(brt(:,channel_num)) - min(brt(:,channel_num));
            subplot(2,2,fig_num);
            plot(1:1:lineNum ,brt(:,channel_num));
            v_gca(fig_num) = gca;
            %set(gca,'xtick',MIN_VALUE:T_STEP:MAX_VALUE);
            set(gca,'xtick',1:splitNum:timeNum*splitNum +1);
            set(gca,'xticklabel',xticklabel);
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