clear all;clc;
close all;%关闭所有figure窗口
[filename,filepath]=uigetfile('*.txt','打开文件');
complete_file = strcat(filepath,filename);
fidin = fopen(complete_file,'r+');
lineNum = 0;timeNum = 0;
fileStruct = dir(complete_file);
sizeofFile = fileStruct.bytes;
if sizeofFile > 1024 * 400
    splitNum = ceil(sizeofFile/768);
else
    splitNum = ceil(sizeofFile/1024);
end
format_data = '';
noiseInjectNum = 0;%gainInjectNum = 0;
for i = 1:1:22
    format_data = strcat(format_data,'%f');
end
while ~feof(fidin)         %判断是否为文件末尾
    tline = fgetl(fidin);         %从文件读行   
    tline = strtrim(tline);
    if isempty(tline)
        continue;
    end
    if ~contains(tline,'#')
        lineNum = lineNum + 1;
        sourceData = textscan(tline , format_data);
        if mod(lineNum,splitNum)==1
            timeNum = timeNum + 1;
            hour(timeNum) = sourceData{1,4};
            minute(timeNum) = sourceData{1,5}; 
            second(timeNum) = sourceData{1,6};
        end
        if lineNum == 1
            year = sourceData{1,1};
            month = sourceData{1,2};
            day = sourceData{1,3};
            last_sec_time = hour(1) * 3600 + minute(1) * 60 + second(1);
        end
        current_hour = sourceData{1,4};current_min = sourceData{1,5};
        current_sec = sourceData{1,6};
        current_sec_time = current_hour * 3600 + current_min * 60 + current_sec;
        for i = 1:8
            K_Brt(lineNum,i) = sourceData{1,6+i};%亮温
            V_Brt(lineNum,i) = sourceData{1,14+i};%亮温
        end
        if current_sec_time-last_sec_time > 70
            noiseInjectNum = noiseInjectNum + 1;
            xlabel_noise_time{noiseInjectNum} = [num2str(current_hour,'%02d'),':',num2str(current_min,'%02d'),...
                ':',num2str(current_sec,'%02d')];
            for i = 1:8
                delta_K_Brt(noiseInjectNum,i) = K_Brt(lineNum,i) - K_Brt(lineNum-1,i);
                delta_V_Brt(noiseInjectNum,i) = V_Brt(lineNum,i) - V_Brt(lineNum-1,i);
            end
%         elseif current_sec_time-last_sec_time > 50
%             gainInjectNum = gainInjectNum + 1;
%             for i = 1:8
%                 gain_delta_K_Brt(gainInjectNum,i) = K_Brt(lineNum,i) - K_Brt(lineNum-1,i);
%                 gain_delta_V_Brt(gainInjectNum,i) = V_Brt(lineNum,i) - V_Brt(lineNum-1,i);
%             end
        end
        last_sec_time = current_sec_time;
    else
            continue;
    end%对应外圈的if
end%对应while循环
fclose(fidin);
save('checkdata_num.mat','lineNum', 'splitNum', 'timeNum');
global dateStr;
dateStr = [num2str(year,'%02d'),num2str(month,'%02d'),num2str(day,'%02d')];
global xlsFilePath;
xlsFilePath = ['brt_data_',num2str(year,'%02d'),num2str(month,'%02d'),'.xls'];
for i = 1:timeNum
    xlabel_vol_str = [num2str(hour(i),'%02d'),':',num2str(minute(i),'%02d')];
    xticklabel{i} = xlabel_vol_str;
end
save checkdata_xtick.mat xticklabel xlabel_noise_time
global figure_num;figure_num = 0;
%画亮温曲线
plot_brt(K_Brt,'K');
plot_brt(V_Brt,'V');
%画噪声注入定标导致的亮温变化曲线
plot_delta_brt(delta_K_Brt,'K');
plot_delta_brt(delta_V_Brt,'V');
%把表格保存到excel，注意excel文件太大（190KB左右）可能导致数据写不进去的情况
global sheetNum;
sheetNum = 2;
global positionRowNum;
positionRowNum = 0;
saveTableData();
system('taskkill /F /IM EXCEL.EXE');
%清除产生的mat文件
delete_mat();
close all;%关闭所有图像窗口