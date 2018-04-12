function [status , msginfo] = ...
    vol_average_write2xls(filePath , title , cnames , values , length , row_num)
%write2xls(filePath , title , cnames , values , sheetName , length)
    global dateStr;
    global sheetNum;
    sheetName = [dateStr,'_',num2str(sheetNum)];
    global positionRowNum;
    positionRowNum =  1 + positionRowNum;
    xlswrite(filePath,cellstr(title),sheetName,['A',num2str(positionRowNum)]);%写标题信息
    posotionColChar = char(length + 65);
    positionRowNum =  1 + positionRowNum;
    xlswrite(filePath,cellstr(cnames),sheetName,...
        ['B',num2str(positionRowNum),':',...
        posotionColChar,num2str(positionRowNum)]);%写列名称
    %写行名称
    global rnames;
    xlswrite(filePath,cellstr(transpose(rnames)),sheetName,['A',num2str(positionRowNum + 1),':',...
        'A',num2str(positionRowNum + 3)]);
    positonStr = ['B',num2str(positionRowNum + 1),':',...
        posotionColChar,num2str(positionRowNum + row_num)];
    [status , msginfo] = xlswrite(filePath,values,sheetName,positonStr);
    positionRowNum = positionRowNum + row_num + 1;
end