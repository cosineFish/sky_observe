    format_data = '';
    for i = 1:1:22%前6个是时间，后面16个是亮温
        format_data = strcat(format_data,'%f ');
    end
    [filename,filepath]=uigetfile('*.txt','打开文件');
    complete_file = strcat(filepath,filename);
    fidin = fopen(complete_file,'r+');
    sourceData = textscan(fidin,format_data,'CommentStyle','#');
    fclose(fidin);
    column_length = length(sourceData{1});
    time = datetime(sourceData{1},sourceData{2},sourceData{3},sourceData{4},sourceData{5},sourceData{6});
    K_Brt = zeros(column_length,8);V_Brt = zeros(column_length,8);
    for i = 1:8
        K_Brt(:,i) = sourceData{6+i};
        V_Brt(:,i) = sourceData{14+i};
    end
    format_onlyDate = 'yymmdd';
    startDate = datestr(time(1),format_onlyDate);startMonth = datestr(time(1),'yymm');
    %endDate = datestr(time(end),format_onlyDate);
    global dateStr;dateStr = startDate;
    global xlsFilePath;
    xlsFilePath = ['brt_data_',startMonth,'.xls'];
    %画亮温曲线
    global figure_num;figure_num = 0;
    plot_brt(time,K_Brt,'K');
    plot_brt(time,V_Brt,'V');
    %把表格保存到excel，注意excel文件太大（190KB左右）可能导致数据写不进去的情况
    global sheetNum;
    sheetNum = 1;
    global positionRowNum;
    positionRowNum = 0;
    saveTableData();
    system('taskkill /F /IM EXCEL.EXE');
    %清除产生的mat文件
    delete_mat();
    close all;%关闭所有图像窗口