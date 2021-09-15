clear all1
close all

sol=[];
Resoult=[];

tresholdLow=1.2;
tresholdHigh=1.45;

for x=1:50
    
n=int2str(x);

matname = ['Subject',n,'.mat'];

    if exist(matname,'file') ~= 2
        disp(['File ' matname ' not found.']);
       return;
    end

    load(matname);

    ntrial = length(s.Data);

    walk_indexes = [];

    for i = 1:ntrial
        if strcmpi(deblank(s.Data(i).Task),'Walking') && strcmpi(deblank(s.Data(i).Foot),'RX')
            walk_indexes = [walk_indexes i];
        end
    end


    for i=1:length(walk_indexes)

        speed=s.Data(i).speed;
        
        R=[];

        R=cat(2,R,x);
        R=cat(2,R,i);
        R=cat(2,R,speed);

        Resoult=cat(1,Resoult,R);

    end
    %TS = array2table(Resoult,'VariableNames',{'Speed'});
end

slow=sum((Resoult(:,3)<tresholdLow));
medium=sum((Resoult(:,3)>=tresholdLow).*(Resoult(:,3)<=tresholdHigh));
fast=sum((Resoult(:,3)>tresholdHigh));



c = linspace(1,50,length(Resoult(:,1)))
scatter(Resoult(:,1),Resoult(:,3),[],c,'filled')
yline(tresholdLow,'-','Color','r','LineWidth',2);
yline(tresholdHigh,'-','Color','r','LineWidth',2);

fprintf('Slow = %f\n', slow); 
fprintf('Medium = %f\n', medium); 
fprintf('Fast = %f\n', fast); 