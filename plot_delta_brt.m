function plot_delta_brt(delta_brt,receiver_name)
    global dateStr;global figure_num;
    load checkdata_xtick.mat xlabel_noise_time
    for channel_num = 1:8
        average_value(channel_num) = mean(delta_brt(:,channel_num));
        std_value(channel_num) = std(delta_brt(:,channel_num));
        min_value(channel_num) = min(delta_brt(:,channel_num));
        max_value(channel_num) = max(delta_brt(:,channel_num));
        pp_value(channel_num) = max_value(channel_num) - min_value(channel_num);
    end
    if receiver_name == 'k' || receiver_name == 'K'
        temp = [pp_value(1:4) pp_value(6:8)];
        brt_delta = ceil(max(temp) * 100) / 100.0;
    else
        brt_delta = ceil(max(pp_value) * 100) / 100.0;
    end
    channel_num = 0;
    for num = 1:2
        figure('name',[num2str(num),receiver_name,'-亮温变化曲线']);
        for fig_num = 1 : 4
            channel_num = channel_num + 1;
            subplot(2,2,fig_num);
            plot(delta_brt(:,channel_num));
            v_gca(fig_num) = gca;
            minValue = floor(min_value(channel_num) * 100) / 100.0;
            maxValue = minValue + brt_delta;
            if minValue == maxValue
                brt_delta = 0.1;
            end
            ylnew = [minValue  maxValue];
            set(v_gca(fig_num), 'Ylim', ylnew);
            set(v_gca(fig_num),'ytick',minValue:(brt_delta/5):(minValue + brt_delta));
            if length(xlabel_noise_time) <= 6
                set(gca,'xtick',1:1:length(xlabel_noise_time));
                set(gca,'xticklabel',xlabel_noise_time);
            end
            xlabel('次序');
            ylabel('亮温差值/K');
            title(['通道',num2str(channel_num)]);
            set(gca,'FontSize',14);
            grid on;
            hold on;
        end
        suptitle([receiver_name,...
            '波段接收机由噪声注入定标导致的各通道亮温差值曲线（测量日期:',dateStr,'）']);
        set (gcf,'Position',[100,100,1000,800], 'color','w');
        hold off;
        figure_num = figure_num + 1;
        save2word([dateStr,'sigleBrt_report.doc'],['-f',num2str(figure_num)]);
    end
    if receiver_name == 'k' || receiver_name == 'K'
        K_delta_brt = [average_value;std_value;max_value];
        save('data_delta_brt.mat', 'K_delta_brt');
    else
        V_delta_brt = [average_value;std_value;max_value];
        save('data_delta_brt.mat', 'V_delta_brt','-append');
    end
end