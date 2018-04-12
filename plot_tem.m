function plot_tem(tem,rh)
    load checkdata_num.mat lineNum splitNum timeNum
    load checkdata_xtick.mat xticklabel
    global lengend_rect_inside;
    global figure_num;
    figure_num = figure_num +1;    
    sz = get(0,'screensize');
    figure('name',num2str(figure_num),'outerposition',sz);
    %环境湿度
    min_rh = floor(min(rh))-1;max_rh = ceil(max(rh))+1;
    delta_rh = floor((max_rh - min_rh)/8);    
    %温度
    min_value = min(tem);rh_min_value = min(rh);
    max_value = max(tem);rh_max_value = max(rh);
    mean_value = mean(tem);rh_mean_value = mean(rh);
    std_value = std(tem);rh_std_value = std(rh);
    pp_value = max_value - min_value;rh_pp_value = rh_max_value - rh_min_value;
    temp_value = [mean_value;std_value;pp_value];rh_value = [rh_mean_value;rh_std_value;rh_pp_value];
    save('checkdata_tem.mat', 'temp_value','rh_value');
    min_tem = floor(min_value);max_tem = ceil(max_value);
    delta_tem = floor((max_tem - min_tem)/8);  
    %画图
    yyaxis right
    plot(1:1:lineNum ,tem,'LineWidth',3);ylabel('环境温度/℃');    
    ylim([(min_value - 0.5) (max_value + 0.5)]);
    %set(gca,'ytick',min_tem:delta_tem:max_tem);
    yyaxis left
    plot(1:1:lineNum ,rh,'LineWidth',3);  ylabel('相对湿度/%');%,'Color',[0.4,0.4,0.4]
    ylim([min_rh,max_rh]);
    %set(gca,'ytick',min_rh:delta_rh:max_rh);      
    set(gca,'xtick',1:splitNum:timeNum*splitNum +1);
    set(gca,'xticklabel',xticklabel);
    set(gca,'FontSize',14);
    xlabel('测量时间（时:分）');
    lgd = legend('相对湿度','温度','Location',lengend_rect_inside);%
    lgd.FontSize = 15;
    global dateStr;
    title(['温湿度传感器测得的环境温湿度曲线（测量日期：',dateStr,'）'],'FontSize',14);
    grid on;
    hold off;
    save2word([dateStr,'report.doc'],['-f',num2str(figure_num)]);
end