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
    rnames = {'均值/K','标准差/K','峰峰值/K'};
    title = ['K波段亮温(测量日期:',dateStr,')'];
    write2xls(xlsFilePath,title,cnames,K_data_brt,length(cnames));
    title = ['V波段亮温(测量日期:',dateStr,')'];
    write2xls(xlsFilePath,title,cnames,V_data_brt,length(cnames));    
    sheetNum = sheetNum + 1;
end