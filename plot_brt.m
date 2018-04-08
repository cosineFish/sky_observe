function plot_brt(brt,receiver_name)
    load checkdata_xtick.mat xticklabel
    load('checkdata_num.mat','lineNum', 'splitNum', 'timeNum');
    global dateStr;global figure_num;
    for channel_num = 1:8
        average_value(channel_num) = mean(brt(:,channel_num));
        std_value(channel_num) = std(brt(:,channel_num));
        min_value(channel_num) = min(brt(:,channel_num));
        max_value(channel_num) = max(brt(:,channel_num));
        pp_value(channel_num) = max_value(channel_num) - min_value(channel_num);
    end
    if receiver_name == 'k' || receiver_name == 'K'
        temp = [pp_value(1:4) pp_value(6:8)];
        brt_delta = ceil(max(temp) * 10) / 10.0;
    else
        brt_delta = ceil(max(pp_value) * 10) / 10.0;
    end
    channel_num = 0;
    for num = 1:2
        figure('name',[num2str(num),receiver_name,'-亮温曲线']);
        for fig_num = 1 : 4
            channel_num = channel_num + 1;
            subplot(2,2,fig_num);
            plot(1:1:lineNum ,brt(:,channel_num));
            v_gca(fig_num) = gca;
            %set(gca,'xtick',MIN_VALUE:T_STEP:MAX_VALUE);
            set(gca,'xtick',1:splitNum:timeNum*splitNum +1);
            set(gca,'xticklabel',xticklabel);
            minValue = floor(min_value(channel_num) * 10) / 10.0;
            maxValue = minValue + brt_delta;
            if minValue == maxValue
                brt_delta = 0.1;
            end
            ylnew = [minValue  maxValue];
            set(v_gca(fig_num), 'Ylim', ylnew);
            set(v_gca(fig_num),'ytick',minValue:(brt_delta/5):(minValue + brt_delta));
            xlabel('时间/(时:分)');
            ylabel('亮温/K');
            title(['通道',num2str(channel_num)]);
            set(gca,'FontSize',14);
            grid on;
            hold on;
        end
        suptitle([receiver_name,...
            '波段接收机各通道的亮温曲线（测量日期:',dateStr,'）']);
        set (gcf,'Position',[100,100,1000,800], 'color','w');
        hold off;
        figure_num = figure_num + 1;
        save2word([dateStr,'brt_report.doc'],['-f',num2str(figure_num)]);
    end
    if receiver_name == 'k' || receiver_name == 'K'
        K_data_brt = [average_value;std_value;pp_value];
        save('data_brt.mat', 'K_data_brt');
    else
        V_data_brt = [average_value;std_value;pp_value];
        save('data_brt.mat', 'V_data_brt','-append');
    end
end