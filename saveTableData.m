function saveTableData()
    global xlsFilePath;
    global dateStr;
    global sheetNum;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %�����������ݱ��
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    load('data_brt.mat', 'K_data_brt', 'V_data_brt');
    for i = 1:8
        cnames(i) = {['ͨ��',num2str(i)]};
    end
    global rnames;
    rnames = {'��ֵ/K','��׼��/K','���ֵ/K'};
    title = ['K��������(��������:',dateStr,')'];
    write2xls(xlsFilePath,title,cnames,K_data_brt,length(cnames));
    title = ['V��������(��������:',dateStr,')'];
    write2xls(xlsFilePath,title,cnames,V_data_brt,length(cnames));    
    sheetNum = sheetNum + 1;
end