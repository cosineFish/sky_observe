function plot_t_tec(TEC,receiver)
%画控温点温度图
global figure_num;
global legend_rect_outside;
global lengend_rect_inside;
figure_num = figure_num +1;
sz = get(0,'screensize');
figure('name',num2str(figure_num),'outerposition',sz);
% figure('name',num2str(figure_num));
load checkdata_num.mat lineNum splitNum timeNum
color = {'-r','-m','--y','-c',':r','-k',':c','-g','-b'};%d表示用菱形绘制数据点
if strcmp(receiver, 'K')
    length = 6;
    for i = 1 : length
        K_TEC_aver(i) = mean(TEC(:,i));
        K_TEC_std(i) = std(TEC(:,i));
        K_min(i) = min(TEC(:,i));
        K_max(i) = max(TEC(:,i));        
        K_TEC_pp(i) = K_max(i) - K_min(i);
    end
    dat_K_TEC = [K_TEC_aver;K_TEC_std;K_TEC_pp];
    save('checkdata_tec.mat', 'dat_K_TEC');
    min_value = min(K_max(:));
    max_value = max(K_min(:));    
elseif strcmp(receiver, 'V1') || strcmp(receiver, 'V2')
    if strcmp(receiver, 'V1')
        length = 8;
    else
        length = 9;
        color{5} = '-w';%
    end
    for i = 1 : length
        V_TEC_aver(i) = mean(TEC(:,i));
        V_TEC_std(i) = std(TEC(:,i));
        V_min(i) = min(TEC(:,i));
        V_max(i) = max(TEC(:,i));        
        V_TEC_pp(i) = V_max(i) - V_min(i);
    end
    if strcmp(receiver, 'V1')
        dat_V1_TEC = [V_TEC_aver;V_TEC_std;V_TEC_pp];
        save('checkdata_tec.mat', 'dat_V1_TEC','-append');
        min_value = min(V_min(:));
        max_value = max(V_max(:));
    else
        dat_V2_TEC = [V_TEC_aver;V_TEC_std;V_TEC_pp];
        aver_grp = [V_TEC_aver(1:4) V_TEC_aver(6:9)];
        TEC(:,5) = max(aver_grp);
        save('checkdata_tec.mat', 'dat_V2_TEC','-append');
        min_value = min([min(V_min(1:4)) V_min(6:length)]);
        max_value = max([max(V_max(1:4)) V_max(6:length)]);    
    end
end
for i = 1:length
    plot(1:1:lineNum , TEC(:,i) ,color{i},'LineWidth',3);
    hold on;
end
global dateStr;
load checkdata_xtick.mat xticklabel
set(gca,'xtick',1:splitNum:timeNum*splitNum +1);
set(gca,'xticklabel',xticklabel);
%set(gca,'ytick',floor(min_value):0.5:ceil(max_value));
ylim([60,67]);
set(gca,'ytick',60:0.5:67);
% ylim([61,68]);
% set(gca,'ytick',61:0.5:68);
set(gca,'FontSize',14);
hold on;
xlabel('测量时间（时:分:秒）');
ylabel('温度/\circC');
%画环境温度曲线
hold on;
load('envir_temp.mat','Tem','max_temp','min_temp','delta_temp_tick');
if delta_temp_tick < 3
    min_temp = min_temp - 4/2;max_temp = min_temp + 4;
elseif delta_temp_tick < 4
    min_temp = min_temp - 1;max_temp = min_temp + 4;
end    
yyaxis right
plot(1:1:lineNum ,Tem,'LineWidth',2,'Color',[0.4,0.4,0.4]);ylabel('环境温度/℃','color',[0.4,0.4,0.4]);    
ylim([min_temp,max_temp]);
if strcmp(receiver, 'V1')
    legend('控温点1','控温点2','控温点3','控温点4',...
    '控温点5','控温点6','控温点7','控温点8','环境温度','Location',legend_rect_outside);
    title_string = 'V';
elseif strcmp(receiver, 'V2')
    legend('控温点9','控温点10','控温点11','控温点12','控温点13','控温点14',...
    '控温点15','控温点16','控温点17','环境温度','Location',legend_rect_outside);
    title_string = 'V';
elseif strcmp(receiver, 'K')
    legend('上面板中心控温点','左面板中心控温点','前面板中心控温点',...
    '右面板中心控温点','后面板中心控温点','下面板中心控温点','环境温度',...
    'Location',legend_rect_outside);
    title_string = 'K';
end
title([title_string,'波段接收机控温点温度（测量日期：',dateStr,'）'],'FontSize',14);
grid on;
hold off;
save2word([dateStr,'report.doc'],['-f',num2str(figure_num)]);
end