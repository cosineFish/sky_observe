function plot_irt(irt)
    load checkdata_num.mat lineNum splitNum timeNum
    load checkdata_xtick.mat xticklabel
    global figure_num;
    figure_num = figure_num +1;    
    sz = get(0,'screensize');
    figure('name',num2str(figure_num),'outerposition',sz);
    min_value = min(irt);
    max_value = max(irt);
    mean_value = mean(irt);
    std_value = std(irt);
    pp_value = max_value - min_value;
    plot(1:1:lineNum ,irt);
    ylim([(min_value - 0.5) (max_value + 0.5)]);
    set(gca,'xtick',1:splitNum:timeNum*splitNum +1);
    set(gca,'xticklabel',xticklabel);
    set(gca,'FontSize',14);
    ylabel('红外温度/\circC');
    xlabel('测量时间（时:分）');
    global dateStr;
    title(['红外温度曲线（测量日期：',dateStr,'）'],'FontSize',14);
    hold on;
    Xlim = get(gca,'xlim');Ylim = get(gca,'ylim');N = (Ylim(2)-Ylim(1))/12;
    x_position = sum(Xlim) * 0.8;
    y_position = irt(x_position);
    if(y_position - N < Ylim(1) || y_position - 2 * N < Ylim(1) ||...
            y_position - 3 * N < Ylim(1) || y_position - 4 * N < Ylim(1))
        N = - N;
    end
    text(x_position ,y_position - N ,strcat('温度平均值：',num2str(mean_value),'\circC'),'horiz','center');
    text(x_position ,y_position - 2 * N,strcat('温度标准差：',num2str(std_value),'\circC'),'horiz','center');
    text(x_position ,y_position - 3 * N,strcat('最大最小差值：',num2str(pp_value),'\circC'),'horiz','center');
    grid on;
    hold off;
    save2word([dateStr,'report.doc'],['-f',num2str(figure_num)]);
end