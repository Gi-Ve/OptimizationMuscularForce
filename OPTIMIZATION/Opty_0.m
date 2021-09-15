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


 

walk_indexes = [];
for i = 1:ntrial
    if strcmpi(deblank(s.Data(i).Task),'Walking') && strcmpi(deblank(s.Data(i).Foot),'RX')
        walk_indexes = [walk_indexes i];
    end
end


str=sprintf('Number of trial %d. Wich trial do you want to evaluate?',length(walk_indexes));
i = inputdlg(str);
i=str2num(i{1});

M=s.Data(i).Marker;
[a,b]=size(M);
 a=a/3;
 
%===== GET MOMENTS INDEX
imomH = strmatch('HipFlxMom',(s.MomVarName));
imomHAbb = strmatch('HipAddMom',(s.MomVarName));
imomK = strmatch('KneeFlxMom',(s.MomVarName));
imomA = strmatch('AnkleFlxMom',(s.MomVarName));
%======================================

%===== GET MOMENTS
momH=s.Data(walk_indexes(i)).Mom(imomH,:);
momHAbb=s.Data(walk_indexes(i)).Mom(imomHAbb,:);
momK=s.Data(walk_indexes(i)).Mom(imomK,:);
momA=s.Data(walk_indexes(i)).Mom(imomA,:);
%======================================




%===== GET OPTIMIZATION SOLUTION =============================
cd 'DATA'

answer = questdlg('Choose Optimization method', ...
	'OPTIMIZATION METHOD', ...
	'MIN/MAX','POLYNOMIAL','SOFT-SATURATION','MIN/MAX');
% Handle response
switch answer
    case 'MIN/MAX'
        sol=Optimization(momH,momHAbb,momK,momA,weight,height);
    case 'POLYNOMIAL'
        sol=OptimizationPoly(momH,momHAbb,momK,momA);
    case 'SOFT-SATURATION'
        sol=OptimizationSoftSaturation(momH,momHAbb,momK,momA);
   %{
        case 'EXIT'
        disp('SEE YOU')
        quit();
        %}
end
cd '../'


sol=sol.*weight;
 l=length(sol);
 
 x=(1:3:87);
 y=(2:3:87);
 z=(3:3:87);
 x1=(0:2:100);


 
%====================== PLOT ===================
f1=figure( 'Visible','on');
f1.WindowState = 'maximized';

fin=b/5

  for i=1:fin 
    
    subplot(3,2,1)
    plot(M(z,i*5),M(y,i*5),'o','Color','b','MarkerFaceColor','r');hold on 
    title('FRONTAL PLANE')
    axis equal;
    axis off 
    hold off
    
    subplot(3,2,2)
    plot(M(x,i*5),M(y,i*5),'o','Color','r','MarkerFaceColor','b'); hold on
    axis equal;
    axis([-inf inf -inf inf])
    axis off
    title('SAGITTAL PLANE')
    hold off
   
    
    Perc=(i*100)/fin;
    disp(Perc);
    StrPerc=num2str(uint8(Perc));
    k = 2*round((Perc/100)*l);
    disp(k);
 
    subplot(3,2,3)
    plot(x1,sol(:,[1,2,3,4,5,9]),'LineWidth',1);
%    plot(x1,sol(:,1),x1,sol(:,2),x1,sol(:,3),...
%        x1,sol(:,4),x1,sol(:,5),x1,sol(:,9),'LineWidth',1); 
    hold on
    xline(k,'-',{'% GAIT CYCLE:',StrPerc},'Color','r','LineWidth',2);
    lgd=legend('RF','IL','GMAX','PS','SM','BFCL');
    title('HIP FLEX/EX')
    xlabel('GAIT CYCLE %') 
    ylabel('Force [N]') 
    lgd.FontSize = 15;
    s=gca;
    set(s,'fontsize',15)
    hold off
    grid;

    subplot(3,2,4)
    plot(x1,sol(:,[6,7,8,10,11,12]),'LineWidth',1);
%    plot(x1,sol(:,6),x1,sol(:,7),x1,sol(:,8),...
%        x1,sol(:,10),x1,sol(:,11),x1,sol(:,12),'LineWidth',1);
    hold on
    xline(k,'-','Color','r','LineWidth',2);
    lgd=legend('ADDB','ADDG','ADDL','GMEDa','GMEDp','GMIN');
    title('HIP ADD/ABD')
    xlabel('GAIT CYCLE %') 
    ylabel('Force [N]') 
    lgd.FontSize = 15;
    s=gca;
    set(s,'fontsize',15)
    hold off
    grid;
 
    subplot(3,2,5)
    plot(x1,sol(:,[1,14,15,16,17]),'LineWidth',1);
    
%    plot(x1,sol(:,1),x1,sol(:,14),x1,sol(:,15),...
%        x1,sol(:,16),x1,sol(:,17),'LineWidth',1);
    hold on
    xline(k,'-','Color','r','LineWidth',2);
    lgd=legend('RF','VM','VI','VL','BFCB');
    title('KNEE FLEX/EX')
    xlabel('GAIT CYCLE %') 
    ylabel('Force [N]') 
    lgd.FontSize = 15;
    s=gca;
    set(s,'fontsize',15)
    hold off
    grid;
 
    subplot(3,2,6)
    plot(x1,sol(:,[13,18,19,20]),'LineWidth',1);
%    plot(x1,sol(:,13),x1,sol(:,18),...
%        x1,sol(:,19),x1,sol(:,20),'LineWidth',1);
    hold on
    xline(k,'-','Color','r','LineWidth',2);
    lgd=legend('GAS','SO','TA','PE');
    title('ANKLE FLEX/EX')
    xlabel('GAIT CYCLE %') 
    ylabel('Force [N]') 
    lgd.FontSize = 15;
    s=gca;
    set(s,'fontsize',15)
    hold off
    grid;
    
    
    drawnow limitrate
  end
  



f2=figure('Visible','on');
    
    subplot(2,2,1)
    plot(momH)
    xlabel('GAIT CYCLE %') 
    ylabel('Moment Nm/Kg')
    title('HIP MOMENT')
    grid;
    hold on
    
    subplot(2,2,2)
    plot(momA)
    xlabel('GAIT CYCLE %') 
    ylabel('Moment Nm/Kg')
    title('ANKLE MOMENT')
    grid;
    hold on
    
    subplot(2,2,3)
    plot(momK)
    xlabel('GAIT CYCLE %') 
    ylabel('Moment Nm/Kg')
    title('KNEE MOMENT')
    grid;
    hold on
    
    subplot(2,2,4)
    plot(momHAbb)
    xlabel('GAIT CYCLE %') 
    ylabel('Moment Nm/Kg')
    title('HIP ABBDUCTION MOMENT')
    grid;
%   saveas(gcf,'Subject6(MOMENT).svg')




