clear all1
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

solSlow=[];
solMedium=[];
solFast=[];

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
        
        for k = 1:length(indexSlow)
            
            i=indexSlow(k);
            
            %===== GET MOMENTS
            momH=s.Data(i).Mom(imomH,:);
            momHAbb=s.Data(i).Mom(imomHAbb,:);
            momK=s.Data(i).Mom(imomK,:);
            momA=s.Data(i).Mom(imomA,:);
            %======================================
            
            solSlow(:,:,k)=Optimization(momH,momHAbb,momK,momA,weight,height);
            
        end
        
        for k = 1:length(indexMedium)
            
            i=indexMedium(k);
            
            %===== GET MOMENTS
            momH=s.Data(i).Mom(imomH,:);
            momHAbb=s.Data(i).Mom(imomHAbb,:);
            momK=s.Data(i).Mom(imomK,:);
            momA=s.Data(i).Mom(imomA,:);
            %======================================
            
            solMedium(:,:,k)=Optimization(momH,momHAbb,momK,momA,weight,height);
            
        end
            
        
        for k = 1:length(indexFast)
            
            i=indexFast(k);
            
            %===== GET MOMENTS
            momH=s.Data(i).Mom(imomH,:);
            momHAbb=s.Data(i).Mom(imomHAbb,:);
            momK=s.Data(i).Mom(imomK,:);
            momA=s.Data(i).Mom(imomA,:);
            %======================================
            
            solFast(:,:,k)=Optimization(momH,momHAbb,momK,momA,weight,height);
            
        end
           

    case 'POLYNOMIAL'
        
        for k = 1:length(indexSlow)
            
            i=indexSlow(k);
            
            %===== GET MOMENTS
            momH=s.Data(i).Mom(imomH,:);
            momHAbb=s.Data(i).Mom(imomHAbb,:);
            momK=s.Data(i).Mom(imomK,:);
            momA=s.Data(i).Mom(imomA,:);
            %======================================
            
            solSlow(:,:,k)=OptimizationPoly(momH,momHAbb,momK,momA);
            
        end
        
        for k = 1:length(indexMedium)
            
            i=indexMedium(k);
            
            %===== GET MOMENTS
            momH=s.Data(i).Mom(imomH,:);
            momHAbb=s.Data(i).Mom(imomHAbb,:);
            momK=s.Data(i).Mom(imomK,:);
            momA=s.Data(i).Mom(imomA,:);
            %======================================
            
            solMedium(:,:,k)=OptimizationPoly(momH,momHAbb,momK,momA);
            
        end
            
        
        for k = 1:length(indexFast)
            
            i=indexFast(k);
            
            %===== GET MOMENTS
            momH=s.Data(i).Mom(imomH,:);
            momHAbb=s.Data(i).Mom(imomHAbb,:);
            momK=s.Data(i).Mom(imomK,:);
            momA=s.Data(i).Mom(imomA,:);
            %======================================
            
            solFast(:,:,k)=OptimizationPoly(momH,momHAbb,momK,momA);
            
        end
        
       
           
            
        
    case 'SOFT-SATURATION'
        
        for k = 1:length(indexSlow)
            
            i=indexSlow(k);
            
            %===== GET MOMENTS
            momH=s.Data(i).Mom(imomH,:);
            momHAbb=s.Data(i).Mom(imomHAbb,:);
            momK=s.Data(i).Mom(imomK,:);
            momA=s.Data(i).Mom(imomA,:);
            %======================================
            
            solSlow(:,:,k)=OptimizationSoftSaturation(momH,momHAbb,momK,momA);
            
        end
        
        for k = 1:length(indexMedium)
            
            i=indexMedium(k);
            
            %===== GET MOMENTS
            momH=s.Data(i).Mom(imomH,:);
            momHAbb=s.Data(i).Mom(imomHAbb,:);
            momK=s.Data(i).Mom(imomK,:);
            momA=s.Data(i).Mom(imomA,:);
            %======================================
            
            solMedium(:,:,k)=OptimizationSoftSaturation(momH,momHAbb,momK,momA);
            
        end
            
        
        for k = 1:length(indexFast)
            
            i=indexFast(k);
            
            %===== GET MOMENTS
            momH=s.Data(i).Mom(imomH,:);
            momHAbb=s.Data(i).Mom(imomHAbb,:);
            momK=s.Data(i).Mom(imomK,:);
            momA=s.Data(i).Mom(imomA,:);
            %======================================
            
            solFast(:,:,k)=OptimizationSoftSaturation(momH,momHAbb,momK,momA);
            
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


 
 x=(1:3:87);
 y=(2:3:87);
 z=(3:3:87);
 x1=(0:2:100);

solName=["RF" "IL" "GMAX" "PS" "SM" ...
         "ADDB" "ADDG" "ADDL" "BFCL" "GMEDa" ...
         "GMEDp" "GMIN" "GAS" "VM" "VI" ...
         "VL" "BFCB" "SO" "TA" "PE"];
 
 
 
%====================== PLOT SLOW ===================
f1=figure( 'Visible','on');
f1.WindowState = 'maximized';

[a1,b1,c1] = size(solSlow);
[a2,b2,c2] = size(solMedium);
[a3,b3,c3] = size(solFast);


for k=1:20
    
    subplot(4,5,k)
    for i=1:c1
    plot(x1,solSlow(:,k,i),'DisplayName','Slow','LineWidth',1,'Color','b');
    hold on
    end
    for i=1:c2
    plot(x1,solMedium(:,k,i),'LineWidth',1,'Color','g');
    hold on
    end
    for i=1:c3
    plot(x1,solFast(:,k,i),'LineWidth',1,'Color','r');
    hold on
    end
    
    %lgd=legend("Slow","Medium","Fast");
    title(solName(k)) 
    xlabel('GAIT CYCLE %') 
    ylabel('Force [N]') 
    %lgd.FontSize = 10;
    s=gca;
    set(s,'fontsize',10)
    hold off
    grid;

end




