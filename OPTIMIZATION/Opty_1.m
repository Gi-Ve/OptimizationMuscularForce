clear all
close all

x = inputdlg({'Enter Subject: '});
x=x{1};

matname = ['All_Subjects/Subject',x,'.mat'];

if exist(matname,'file') ~= 2
    disp(['File ' matname ' not found.']);
   return;
end



load(matname);



name = s.name;
age  = s.Age;
sex  = deblank(s.Gender);
height = s.BH;
weight = s.BM;
side = 'Right';
EMGFreq =s.EMGFreq;

data   = s.Data;
ntrial = length(s.Data);

%===== SPEED TRESHOLD
tresholdLow=1.2;
tresholdHigh=1.45;
%======================================

sol=[];

walk_indexes = [];
for i = 1:ntrial
    if strcmpi(deblank(s.Data(i).Task),'Walking') && strcmpi(deblank(s.Data(i).Foot),'RX')
        walk_indexes = [walk_indexes i];
    end
end



indexSlow = [];
indexMedium = [];
indexFast = [];
for k = 1:length(walk_indexes)
    i=walk_indexes(k);
    
    if s.Data(i).speed < tresholdLow
        indexSlow= [indexSlow i];
    elseif s.Data(i).speed > tresholdLow && s.Data(i).speed < tresholdHigh
        indexMedium= [indexMedium i];
    else
        indexFast= [indexFast i];
    end
    
end


indexSpeed= [];
indexSpeed(1)=indexSlow(1);
indexSpeed(2)=indexMedium(1);
indexSpeed(3)=indexFast(1);



 
%===== GET MOMENTS INDEX
imomH = strmatch('HipFlxMom',(s.MomVarName));
imomHAbb = strmatch('HipAddMom',(s.MomVarName));
imomK = strmatch('KneeFlxMom',(s.MomVarName));
imomA = strmatch('AnkleFlxMom',(s.MomVarName));
%======================================






%===== GET OPTIMIZATION SOLUTION =============================
cd 'DATA'

answer = questdlg('Choose Optimization method', ...
	'OPTIMIZATION METHOD', ...
	'MIN/MAX','POLYNOMIAL','SOFT-SATURATION','MIN/MAX');
% Handle response
switch answer
    case 'MIN/MAX'
        
        for k = 1:length(indexSpeed)
            
            i=indexSpeed(k);
            
            %===== GET MOMENTS
            momH=s.Data(i).Mom(imomH,:);
            momHAbb=s.Data(i).Mom(imomHAbb,:);
            momK=s.Data(i).Mom(imomK,:);
            momA=s.Data(i).Mom(imomA,:);
            %======================================
            if k==1
                solSlow=Optimization(momH,momHAbb,momK,momA,weight,height);
            elseif k==2
                solMedium=Optimization(momH,momHAbb,momK,momA,weight,height);
            else
                solFast=Optimization(momH,momHAbb,momK,momA,weight,height);
            end
        end
    case 'POLYNOMIAL'
        
        for k = 1:length(indexSpeed)
            
            i=indexSpeed(k);
            
            %===== GET MOMENTS
            momH=s.Data(i).Mom(imomH,:);
            momHAbb=s.Data(i).Mom(imomHAbb,:);
            momK=s.Data(i).Mom(imomK,:);
            momA=s.Data(i).Mom(imomA,:);
            %======================================
            if k==1
                solSlow=OptimizationPoly(momH,momHAbb,momK,momA);
            elseif k==2
                solMedium=OptimizationPoly(momH,momHAbb,momK,momA);
            else
                solFast=OptimizationPoly(momH,momHAbb,momK,momA);
            end
        end
        
    case 'SOFT-SATURATION'
        
        for k = 1:length(indexSpeed)
            
            i=indexSpeed(k);
            
            %===== GET MOMENTS
            momH=s.Data(i).Mom(imomH,:);
            momHAbb=s.Data(i).Mom(imomHAbb,:);
            momK=s.Data(i).Mom(imomK,:);
            momA=s.Data(i).Mom(imomA,:);
            %======================================
            if k==1
                solSlow=OptimizationSoftSaturation(momH,momHAbb,momK,momA);
            elseif k==2
                solMedium=OptimizationSoftSaturation(momH,momHAbb,momK,momA);
            else
                solFast=OptimizationSoftSaturation(momH,momHAbb,momK,momA);
            end
        end
        
   %{
        case 'EXIT'
        disp('SEE YOU')
        quit();
        %}
end
cd '../'


solSlow=solSlow.*weight;
solMedium=solMedium.*weight;
solFast=solFast.*weight;

 l=length(sol);
 
 x=(1:3:87);
 y=(2:3:87);
 z=(3:3:87);
 x1=(0:2:100);


 
 
%====================== PLOT SLOW ===================
f1=figure( 'Visible','on');
f1.WindowState = 'maximized';


    subplot(4,3,1)
    plot(x1,solSlow(:,[1,2,3,4,5,9]),'LineWidth',1);
    hold on
    
    lgd=legend('RF','IL','GMAX','PS','SM','BFCL');
    title(["SLOW","HIP FLEX/EX"]) 
    %title('HIP FLEX/EX')
    xlabel('GAIT CYCLE %') 
    ylabel('Force [N]') 
    lgd.FontSize = 10;
    s=gca;
    set(s,'fontsize',10)
    hold off
    grid;

    subplot(4,3,4)
    plot(x1,solSlow(:,[6,7,8,10,11,12]),'LineWidth',1);
    hold on
  
    lgd=legend('ADDB','ADDG','ADDL','GMEDa','GMEDp','GMIN');
    title('HIP ADD/ABD')
    xlabel('GAIT CYCLE %') 
    ylabel('Force [N]') 
    lgd.FontSize = 10;
    s=gca;
    set(s,'fontsize',10)
    hold off
    grid;
 
    subplot(4,3,7)
    plot(x1,solSlow(:,[1,14,15,16,17]),'LineWidth',1);
    hold on

    lgd=legend('RF','VM','VI','VL','BFCB');
    title('KNEE FLEX/EX')
    xlabel('GAIT CYCLE %') 
    ylabel('Force [N]') 
    lgd.FontSize = 10;
    s=gca;
    set(s,'fontsize',10)
    hold off
    grid;
 
    subplot(4,3,10)
    plot(x1,solSlow(:,[13,18,19,20]),'LineWidth',1);
    hold on
   
    lgd=legend('GAS','SO','TA','PE');
    title('ANKLE FLEX/EX')
    xlabel('GAIT CYCLE %') 
    ylabel('Force [N]') 
    lgd.FontSize = 10;
    s=gca;
    set(s,'fontsize',10)
    hold off
    grid;
    
%====================== PLOT MEDIUM ===================



    subplot(4,3,2)
    plot(x1,solMedium(:,[1,2,3,4,5,9]),'LineWidth',1);
    hold on
    
    lgd=legend('RF','IL','GMAX','PS','SM','BFCL');
    title(["MEDIUM","HIP FLEX/EX"])
    xlabel('GAIT CYCLE %') 
    ylabel('Force [N]') 
    lgd.FontSize = 10;
    s=gca;
    set(s,'fontsize',10)
    hold off
    grid;

    subplot(4,3,5)
    plot(x1,solMedium(:,[6,7,8,10,11,12]),'LineWidth',1);
    hold on
  
    lgd=legend('ADDB','ADDG','ADDL','GMEDa','GMEDp','GMIN');
    title('HIP ADD/ABD')
    xlabel('GAIT CYCLE %') 
    ylabel('Force [N]') 
    lgd.FontSize = 10;
    s=gca;
    set(s,'fontsize',10)
    hold off
    grid;
 
    subplot(4,3,8)
    plot(x1,solMedium(:,[1,14,15,16,17]),'LineWidth',1);
    hold on

    lgd=legend('RF','VM','VI','VL','BFCB');
    title('KNEE FLEX/EX')
    xlabel('GAIT CYCLE %') 
    ylabel('Force [N]') 
    lgd.FontSize = 10;
    s=gca;
    set(s,'fontsize',10)
    hold off
    grid;
 
    subplot(4,3,11)
    plot(x1,solMedium(:,[13,18,19,20]),'LineWidth',1);
    hold on
   
    lgd=legend('GAS','SO','TA','PE');
    title('ANKLE FLEX/EX')
    xlabel('GAIT CYCLE %') 
    ylabel('Force [N]') 
    lgd.FontSize = 10;
    s=gca;
    set(s,'fontsize',10)
    hold off
    grid;    
    
 
   
%====================== PLOT FAST ===================



    subplot(4,3,3)
    plot(x1,solFast(:,[1,2,3,4,5,9]),'LineWidth',1);
    hold on
    
    lgd=legend('RF','IL','GMAX','PS','SM','BFCL');
    title(["FAST","HIP FLEX/EX"])
    xlabel('GAIT CYCLE %') 
    ylabel('Force [N]') 
    lgd.FontSize = 10;
    s=gca;
    set(s,'fontsize',10)
    hold off
    grid;

    subplot(4,3,6)
    plot(x1,solFast(:,[6,7,8,10,11,12]),'LineWidth',1);
    hold on
  
    lgd=legend('ADDB','ADDG','ADDL','GMEDa','GMEDp','GMIN');
    title('HIP ADD/ABD')
    xlabel('GAIT CYCLE %') 
    ylabel('Force [N]') 
    lgd.FontSize = 10;
    s=gca;
    set(s,'fontsize',10)
    hold off
    grid;
 
    subplot(4,3,9)
    plot(x1,solFast(:,[1,14,15,16,17]),'LineWidth',1);
    hold on

    lgd=legend('RF','VM','VI','VL','BFCB');
    title('KNEE FLEX/EX')
    xlabel('GAIT CYCLE %') 
    ylabel('Force [N]') 
    lgd.FontSize = 10;
    s=gca;
    set(s,'fontsize',10)
    hold off
    grid;
 
    subplot(4,3,12)
    plot(x1,solFast(:,[13,18,19,20]),'LineWidth',1);
    hold on
   
    lgd=legend('GAS','SO','TA','PE');
    title('ANKLE FLEX/EX')
    xlabel('GAIT CYCLE %') 
    ylabel('Force [N]') 
    lgd.FontSize = 10;
    s=gca;
    set(s,'fontsize',10)
    hold off
    grid;