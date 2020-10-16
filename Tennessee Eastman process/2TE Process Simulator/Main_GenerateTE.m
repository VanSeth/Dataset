close all
clear all

% u_IDV, this variable ranges from 0 to 28, which determins the fault mode
% Ts_base, is the sampling period of most discrete PI controllers used 
% in the simulation
% TS_save is the sampling period for saving results


u0=[63.053, 53.98, 24.644, 61.302, 22.21, 40.064, 38.10, 46.534, 47.446, 41.106, 18.114, 50];
for i=1:12;
    iChar=int2str(i);
    eval(['xmv',iChar,'_0=u0(',iChar,');']);
end

Fp_0=100;
r1_0=0.251/Fp_0;
r2_0=3664/Fp_0;
r3_0=4509/Fp_0;
r4_0=9.35/Fp_0;
r5_0=0.337/Fp_0;
r6_0=25.16/Fp_0;
r7_0=22.95/Fp_0;
Eadj_0=0;
SP17_0=80.1;

load Mode3xInitial;


% TS_base is the sampling period of most discrete PI controllers used 
% in the simulation.
Ts_base=0.001;
% TS_save is the sampling period for saving results.  The following
% variables are saved at the end of a run:
% tout    -  the elapsed time (hrs), length N.
% simout  -  the TE plant outputs, N by 41 matrix
% OpCost  -  the instantaneous operating cost, $/hr, length N
% xmv     -  the TE plant manipulated variables, N by 12 matrix
% idv     -  the TE plant disturbances, N by 20 matrix
Ts_save=0.001;
% Disturbances=[zeros(1,28)];

% ��ģʱΪ25h������ʱΪ48h
% u_IDVΪ���ϱ�ţ�ȡֵ1-28
tspan = [0 10]; 



u_IDV=0;
% This variable ranges from 0 to 28, which determins the fault mode.



IDV=u_IDV;

T_sim=tspan(2);
options = simset('Solver' ,'ode45','OutputVariables','xyt','OutputPoints','all','SaveFormat','Structure');
%%
t=[0:Ts_base:T_sim]';
[tem,~]=size(t);

u=zeros(tem,28);

u_Start=3000;

if (u_IDV)>0
    u(u_Start:end,u_IDV)=1;
end


sim_input=[t,u];

%%

tic;
[tt,xt,yt]=sim('MultiLoop_mode3',tspan,options,sim_input);

tSimtimeconsum=toc;
%break
%% TE
% TEdata.xy�У���1��Ϊ����ʱ�䣨h����2-42��Ϊprocess measurements������2-23��Ϊcontinuous(��22��)����19��Ϊsampled
% ��ֻ����continuous measurements���ټ���12��process manipulated variables
% ���42ά��TE_wch��ʹ��ʱӮ������һά������ʱ�䣩
% �����ݼ��У���27��31,34�е�����Ϊ��ֵ

TE_wch=[TEdata.xy(:,1:22), xmv];

if (u_IDV==0)
    TE_wch_normal=TE_wch;
    save TE_wch_normal.mat TE_wch_normal;
      
end

for i=1:28
    
    if (u_IDV)==i
               
        eval(['TE_wch_IDV_' num2str(i) '=TE_wch;']);
        eval(['save TE_wch_IDV_' num2str(i) '.mat TE_wch_IDV_' num2str(i) ';']);
      
    end
end





