clear all;clc;
close all;%�ر�����figure����
[filename,filepath]=uigetfile('*.txt','���ļ�');
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
while ~feof(fidin)         %�ж��Ƿ�Ϊ�ļ�ĩβ
    tline = fgetl(fidin);         %���ļ�����   
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
            K_Brt(lineNum,i) = sourceData{1,6+i};%����
            V_Brt(lineNum,i) = sourceData{1,14+i};%����
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
    end%��Ӧ��Ȧ��if
end%��Ӧwhileѭ��
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
%����������
plot_brt(K_Brt,'K');
plot_brt(V_Brt,'V');
%������ע�붨�굼�µ����±仯����
plot_delta_brt(delta_K_Brt,'K');
plot_delta_brt(delta_V_Brt,'V');
%�ѱ�񱣴浽excel��ע��excel�ļ�̫��190KB���ң����ܵ�������д����ȥ�����
global sheetNum;
sheetNum = 2;
global positionRowNum;
positionRowNum = 0;
saveTableData();
system('taskkill /F /IM EXCEL.EXE');
%���������mat�ļ�
delete_mat();
close all;%�ر�����ͼ�񴰿�