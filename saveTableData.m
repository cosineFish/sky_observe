function saveTableData()
    global xlsFilePath;
    global dateStr;
    global sheetNum;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %�����������ݱ���
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    load('data_brt.mat', 'K_data_brt', 'V_data_brt');
    for i = 1:8
        cnames(i) = {['ͨ��',num2str(i)]};
    end
    global rnames;
    rnames = {'��ֵ/K','��׼��','���ֵ/K'};
    title = ['K��������(��������:',dateStr,')'];
    write2xls(xlsFilePath,title,cnames,K_data_brt,length(cnames));
    title = ['V��������(��������:',dateStr,')'];
    write2xls(xlsFilePath,title,cnames,V_data_brt,length(cnames));    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %��������ע�붨����������²�ֵ���ݱ���
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    load('data_delta_brt.mat', 'K_delta_brt', 'V_delta_brt');
    for i = 1:8
        cnames(i) = {['ͨ��',num2str(i)]};
    end
    title = ['K�������²�ֵ(��������:',dateStr,')'];
    write2xls(xlsFilePath,title,cnames,K_delta_brt,length(cnames));
    title = ['V�������²�ֵ(��������:',dateStr,')'];
    write2xls(xlsFilePath,title,cnames,V_delta_brt,length(cnames));  
    sheetNum = sheetNum + 1;
end