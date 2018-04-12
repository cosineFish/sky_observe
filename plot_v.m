function plot_v(Vol,receiver_name)
    global figure_num;
    figure_num = figure_num +1;    
    sz = get(0,'screensize');
    figure('name',num2str(figure_num),'outerposition',sz);
    load checkdata_num.mat lineNum splitNum timeNum
    load checkdata_xtick.mat xticklabel
    for i = 1:8
        min_value(i) = min(Vol(:,i));
        max_value(i) = max(Vol(:,i));
        Vol_aver(i) = mean(Vol(:,i));
        Vol_std(i) = std(Vol(:,i));
        Vol_pp(i) = max_value(i) - min_value(i);
        subplot(4,2,i);%h(i) = subplot(4,2,i);
        plot(1:1:lineNum ,Vol(:,i));
        v_gca(i) = gca;
        set(gca,'xtick',1:splitNum:timeNum*splitNum +1);
        set(gca,'xticklabel',xticklabel);
        ylabel(['通道',num2str(i),'电压/V']);
        %set(gca,'FontSize',14);
        hold on;
    end
    Vol_delta = ceil(max(Vol_pp) * 100) / 100.0;
    for i = 1:8    
        minValue = floor(min_value(i) * 1000) / 1000.0;
        maxValue = minValue + Vol_delta;
        ylnew = [minValue  maxValue];
        set(v_gca(i), 'Ylim', ylnew);
        set(v_gca(i),'ytick',minValue:Vol_delta/5:maxValue);
    end        
    %linkaxes(h);
    global dateStr;
    suptitle([receiver_name,...
        '波段接收机各通道的电压曲线（测量日期：',dateStr,'）']);
    hold off;
    if receiver_name == 'K'
        Vol_dat_K = [Vol_aver;Vol_std;Vol_pp];
        save('checkdata_Vol.mat','Vol_dat_K');
    elseif receiver_name == 'V'
        Vol_dat_V = [Vol_aver;Vol_std;Vol_pp];
        save('checkdata_Vol.mat','Vol_dat_V','-append');
    end
    save2word([dateStr,'report.doc'],['-f',num2str(figure_num)]);
end