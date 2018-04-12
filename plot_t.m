function plot_t(NTC,receiver)
%画图
global figure_num;
global legend_rect_outside;
global lengend_rect_inside;
figure_num = figure_num + 1;
sz = get(0,'screensize');
figure('name',num2str(figure_num),'outerposition',sz);
%figure('name',num2str(figure_num));
load checkdata_num.mat lineNum splitNum timeNum
color = {'-r','-g','-b','-c','-m','-y','-k','--r','--k'};
if receiver == 'K'
    for i = 1 : 9
        K_NTC_aver(i) = mean(NTC(:,i));
        K_NTC_std(i) = std(NTC(:,i));
        K_min(i) = min(NTC(:,i));
        K_max(i) = max(NTC(:,i));
        K_NTC_pp(i) = K_max(i) - K_min(i);
    end
    dat_K = [K_NTC_aver;K_NTC_std;K_NTC_pp];
    save('checkdata_ntc.mat', 'dat_K');
    min_value = min(K_min(:));
    max_value = max(K_max(:));
elseif receiver == 'V'
    for i = 1 : 9
        V_NTC_aver(i) = mean(NTC(:,i));
        V_NTC_std(i) = std(NTC(:,i));
        V_min(i) = min(NTC(:,i));
        V_max(i) = max(NTC(:,i));
        V_NTC_pp(i) = V_max(i) - V_min(i);
    end
    dat_V = [V_NTC_aver;V_NTC_std;V_NTC_pp];
    save('checkdata_ntc.mat', 'dat_V','-append');
    min_value = min(V_min(:));
    max_value = max(V_max(:));    
end
yyaxis left
for i = 1:9
    h = plot(1:1:lineNum , NTC(:,i) ,color{i},'LineWidth',3);
    hold on;
    uistack(h,'top');
end
global dateStr;
load checkdata_xtick.mat xticklabel
set(gca,'xtick',1:splitNum:timeNum*splitNum +1);
set(gca,'xticklabel',xticklabel);
global ylim_min;
ylim([ylim_min,ylim_min + 7]);
set(gca,'ytick',ylim_min:0.5:(ylim_min+7));
% ylim([60,67]);
% set(gca,'ytick',60:0.5:67);
% ylim([56,63]);
% set(gca,'ytick',56:0.5:63);
set(gca,'FontSize',14);
%xlabel();
hold on;
xlabel('测量时间（时:分:秒）');
ylabel('温度/\circC');
title([receiver,'波段接收机测温点温度（测量日期：',dateStr,'）'],'FontSize',14);
set(gca,'layer','top');
%画环境温度曲线
hold on;
load('envir_temp.mat','Tem','max_temp','min_temp','delta_temp_tick');
% if delta_temp_tick < 5
%     min_temp = min_temp - 7/2;max_temp = min_temp + 7;
% elseif delta_temp_tick < 7
%     min_temp = min_temp - 1;max_temp = min_temp + 7;
% end    
if delta_temp_tick < 3
    min_temp = min_temp - 4/2;max_temp = min_temp + 4;
elseif delta_temp_tick < 4
    min_temp = min_temp - 1;max_temp = min_temp + 4;
end      
yyaxis right
plot(1:1:lineNum ,Tem,'LineWidth',2,'Color',[0.4,0.4,0.4]);ylabel('环境温度/℃','Color',[0.4,0.4,0.4]);    
ylim([min_temp,max_temp]);
if receiver == 'V'
    legend('天线口测温点','噪声源测温点','中放测温点','混频器测温点',...
    '左上角底板测温点','倍频器测温点','右下角底板测温点','中间底板测温点',...
    '右上角底板测温点','环境温度','Location',legend_rect_outside);
elseif receiver == 'K'
    legend('左上角底板测温点','天线口测温点','左下角底板测温点',...
    '中放面板测温点','混频器测温点','噪声源测温点',...
    '右下角底板测温点','右上角底板测温点','中频输出测温点',...
    '环境温度','Location',legend_rect_outside);%'NorthEast'
end
grid on;
hold off;
save2word([dateStr,'report.doc'],['-f',num2str(figure_num)]);
end