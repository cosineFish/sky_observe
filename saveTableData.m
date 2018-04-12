function saveTableData()
    global xlsFilePath;
    global dateStr;
    global sheetNum;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %保存亮温数据表格
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    load('data_brt.mat', 'K_data_brt', 'V_data_brt');
    for i = 1:8
        cnames(i) = {['通道',num2str(i)]};
    end
    global rnames;
    rnames = {'均值/K','标准差','峰峰值/K'};
    title = ['K波段亮温(测量日期:',dateStr,')'];
    write2xls(xlsFilePath,title,cnames,K_data_brt,length(cnames));
    title = ['V波段亮温(测量日期:',dateStr,')'];
    write2xls(xlsFilePath,title,cnames,V_data_brt,length(cnames));    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %保存噪声注入定标带来的亮温差值数据表格
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    load('noise_delta_brt.mat', 'K_delta_brt', 'V_delta_brt');
    rnames = {'均值/K','标准差','最大值/K'};
    title = ['K波段 噪声注入定标带来的亮温差值(测量日期:',dateStr,')'];
    write2xls(xlsFilePath,title,cnames,K_delta_brt,length(cnames));
    title = ['V波段 噪声注入定标带来的亮温差值(测量日期:',dateStr,')'];
    write2xls(xlsFilePath,title,cnames,V_delta_brt,length(cnames));  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %保存增益定标带来的亮温差值数据表格
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    load('gain_delta_brt.mat', 'K_delta_brt', 'V_delta_brt');
    title = ['K波段 增益定标定标带来的亮温差值(测量日期:',dateStr,')'];
    write2xls(xlsFilePath,title,cnames,K_delta_brt,length(cnames));
    title = ['V波段 增益定标定标带来的亮温差值(测量日期:',dateStr,')'];
    write2xls(xlsFilePath,title,cnames,V_delta_brt,length(cnames));  
    sheetNum = sheetNum + 1;
end