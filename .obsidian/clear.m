clear
input = figure('Position',[600 400 250 250],'Name','Chose models');
txt = uicontrol('Parent',input,...
 'Style','text',...
 'Position',[20 170 210 40],...
 'String','Choose needed tables to generate.');
chA = uicontrol('Parent',input,...
 'Style','checkbox',...
 'Position',[20 130 80 40],...
 'String','A');
chB = uicontrol('Parent',input,...
 'Style','checkbox',...
 'Position',[60 130 80 40],...
 'String','B');
chC = uicontrol('Parent',input,...
 'Style','checkbox',...
 'Position',[100 130 80 40],...
 'String','C');
chD = uicontrol('Parent',input,...
 'Style','checkbox',...
 'Position',[140 130 80 40],...
 'String','D');
chFi = uicontrol('Parent',input,...
 'Style','checkbox',...
 'Position',[180 130 80 40],...
 'String','F(I)');
chFii = uicontrol('Parent',input,...
 'Style','checkbox',...
 'Position',[20 90 80 40],...
 'String','F(II)');
chG = uicontrol('Parent',input,...
 'Style','checkbox',...
 'Position',[60 90 80 40],...
 'String','G');
chH = uicontrol('Parent',input,...
 'Style','checkbox',...
 'Position',[100 90 80 40],...
 'String','H');
chI = uicontrol('Parent',input,...
 'Style','checkbox',...
 'Position',[140 90 80 40],...
 'String','I');
chJ = uicontrol('Parent',input,...
 'Style','checkbox',...
 'Position',[180 90 80 40],...
 'String','J');
uicontrol('Position',[100 20 50 50],'String','Done',...
 'Callback','uiresume(gcbf)');
uiwait(gcf);
chA=get(chA,'value');
chB=get(chB,'value');
chC=get(chC,'value');
chD=get(chD,'value');
chFi=get(chFi,'value');
chFii=get(chFii,'value');
chG=get(chG,'value');
chH=get(chH,'value');
chI=get(chI,'value');
chJ=get(chJ,'value');
input.Visible='off';
%
input = figure('Position',[600 400 250 250],'Name','Chose models');
txt = uicontrol('Parent',input,...
 'Style','text',...
 'Position',[20 170 210 40],...
 'String','Choose ONE model You want to simulate.');
ch1 = uicontrol('Parent',input,...
 'Style','checkbox',...
 'Position',[10 100 80 40],...
 'String','Vacuum');
ch2 = uicontrol('Parent',input,...
 'Style','checkbox',...
 'Position',[70 100 80 40],...
 'String','PMM');
ch3 = uicontrol('Parent',input,...
 'Style','checkbox',...
 'Position',[120 100 80 40],...
 'String','MPMM');
ch4 = uicontrol('Parent',input,...
 'Style','checkbox',...
 'Position',[180 100 80 40],...
 'String','5-DOF');
ch5 = uicontrol('Parent',input,...
 'Style','checkbox',...
 'Position',[10 130 80 40],...
 'String','Analytical');
uicontrol('Position',[100 20 50 50],'String','Done',...
 'Callback','uiresume(gcbf)');
uiwait(gcf);
ch1=get(ch1,'value');
ch2=get(ch2,'value');
ch3=get(ch3,'value');
ch4=get(ch4,'value');
ch5=get(ch5,'value');
input.Visible='off';
%
in = inputdlg({'Muzzel Velocity','Diameter','Mass'},...
 'Input',[1 30],{'95.6','81','4.34'});
V=str2double(in{1});
dia=str2double(in{2})/1000;
mass=str2double(in{3});
[aero,iner,tc]=aero_data((dia*1000));
fi=figure('NumberTitle','off','Name','Coefficiant','Position',[300 200 700 490]);
uicontrol('Position',[20 420 50 50],'String','Done',...
 'Callback','uiresume(gcbf)');
inretia=uitable(fi,'data',num2cell(iner),'Position',[90 410 460 70]);
inretia.ColumnName={ 'Mass' , 'Ixx' , 'Iyy' , 'Izz' ,'Ixy' ,'Ixz' , 'Iyz' , 'Ycg' , 'Zcg' , 'Xcg'};
inretia.RowName={};
inretia.ColumnEditable=true;
twist=uitable(fi,'data',num2cell(tc),'Position',[580 410 100 70]);
twist.ColumnName={'Muzzel Twist'};
twist.RowName={};
twist.ColumnEditable=true;
coeff=uitable(fi,'data',num2cell(aero),'Position',[20 20 660 380]);
coeff.ColumnName={'Mach' , 'Cd0' , 'Cda2' , 'Cdb' , 'CLa' , 'CLa3', 'Cma' , 'Cma3' , 'Cmq' , 'Cl' , 'Clp' , 'Cypa' , 'Cypa3','Cmpa' , 'Cmpa3' , 'Cn0' , 'Bet1' , 'Cm0' , 'Bet2' , 'Cxd' ,'Xc'};
coeff.ColumnWidth={50};
coeff.ColumnEditable=true;
uiwait(gcf);
mnm=(get(coeff,'data'));
[wid,len]=size(aero);
for row=1:wid
 for col=1:len
 aero(row,col)=mnm{row,col};
 end
end
fi.Visible='off';

ele_start=8;
ele_inter=1;
ele_end=66;
if ch1==1
 j=1;
 for elev = ele_start:ele_inter:45

[POS_V{j},i_V(j),T_V{j},TOF_V{j},MH_V_L(j),ang_L(j)]=Vacuum(V,elev,0,0,0,0,0,0);
 Ran=POS_V{j};
 Tim=TOF_V{j};
 Range_L(j)=Ran(i_V(j),1);
 Drift_L(j)=Ran(i_V(j),3);
 TOF_L(j)=Tim(1);
 j=j+1;
 end
Fit_range_L = fit( rot90(Range_L),(rot90(ele_start:ele_inter:45)),'linearinterp' );
Fit_drift_L = fit( rot90(Range_L),rot90(Drift_L), 'linearinterp' );
Fit_TOF_L = fit( rot90(Range_L),(rot90(TOF_L)), 'linearinterp' );
Fit_MH_L = fit( rot90(Range_L),(rot90(MH_V_L)), 'linearinterp' );
Fit_ang_L = fit( rot90(Range_L),(rot90(ang_L)), 'linearinterp' );
 j=1;
 for elev = 45:ele_inter:ele_end

[POS_V{j},i_V(j),T_V{j},TOF_V{j},MH_V_U(j),ang_U(j)]=Vacuum(V,elev,0,0,0,0,0,0);
 Ran=POS_V{j};
 Tim=TOF_V{j};
 Range_U(j)=Ran(i_V(j),1);
 Drift_U(j)=Ran(i_V(j),3);
 TOF_U(j)=Tim(1);
 j=j+1;
 end
Fit_range_U = fit( rot90(Range_U),(rot90(45:ele_inter:ele_end)),'linearinterp' );
Fit_drift_U = fit( rot90(Range_U),rot90(Drift_U), 'linearinterp' );
Fit_TOF_U = fit( rot90(Range_U),(rot90(TOF_U)), 'linearinterp' );
Fit_MH_U = fit( rot90(Range_U),(rot90(MH_V_U)), 'linearinterp' );
Fit_ang_U = fit( rot90(Range_U),(rot90(ang_U)), 'linearinterp' );
i=1;
if chA==1
 for rang = round(min(Range_U),-2):1000:round(max(Range_U),-2)
 elev=Fit_range_U(rang);
 j=1;
 for Y = -500:100:500

[POS_V_1{j},i_V_1(j),T_V_1{j},TOF_V_1{j},MH_V_1(j)]=Vacuum(V,elev,Y,0,0,0,0,0);
 Ran=POS_V_1{j};
 Range_Alt(j)=Ran(i_V_1(j),1);
 j=j+1;
 end
 Range_B(i,:)=round(Range_Alt-Range_Alt(6));
 i=i+1;
 end
end
end
if ch2==1
 j=1;
 for elev = ele_start:ele_inter:45

[POS_V{j},i_V(j),T_V{j},TOF_V{j},ang_L(j),MH_V_L(j)]=PMM(V,elev,dia,mass,aero,0,0,0,0,0,0);
 Ran=POS_V{j};
 Tim=TOF_V{j};
 Range_L(j)=Ran(i_V(j)-1,1);
 Drift_L(j)=Ran(i_V(j)-1,3);
 TOF_L(j)=Tim(1);
 j=j+1;
 end
Fit_range_L = fit( rot90(Range_L),(rot90(ele_start:ele_inter:45)),'linearinterp' );
Fit_drift_L = fit( rot90(Range_L),rot90(Drift_L), 'linearinterp' );
Fit_TOF_L = fit( rot90(Range_L),(rot90(TOF_L)), 'linearinterp' );
Fit_MH_L = fit( rot90(Range_L),(rot90(MH_V_L)), 'linearinterp' );
Fit_ang_L = fit( rot90(Range_L),(rot90(ang_L)), 'linearinterp' );
 j=1;
 for elev = 45:ele_inter:ele_end

[POS_V{j},i_V(j),T_V{j},TOF_V{j},ang_U(j),MH_V_U(j)]=PMM(V,elev,dia,mass,aero,0,0,0,0,0,0);
 Ran=POS_V{j};
 Tim=TOF_V{j};
 Range_U(j)=Ran(i_V(j)-1,1);
 Drift_U(j)=Ran(i_V(j)-1,3);
 TOF_U(j)=Tim(1);
 j=j+1;
 end
Fit_range_U = fit( rot90(Range_U),(rot90(45:ele_inter:ele_end)),'linearinterp' );
Fit_drift_U = fit( rot90(Range_U),rot90(Drift_U), 'linearinterp' );
Fit_TOF_U = fit( rot90(Range_U),(rot90(TOF_U)), 'linearinterp' );
Fit_MH_U = fit( rot90(Range_U),(rot90(MH_V_U)), 'linearinterp' );
Fit_ang_U = fit( rot90(Range_U),(rot90(ang_U)), 'linearinterp' );
if chA==1
i=1;
 for rang = round(min(Range_U),-2):1000:round(max(Range_U),-2)
 elev=Fit_range_U(rang);
 j=1;
 for Y = -500:100:500

[POS_V_1{j},i_V_1(j),T_V_1{j},TOF_V_1{j},ang_L_1(j),MH_V_L_1(j)]=PMM(V,elev,dia,mass,aero,Y,0,0,0,0,0);
 Ran=POS_V_1{j};
 Range_Alt(j)=Ran(i_V_1(j)-1,1);
 j=j+1;
 end
 Range_B(i,:)=round(Range_Alt-Range_Alt(6));
 i=i+1;
 end
end
end
if ch3==1
 j=1;
 for elev = ele_start:ele_inter:45

[POS_V{j},i_V(j),~,T_V{j},TOF_V{j},~,ang_L(j),MH_V_L(j)]=MPMM(V,elev,dia,mass,aero,iner,tc,0,0,0,0,0,0);
 Ran=POS_V{j};
 Tim=TOF_V{j};
 Range_L(j)=Ran(i_V(j)-1,1);
 Drift_L(j)=Ran(i_V(j)-1,3);
 TOF_L(j)=Tim(1);
 j=j+1;
 end
Fit_range_L = fit( rot90(Range_L),(rot90(ele_start:ele_inter:45)),'linearinterp' );
Fit_drift_L = fit( rot90(Range_L),rot90(Drift_L), 'linearinterp' );
Fit_TOF_L = fit( rot90(Range_L),(rot90(TOF_L)), 'linearinterp' );
Fit_MH_L = fit( rot90(Range_L),(rot90(MH_V_L)), 'linearinterp' );
Fit_ang_L = fit( rot90(Range_L),(rot90(ang_L)), 'linearinterp' );
 j=1;
 for elev = 45:ele_inter:ele_end

[POS_V{j},i_V(j),~,T_V{j},TOF_V{j},~,ang_U(j),MH_V_U(j)]=MPMM(V,elev,dia,mass,aero,iner,tc,0,0,0,0,0,0);
 Ran=POS_V{j};
 Tim=TOF_V{j};
 Range_U(j)=Ran(i_V(j)-1,1);
 Drift_U(j)=Ran(i_V(j)-1,3);
 TOF_U(j)=Tim(1);
 j=j+1;
 end
Fit_range_U = fit( rot90(Range_U),(rot90(45:ele_inter:ele_end)),'linearinterp' );
Fit_drift_U = fit( rot90(Range_U),rot90(Drift_U), 'linearinterp' );
Fit_TOF_U = fit( rot90(Range_U),(rot90(TOF_U)), 'linearinterp' );
Fit_MH_U = fit( rot90(Range_U),(rot90(MH_V_U)), 'linearinterp' );
Fit_ang_U = fit( rot90(Range_U),(rot90(ang_U)), 'linearinterp' );
if chB==1
i=1;

 for rang = round(min(Range_U),-2):1000:round(max(Range_U),-2)
 elev=Fit_range_U(rang);
 j=1;
 for Y = -500:100:500

[POS_V_1{j},i_V_1(j),~,T_V_1{j},TOF_V_1{j},~,ang_U_1(j),MH_V_U_1(j)]=MPMM(V,elev,dia,mass,aero,iner,tc,Y,0,0,0,0,0);
 Ran=POS_V_1{j};
 Range_Alt(j)=Ran(i_V_1(j)-1,1);
 j=j+1;
 end
 Range_B(i,:)=round(Range_Alt-Range_Alt(6));
 i=i+1;
 end
end
end
if ch4==1
 j=1;
 for elev = ele_start:ele_inter:45

[POS_V{j},i_V(j),~,T_V{j},TOF_V{j},~,ang_L(j),MH_V_L(j)]=DOF5(V,elev,dia,mass,aero,iner,tc,0,0,0,0,0,0);
 Ran=POS_V{j};
 Tim=TOF_V{j};
 Range_L(j)=Ran(i_V(j)-1,1);
 Drift_L(j)=Ran(i_V(j)-1,3);
 TOF_L(j)=Tim(1);
 j=j+1;
 end
Fit_range_L = fit( rot90(Range_L),(rot90(ele_start:ele_inter:45)),'linearinterp' );
Fit_drift_L = fit( rot90(Range_L),rot90(Drift_L), 'linearinterp' );
Fit_TOF_L = fit( rot90(Range_L),(rot90(TOF_L)), 'linearinterp' );
Fit_MH_L = fit( rot90(Range_L),(rot90(MH_V_L)), 'linearinterp' );
Fit_ang_L = fit( rot90(Range_L),(rot90(ang_L)), 'linearinterp' );
 j=1;
 for elev = 45:ele_inter:ele_end

[POS_V{j},i_V(j),~,T_V{j},TOF_V{j},~,ang_U(j),MH_V_U(j)]=DOF5(V,elev,dia,mass,aero,iner,tc,0,0,0,0,0,0);
 Ran=POS_V{j};
 Tim=TOF_V{j};
 Range_U(j)=Ran(i_V(j)-1,1);
 Drift_U(j)=Ran(i_V(j)-1,3);
 TOF_U(j)=Tim(1);
 j=j+1;
 end
Fit_range_U = fit( rot90(Range_U),(rot90(45:ele_inter:ele_end)),'linearinterp' );
Fit_drift_U = fit( rot90(Range_U),rot90(Drift_U), 'linearinterp' );
Fit_TOF_U = fit( rot90(Range_U),(rot90(TOF_U)), 'linearinterp' );
Fit_MH_U = fit( rot90(Range_U),(rot90(MH_V_U)), 'linearinterp' );
Fit_ang_U = fit( rot90(Range_U),(rot90(ang_U)), 'linearinterp' );
end
d=figure('Name',['Firing Tables for ' num2str(dia*1000) 'mm projectile'
],'NumberTitle','off'...
 ,'Position',[500 500 700 700]);
m=uitabgroup(d);
in = inputdlg({'Range interval'},...
 'Input',[1 30],{'500'});
 Print_start=round(min(Range_U),-3);
 Print_Int=str2double(in{1});
 Print_max=round(max(Range_L),-3);
%%%
if chFi == 1
 j=1;
for rang=round(Print_start):Print_Int:round(max(Range_L),-2)
elev_deg=Fit_range_L(rang);
elev_mil=Fit_range_L(rang)*800/45;
TOF=Fit_TOF_L(rang);
Max_H=Fit_MH_L(rang);
 if Max_H <= 200
 Met_line_=00;
 elseif Max_H <= 500
 Met_line_=01;
 elseif Max_H <= 1000
 Met_line_=02;
 elseif Max_H <= 1500
 Met_line_=3;
 elseif Max_H <= 2000
 Met_line_=04;
 elseif Max_H <= 2500
 Met_line_=05;
 elseif Max_H <= 3000
 Met_line_=06;
 else
 Met_line_=07;
 end
ang_Im=Fit_ang_L(rang);
drift=Fit_drift_L(rang);
Table_Fi(j,:)=([rang,elev_deg,elev_mil,TOF,Met_line_,Max_H,ang_Im,drift]);
j=j+1;
end
for rang=round((Print_max)):-Print_Int:round(min(Range_U),-2)
elev_deg=Fit_range_U(rang);
elev_mil=Fit_range_U(rang)*800/45;
TOF=Fit_TOF_U(rang);
Max_H=Fit_MH_U(rang);
if Max_H <= 200
 Met_line_=00;
 elseif Max_H <= 500
 Met_line_=01;
 elseif Max_H <= 1000
 Met_line_=02;
 elseif Max_H <= 1500
 Met_line_=3;
 elseif Max_H <= 2000
 Met_line_=04;
 elseif Max_H <= 2500
 Met_line_=05;
 elseif Max_H <= 3000
 Met_line_=06;
 else
 Met_line_=07;
end
 ang_Im=Fit_ang_U(rang);
drift=Fit_drift_U(rang);
Table_Fi(j,:)=([rang,elev_deg,elev_mil,TOF,Met_line_,Max_H,ang_Im,drift]);
j=j+1;
end
tab6 = uitab(m,'Title','Table F(I)');
 S=uitable(tab6,'data',Table_Fi,'Position',[50 50 600 500]...
 ,'ColumnWidth',{'auto' 'auto' 'auto' 50 70 65 'auto' 'auto'});
 S.ColumnName={'Range','ELEV (deg)','ELEV (mil)','TOF (s)','METLine','APEX','Impact Ang','Deflect'};
 S.FontSize=10;
 Label = uicontrol('Parent',tab6,...
 'Style', 'text',...
 'Position', [0 600 700 20],...
 'String', 'BASIC DATA',...
 'FontSize',12);
end
%%%
if chFii == 1
 j=1;

 if ch2==1
for rang=round(Print_start):Print_Int:round(max(Range_L),-2)
elev=Fit_range_L(rang);
[POS_V,i_V,~,~,~,~]=PMM(V+1,elev,dia,mass,aero,0,0,0,0,0,0);
r_V_inc=POS_V(i_V-1,1)-rang;
 [POS_V,i_V,~,~,~,~]=PMM(V-1,elev,dia,mass,aero,0,0,0,0,0,0);
r_V_dec=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=PMM(V,elev,dia,mass,aero,0,0.51444,0,0,0,0);
r_Wt=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=PMM(V,elev,dia,mass,aero,0,-0.51444,0,0,0,0);
r_Wh=POS_V(i_V-1,1)-rang;
 [POS_V,i_V,~,~,~,~]=PMM(V,elev,dia,mass,aero,0,0,0.514444,0,0,0);
r_Wc=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=PMM(V,elev,dia,mass,aero,0,0,0,1,0,0);
r_temp_inc=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=PMM(V,elev,dia,mass,aero,0,0,0,-1,0,0);
r_temp_dec=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=PMM(V,elev,dia,mass,aero,0,0,0,0,1,0);
r_dencity_inc=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=PMM(V,elev,dia,mass,aero,0,0,0,0,-1,0);
r_dencity_dec=POS_V(i_V-1,1)-rang;
 r_mass_inc=0;
 r_mass_dec=0;

Table_Fii(j,:)=round([rang,r_V_inc,r_V_dec,r_Wt,r_Wh,r_Wc,r_temp_inc,r_temp_dec...
    ,r_dencity_inc,r_dencity_dec,r_mass_inc,r_mass_dec],1);
j=j+1;
end
for rang=round(Print_max):-Print_Int:round(min(Range_U),-2)
 elev=Fit_range_U(rang);
[POS_V,i_V,~,~,~,~]=PMM(V+1,elev,dia,mass,aero,0,0,0,0,0,0);

r_V_inc=POS_V(i_V-1,1)-rang;
 [POS_V,i_V,~,~,~,~]=PMM(V-1,elev,dia,mass,aero,0,0,0,0,0,0);
r_V_dec=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=PMM(V,elev,dia,mass,aero,0,0.51444,0,0,0,0);
r_Wt=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=PMM(V,elev,dia,mass,aero,0,-0.51444,0,0,0,0);
r_Wh=POS_V(i_V-1,1)-rang;
 [POS_V,i_V,~,~,~,~]=PMM(V,elev,dia,mass,aero,0,0,0.514444,0,0,0);
r_Wc=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=PMM(V,elev,dia,mass,aero,0,0,0,1,0,0);
r_temp_inc=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=PMM(V,elev,dia,mass,aero,0,0,0,-1,0,0);
r_temp_dec=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=PMM(V,elev,dia,mass,aero,0,0,0,0,1,0);
r_dencity_inc=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=PMM(V,elev,dia,mass,aero,0,0,0,0,-1,0);
r_dencity_dec=POS_V(i_V-1,1)-rang;
 r_mass_inc=0;
 r_mass_dec=0;

Table_Fii(j,:)=round([rang,r_V_inc,r_V_dec,r_Wt,r_Wh,r_Wc,r_temp_inc,r_temp_dec...
    ,r_dencity_inc,r_dencity_dec,r_mass_inc,r_mass_dec],1);
 j=j+1;
end
 end

 if ch3==1
for rang=round(Print_start):Print_Int:round(max(Range_L),-2)
elev=Fit_range_L(rang);
[POS_V,i_V,~,~,~,~]=MPMM(V+1,elev,dia,mass,aero,iner,tc,0,0,0,0,0,0);
r_V_inc=POS_V(i_V-1,1)-rang;
 [POS_V,i_V,~,~,~,~]=MPMM(V-1,elev,dia,mass,aero,iner,tc,0,0,0,0,0,0);
r_V_dec=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=MPMM(V,elev,dia,mass,aero,iner,tc,0,0.51444,0,0,0,0);
r_Wt=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=MPMM(V,elev,dia,mass,aero,iner,tc,0,-0.51444,0,0,0,0);
r_Wh=POS_V(i_V-1,1)-rang;

[POS_V,i_V,~,~,~,~]=MPMM(V,elev,dia,mass,aero,iner,tc,0,0,0.514444,0,0,0);
r_Wc=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=MPMM(V,elev,dia,mass,aero,iner,tc,0,0,0,1,0,0);
r_temp_inc=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=MPMM(V,elev,dia,mass,aero,iner,tc,0,0,0,-1,0,0);
r_temp_dec=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=MPMM(V,elev,dia,mass,aero,iner,tc,0,0,0,0,1,0);
r_dencity_inc=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=MPMM(V,elev,dia,mass,aero,iner,tc,0,0,0,0,-1,0);
r_dencity_dec=POS_V(i_V-1,1)-rang;
 r_mass_inc=0;
 r_mass_dec=0;


Table_Fii(j,:)=round([rang,r_V_inc,r_V_dec,r_Wt,r_Wh,r_Wc,r_temp_inc,r_temp_dec...
 ,r_dencity_inc,r_dencity_dec,r_mass_inc,r_mass_dec],1);
j=j+1;
end
for rang=round(Print_max):-Print_Int:round(min(Range_U),-2)
 elev=Fit_range_U(rang);
[POS_V,i_V,~,~,~,~]=MPMM(V+1,elev,dia,mass,aero,iner,tc,0,0,0,0,0,0);
r_V_inc=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=MPMM(V-1,elev,dia,mass,aero,iner,tc,0,0,0,0,0,0);
r_V_dec=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=MPMM(V,elev,dia,mass,aero,iner,tc,0,0.51444,0,0,0,0);
r_Wt=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=MPMM(V,elev,dia,mass,aero,iner,tc,0,-0.51444,0,0,0,0);
r_Wh=POS_V(i_V-1,1)-rang;

[POS_V,i_V,~,~,~,~]=MPMM(V,elev,dia,mass,aero,iner,tc,0,0,0.514444,0,0,0);
r_Wc=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=MPMM(V,elev,dia,mass,aero,iner,tc,0,0,0,1,0,0);
r_temp_inc=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=MPMM(V,elev,dia,mass,aero,iner,tc,0,0,0,-1,0,0);
r_temp_dec=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=MPMM(V,elev,dia,mass,aero,iner,tc,0,0,0,0,1,0);
r_dencity_inc=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=MPMM(V,elev,dia,mass,aero,iner,tc,0,0,0,0,-1,0);
r_dencity_dec=POS_V(i_V-1,1)-rang;
 r_mass_inc=0;
 r_mass_dec=0;

Table_Fii(j,:)=round([rang,r_V_inc,r_V_dec,r_Wt,r_Wh,r_Wc,r_temp_inc,r_temp_dec...
 ,r_dencity_inc,r_dencity_dec,r_mass_inc,r_mass_dec],1);
 j=j+1;
end
 end

 if ch4==1
for rang=round(Print_start):Print_Int:round(max(Range_L),-2)
elev=Fit_range_L(rang);
[POS_V,i_V,~,~,~,~]=DOF5(V+1,elev,dia,mass,aero,iner,tc,0,0,0,0,0,0);
r_V_inc=POS_V(i_V-1,1)-rang;
 [POS_V,i_V,~,~,~,~]=DOF5(V-1,elev,dia,mass,aero,iner,tc,0,0,0,0,0,0);
r_V_dec=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=DOF5(V,elev,dia,mass,aero,iner,tc,0,0.51444,0,0,0,0);
r_Wt=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=DOF5(V,elev,dia,mass,aero,iner,tc,0,-0.51444,0,0,0,0);
r_Wh=POS_V(i_V-1,1)-rang;

[POS_V,i_V,~,~,~,~]=DOF5(V,elev,dia,mass,aero,iner,tc,0,0,0.514444,0,0,0);
r_Wc=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=DOF5(V,elev,dia,mass,aero,iner,tc,0,0,0,1,0,0);
r_temp_inc=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=DOF5(V,elev,dia,mass,aero,iner,tc,0,0,0,-1,0,0);
r_temp_dec=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=DOF5(V,elev,dia,mass,aero,iner,tc,0,0,0,0,1,0);
r_dencity_inc=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=DOF5(V,elev,dia,mass,aero,iner,tc,0,0,0,0,-1,0);
r_dencity_dec=POS_V(i_V-1,1)-rang;
 r_mass_inc=0;
 r_mass_dec=0;



Table_Fii(j,:)=round([rang,r_V_inc,r_V_dec,r_Wt,r_Wh,r_Wc,r_temp_inc,r_temp_dec...
 ,r_dencity_inc,r_dencity_dec,r_mass_inc,r_mass_dec],1);
j=j+1;
end
for rang=round(Print_max):-Print_Int:round(min(Range_U),-2)
 elev=Fit_range_U(rang);
[POS_V,i_V,~,~,~,~]=DOF5(V+1,elev,dia,mass,aero,iner,tc,0,0,0,0,0,0);
r_V_inc=POS_V(i_V-1,1)-rang;
 [POS_V,i_V,~,~,~,~]=DOF5(V-1,elev,dia,mass,aero,iner,tc,0,0,0,0,0,0);
r_V_dec=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=DOF5(V,elev,dia,mass,aero,iner,tc,0,0.51444,0,0,0,0);
r_Wt=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=DOF5(V,elev,dia,mass,aero,iner,tc,0,-0.51444,0,0,0,0);
r_Wh=POS_V(i_V-1,1)-rang;

[POS_V,i_V,~,~,~,~]=DOF5(V,elev,dia,mass,aero,iner,tc,0,0,0.514444,0,0,0);
r_Wc=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=DOF5(V,elev,dia,mass,aero,iner,tc,0,0,0,1,0,0);
r_temp_inc=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=DOF5(V,elev,dia,mass,aero,iner,tc,0,0,0,-1,0,0);
r_temp_dec=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=DOF5(V,elev,dia,mass,aero,iner,tc,0,0,0,0,1,0);
r_dencity_inc=POS_V(i_V-1,1)-rang;
[POS_V,i_V,~,~,~,~]=DOF5(V,elev,dia,mass,aero,iner,tc,0,0,0,0,-1,0);
r_dencity_dec=POS_V(i_V-1,1)-rang;
 r_mass_inc=0;
 r_mass_dec=0;

Table_Fii(j,:)=round([rang,r_V_inc,r_V_dec,r_Wt,r_Wh,r_Wc,r_temp_inc,r_temp_dec...
 ,r_dencity_inc,r_dencity_dec,r_mass_inc,r_mass_dec],1);
 j=j+1;
end
 end

 tab7 = uitab(m,'Title','Table F(II)');
 S=uitable(tab7,'data',Table_Fii,'Position',[50 50 600 500]...
 ,'ColumnWidth',{'auto' 'auto' 'auto' 'auto' 'auto' 'auto' 'auto'
'auto' 'auto' 'auto'...
 'auto' 'auto'});
 S.ColumnName={'Range','Vel +1','Vel -1','Tail wind','Head wind','CrossWind',...
 'Temp +1','Temp -1','denc +1','denc -1','mass +1','mass -1'};
 S.FontSize=10;
 Label = uicontrol('Parent',tab7,...
 'Style', 'text',...
 'Position', [0 600 700 20],...
 'String', 'CORRECTIONS TO BEARING',...
 'FontSize',12);
end
%%%
if chA==1
 tab1 = uitab(m,'Title','Table A');
 Label = uicontrol('Parent',tab1,...
 'Style', 'text',...
 'Position', [0 600 700 20],...
 'String', 'LINE NUMBERS OF THE METEOROLOGICAL MESSAGE AS A FUNCTION OF QUADRANT ELEVATION !! EXTRA WINDOW',...
 'FontSize',12);
end
%%%
if chB == 1
 tab2 = uitab(m,'Title','Table B');
 Label = uicontrol('Parent',tab2,...
 'Style', 'text',...
 'Position', [0 600 700 20],...
 'String', 'COMPLEMENTARY CORRECTION RANGE IN METRER FOR DIFFERENCE IN ALTITUDE !! EXTRA WINDOW',...
 'FontSize',12);
end
%%%
if chC == 1
 tab3 = uitab(m,'Title','Table C');
 Label = uicontrol('Parent',tab3,...
 'Style', 'text',...
 'Position', [0 600 700 20],...
 'String', '?COMPONENTS OF A ONE KNOT WIND !! EXTRA WINDOW',...
 'FontSize',12);
end
%%%
if chD == 1
 tab4 = uitab(m,'Title','Table D');
 Label = uicontrol('Parent',tab4,...
 'Style', 'text',...
 'Position', [0 600 650 40],...
 'String', {'CORRECTIONS TO BALLISTIC AIR TEMPERATURE AND BALLISTIC AIR DENSITY AS A PERCENTAGE FOR DIFFERENCE & ALTITUDE BETWEEN BATTERY AND MET DAIUM PLANE !! EXTRA WINDOW'},... ... ...
'FontSize',12);
end
function[POS,i,TIME,TOF,IMP_ang,Max_height]=PMM(V,elev,D,mass,aero,Y,Wt,Wc,dtemp,ddensity,dmass)
%simulation Time
TIME=clock();
% projectile_info
mass = mass + dmass;
% intial condition
lat=0; %latitude
AZ=0; %Azmuth
v=zeros(2,3); %Velocity victor
v(1,:)=V*([cosd(elev) sind(elev) 0]);
% intial calculation
R=[0 -6356766 0]; %Earth raduis
go=9.80665*(1-.0026*cosd(2*lat)); %intial gravity
earth_rot=7.29e-5; %Earth rotation speed
w=earth_rot*[cosd(lat)*cosd(AZ) sind(lat) -1*cosd(lat)*sind(AZ)]; %Earth
rotation velocity
%
pos=[0 Y 0;0 0 0]; %Position
POS=zeros(15000,3); %Position recorder
ANG=zeros(15000,3); %Angle recorder
wind=[Wt Wc];
% Pointers and Times
n=1;
i=1;
TOF=[0 0]; %Time of Flight
t=.0001; %Time step
seg_p=.1/t;%Print pointer
% convertor
elev=elev*(pi/180);
% Integration loop
while pos(1,2) >= 0 || pos(1,1) < 100 %min range 100

 %atmosphere parameters
 [~,ro,Va,~]=atmostd(pos(1,2),dtemp,ddensity);

 %forces constant
 K=.5*(pi*((D/2)^2))*ro;

 %Interpolation
 vr=[v(1,1)+wind(1) v(1,2) v(1,3)+wind(2)];
 mach=norm(vr)/Va;
 cdo=interpo(aero(:,1),aero(:,2),mach);
 %force claculation
 DF=(-1*K*(cdo)*V*vr)/mass; %Drag force = af/mass

 r=pos(1,:)-R;
 G=-1*go*(norm(R)^2 / norm(r)^3)*r; %Gravity
 A=-2*cross(w,v(1,:)); %Coriolis effect

 a=DF+G+A; %Acceleration
 %next step inegration
 v(2,:)=v(1,:)+(a*t);
 pos(2,:)=pos(1,:)+(v(2,:)*t);
 V=norm(v(2,:));

 %
 TOF(2)=TOF(1)+t;

 %old step reset
 TOF(1)=TOF(2);
 v(1,:)=v(2,:);
 pos(1,:)=pos(2,:);
 n=n+1;

 %Recording
if rem(n,seg_p)== 0 || n==2
 POS(i,:)=pos(1,:);
 ANG(i,1)=atan(v(1,2)/v(1,1));
 i=i+1;
end
 %warning overtime
 if TOF(1) > 200
 disp('SOMETHIG WRONG');
 break
 end
end
POS(i-1,1)=interpo([POS(i-2,2) pos(1,2)] , [POS(i-2,1) pos(1,1)], 0);
POS(i-1,3)=interpo([POS(i-2,2) pos(1,2)] , [POS(i-2,3) -pos(1,3)], 0);
POS(i-1,2)=0;
% Results
Max_height=max(POS(:,2));
ang=rad2deg(ANG(i-1,1));
% POS(i-1,1:3)
IMP_ang=rad2deg(atan(v(2,2)/v(2,1)));

TIME=clock()-TIME;
end
function[POS,i,AE,TIME,TOF,spin_re,IMP_ang,Max_height]=DOF5(V,eleva,D,mass,aero,iner,tc,Y,Wt,Wc,dtemp,ddensity,dmass)
TIME=clock();
Sar=pi*((D/2)^2);
mass = mass + dmass;
%Import_aerodynamic data from AERODYN6
Ix=interpo(iner(:,1),iner(:,2),mass-.7);
Iy=interpo(iner(:,1),iner(:,3),mass-.7);
%intial condition
alpha=[0 0 0];
lat=0;
AZ=0/800*45;
pos=[0 Y 0];
elev=[eleva AZ];
v=V*([cosd(elev(1,1))*cosd(AZ) sind(elev(1,1))*cosd(AZ) sind(AZ)]);
x=[cosd(elev(1,1))*cosd(AZ) sind(elev(1,1))*cosd(AZ) sind(AZ)];
%intial calculation
spino=(2*pi*V)/(tc*D);
spin=spino;
H=Ix*spin*x + Iy*crossi(x,[0 0 0]);
%
R=[0 -6356766 0];
go=9.80665*(1-0.0026*cosd(2*lat));
earth_rot=7.29e-5;
w=earth_rot*[cosd(lat)*cosd(AZ) sind(lat) -1*cosd(lat)*sind(AZ)];
%
POS=zeros(2000,3);
AE=zeros(2000,1);
%
n=1;
i=1;
TOF(1)=0;
%
wind=[Wt Wc];
DX=[0 0];
m=[0 0];
DSPIN=[0 0];
acc=[0 0];
%convertor
elev=elev*(pi/180);
%print out
 t=0.1/(spin/2/pi);
if 1/t==0
 seg_p=1/0.001;
else
 seg_p=round(1/t);
end
while pos(1,2) >= 0 || pos(1,1) < 600
t=max(.000001,.000001/DX(1));
t=min(t,.0002);
% atmosphere parameters
 [~,ro,Va,~]=atmostd(pos(1,2),dtemp,ddensity);
% forces constant
 K=.5*Sar*ro;
% Interpolation
 vr(1,:)=[v(1,1)+wind(1) v(1,2) v(1,3)+wind(2)];
 mach=norm(vr(1,:))/Va;
 cdo=interpo(aero(:,1),aero(:,2),mach);
 cda2=interpo(aero(:,1),aero(:,3),mach);
 cla=interpo(aero(:,1),aero(:,5),mach);
 cla3=interpo(aero(:,1),aero(:,6),mach);
 cma=interpo(aero(:,1),aero(:,7),mach);
 cma3=interpo(aero(:,1),aero(:,8),mach);
 cmq=interpo(aero(:,1),aero(:,9),mach);
 cl=interpo(aero(:,1),aero(:,10),mach);
 clp=interpo(aero(:,1),aero(:,11),mach);
 cypa=interpo(aero(:,1),aero(:,12),mach);
 cypa3=interpo(aero(:,1),aero(:,13),mach);
 cmpa=interpo(aero(:,1),aero(:,14),mach);
 cmpa3=interpo(aero(:,1),aero(:,15),mach);

% force and moment claculation
 DF=(-1*K* (cdo+(cda2*((norm(alpha)^2)))) * V * vr(1,:)) / mass;
 LF=K*(cla+(cla3*(norm(alpha)^2)))*(((V^2)*x)-(doti(vr(1,:),x)*vr(1,:)))/mass;

 MF=-1*(K*D*(cypa+(cypa3*((norm(alpha)^2)))))*doti(H,x)*crossi(x,vr(1,:))/(Ix*mass);
 PDF=K*(D/Iy)*(cmq)*V*crossi(H,x)/mass;
 TF=0;...((dmf*Isp)+((Pr- P )*Ae))*x/mass;

 r=pos(1,:)-R;
 G=-1*go*(norm(R)^2 / norm(r)^3)*r;
 A=-2*crossi(w,v(1,:));

 a=DF+LF+MF+PDF+TF+G+A;
 acc(1)=norm(a);
 if acc(1)>acc(2)
 acc(2)=acc(1);
 end
 fin_cant=0;
 %overturning
 OM=K*D*(cma+(cma3*(norm((alpha))^2)))*V*crossi(vr(1,:),x);
 %pitch damping
 PDM=K*((D^2)/Iy)*(cmq)*V*(H-(doti(H,x)*x));
 %magnus
 MM=-K*((D^2)/Ix)*(cmpa+(cmpa3*(norm(alpha)^2)))*doti(H,x)*((doti(vr(1,:),x)*x)-vr(1,:));
 %spin damping
 SDM=K*((D^2)/Ix)*clp*V*doti(H,x)*x;
 %fin cant
 FCM=K*D*cl*fin_cant*(V^2)*x;
 %jet damping
 AJDM=[0 0 0];...(dm*(rne^2)/2*Ix)*dot(H,pos(n,:))*pos(n,:);
 TJDM=[0 0 0];...(dm*re*rt/Iy)*(H-(dot(H,pos(n,:))*pos(n,:)));

 M=OM+PDM+MM+SDM+FCM+AJDM+TJDM;
 m(1)=norm(M);
 if m(1)>m(2)
 m(2)=m(1);
 end
% next step
 dx=crossi(H,x)/Iy;
 DX(1)=norm(dx);
 if DX(1)>DX(2)
 DX(2)=DX(1);
 end
 H=H+(M*t);
 %
 x=x+(dx*t);
 x=x/norm(x);
 v(2,:)=v(1,:)+(a*t);
 pos(2,:)=pos(1,:)+(v(2,:)*t);
 V=norm(v(2,:));
 %
 dspin=(pi*ro*(D^4)*spin*V*clp)/(16*Ix);
 DSPIN(1)=norm(dspin);
 if DSPIN(1)>DSPIN(2)
 DSPIN(2)=DSPIN(1);
 end
 spin=spin+(dspin*t);
 %
 alpha=acos(doti(v(1,:),x)/norm(v(1,:)));
 TOF(2)=TOF(1)+t;

% simulation timing
 TOF(1)=TOF(2);
 v(1,:)=v(2,:);
 pos(1,:)=pos(2,:);
 n=n+1;
 if rem(n,seg_p)== 0||n==2
 i=i+1;
 POS(i,1)=pos(1,1);
 POS(i,2)=pos(1,2);
 POS(i,3)=-pos(1,3);
 AE(i,:)=rad2deg(norm(alpha));
 end
 if AE(i-1,:)>40

 end
 if TOF(1) > 400
 disp('SOMETHIG WRONG');
 break
 end
end
POS(i,1)=interpo([POS(i-2,2) pos(1,2)] , [POS(i-2,1) pos(1,1)], 0);
POS(i,3)=interpo([POS(i-2,2) pos(1,2)] , [POS(i-2,3) -pos(1,3)], 0);
POS(i,2)=0;
Max_height=max(POS(:,2));
IMP_ang=rad2deg(atan(v(2,2)/v(2,1)));
spin_re=0;
end
function[POS,i,AE,TIME,TOF,spin_re,IMP_ang,Max_height]=MPMM(V,eleva,D,mass,aero,iner,tc,Y,Wt,Wc,dtemp,ddensity,dmass)
TIME=clock();
%projectile_info
mass = mass + dmass;
%Import_aerodynamic data from AERODYN6
Ix=interpo(iner(:,1),iner(:,2),mass-.7);
%intial condition
ae=[0 0 0];
lat=0;
AZ=0;
pos=[0 Y 0];
elev=[eleva AZ];
v=V*([cosd(elev(1,1))*cosd(AZ) sind(elev(1,1))*cosd(AZ) sind(AZ)]);
%intial calculation
spino=(2*pi*V)/(tc*D);
spin=spino;
%
R=[0 -6356766 0];
go=9.80665*(1-.0026*cosd(2*lat));
earth_rot=7.29e-5;
w=earth_rot*[cosd(lat)*cosd(AZ) sind(lat) -1*cosd(lat)*sind(AZ)];
%
POS=zeros(15000,3);
AE=zeros(15000,1);
spin_re=zeros(15000,1);
%
n=1;
i=1;
TOF(1)=0;
%
wind=[Wt Wc];
%convertor
elev=elev*(pi/180);
%print out
 t=.0001;
seg_p=.1/t;
while pos(1,2) >= 0 || pos(1,1) < 100
 %atmosphere parameters
 [~,ro,Va,~]=atmostd(pos(1,2),dtemp,ddensity);
 %forces constant
 K=.5*pi*((D/2)^2)*ro;
 vr(1,:)=[v(1,1)+wind(1) v(1,2) v(1,3)+wind(2)];
 %Interpolation
 mach=norm(vr(1,:))/Va;
 cdo=interpo(aero(:,1),aero(:,2),mach);
 cda2=interpo(aero(:,1),aero(:,3),mach);
 cla=interpo(aero(:,1),aero(:,5),mach);
 cla3=interpo(aero(:,1),aero(:,6),mach);
 cma=interpo(aero(:,1),aero(:,7),mach);
 cma3=interpo(aero(:,1),aero(:,8),mach);
 clp=interpo(aero(:,1),aero(:,11),mach);
 cypa=interpo(aero(:,1),aero(:,12),mach);
 cypa3=interpo(aero(:,1),aero(:,13),mach);

 %force claculation
 MF=-1*(K*D*(cypa+(cypa3*(norm(ae)^2)))*spin)*cross(ae,vr(1,:))/mass;
 DF=(-1*K*(cdo+(cda2*(norm(ae)^2)))*V*vr(1,:))/mass;
 LF=K*(cla+(cla3*((norm(ae)^2))))*(V^2)*ae/mass;

 r=pos(1,:)-R;
 G=-1*go*(norm(R)^2 / norm(r)^3)*r;
 A=-2*cross(w,v(1,:));

 a=DF+LF+MF+G+A;
 %next step inegration
 v(2,:)=v(1,:)+(a*t);
 pos(2,:)=pos(1,:)+(v(2,:)*t);
 V=norm(v(2,:));
 %
 dspin=(pi*ro*(D^4)*spin*V*clp)/(16*Ix);
 spin=spin+(dspin*t);
 %Yaw of repose
 ae=(-8*Ix*spin*cross(vr(1,:),a))/(pi*ro*(D^3)*(cma+(cma3*((norm(ae)^2))))*(V^4));
 %
 TOF(2)=TOF(1)+t;

 %next step reset
 TOF(1)=TOF(2);
 v(1,:)=v(2,:);
 pos(1,:)=pos(2,:);
 n=n+1;

if rem(n,seg_p)== 0 || n==2
 POS(i,:)=pos(1,:);
 AE(i,:)=rad2deg(norm(ae));
 spin_re(i)=V;
 i=i+1;
end
 %warning overtime
 if TOF(1) > 400
 disp('SOMETHIG WRONG');
 break
 end
end
POS(i,1)=interpo([POS(i-1,2) pos(1,2)] , [POS(i-1,1) pos(1,1)], 0);
POS(i,3)=interpo([POS(i-1,2) pos(1,2)] , [POS(i-1,3) -pos(1,3)], 0);
spin_re(i)=V;
POS(i,2)=0;
Max_height=max(POS(:,2));
IMP_ang=rad2deg(atan(v(2,2)/v(2,1)));
TIME=clock()-TIME;
end
 %Interpolation function
function [ y ] = interpo( X,Y,x )
n=1;
if X(n)>=x
 y=Y(n);
else
 while X(n)< x
n=n+1;
if n==40
 disp('error')
 break
end
 end
y=((Y(n)-Y(n-1))*(x-X(n-1)) / (X(n)-X(n-1)))+Y(n-1);
end
end
 %Atmosphere function
function [p,ro,Speed_Sound,Temp] = atmostd(h,dt,dd)

HIGHT=[-1000,-500,0,250,500,750,1000,1250,1500,1750,2000,2250,2500,2750,3000,3250,3500,3750,4000,4250,4500,4750,5000,5500,6000,6500,7000,7500,8000,9000,10000,11000,12000,13000,14000,15000,16000,17000,18000,19000,20000,21000,22000,23000,24000,25000,26000,27000,28000,29000,30000,31000,32000,33000,34000,35000,36000,37000,38000,39000,40000,42000,44000,46000,48000,50000,55000,60000,70000,80000,90000,100000,100000000];
PRESSURE=[113930,107480,101330,98357,95461,92634,89876,87185,84560,81999,79501,77066,74692,72377,70121,67923,65780,63693,61660,59680,57753,55875,54048,50539,47218,44075,41105,38300,35652,30801,26500,22700,19399,16580,14170,12112,10353,8849.70000000000,7565.20000000000,6467.50000000000,5529.30000000000,4728.90000000000,4047.50000000000,3466.90000000000,2971.70000000000,2549.20000000000,2188.40000000000,1880,1616.20000000000,1390.40000000000,1197,1031.30000000000,889.060000000000,767.310000000000,663.410000000000,574.590000000000,498.520000000000,433.250000000000,377.140000000000,328.820000000000,287.140000000000,219.970000000000,169.500000000000,131.340000000000,102.300000000000,79.7790000000000,42.7520000000000,22.4610000000000,5.52050000000000,1.03660000000000,0.164380000000000,0.0300750000000000,0.0300750000000000];
AIR_VELOCITY=[344.110000000000,342.210000000000,340.290000000000,339.300000000000,338.370000000000,337.400000000000,336.440000000000,335.500000000000,334.490000000000,333.500000000000,332.530000000000,331.500000000000,330.560000000000,329.600000000000,328.580000000000,327.600000000000,326.590000000000,325.600000000000,324.590000000000,323.600000000000,322.570000000000,321.600000000000,320.550000000000,318.500000000000,316.450000000000,314.400000000000,312.310000000000,310.200000000000,308.110000000000,303.850000000000,299.530000000000,295.140000000000,295.070000000000,295.070000000000,295.070000000000,295.070000000000,295.070000000000,295.070000000000,295.070000000000,295.070000000000,295.070000000000,295.070000000000,296.380000000000,297.050000000000,297.720000000000,298.390000000000,299.060000000000,299.720000000000,300.390000000000,301.050000000000,301.710000000000,302.370000000000,303.030000000000,304.670000000000,306.490000000000,308.300000000000,310.100000000000,311.890000000000,313.670000000000,315.430000000000,317.190000000000,320.670000000000,324.120000000000,327.520000000000,329.800000000000,329.800000000000,326.700000000000,320.610000000000,297.140000000000,269.440000000000,269.440000000000,269.440000000000,269.440000000000];
TEMP=[294.646201704771,291.399413915527,288.159073591186,286.510638968152,284.887792006577,283.270133092158,281.634902554590,280.028682491454,278.399598887547,276.768795266818,275.135107738514,273.525886793848,271.903743616807,270.277439662233,268.655129170021,267.032713032338,265.406876011573,263.784092023665,262.158780199907,260.535647240661,258.917567552036,257.292701854785,255.669252159539,252.424472578219,249.184842408186,245.936152714431,242.693566902156,239.456045365222,236.211980617831,229.732525582168,223.249349740061,216.771095712304,216.639986791731,216.648021086015,216.636735419804,216.655012426494,216.650941047752,216.647655618843,216.639999460261,216.637404287635,216.645607889204,217.574777913510,218.569803001479,219.564233391019,220.551862151634,221.545636980447,222.539815541173,223.537412675092,224.526282912201,225.515432210145,226.501304289879,227.498337729008,228.487209970579,230.969827704419,233.738501156729,236.506750743832,239.277549040834,242.045845702232,244.812571493966,247.580952821202,250.340530209278,255.873892347546,261.398470696066,266.926199087268,270.656925042927,270.639249051384,265.593535093532,255.771153765931,219.698465434136,180.646168941406,180.642551644286,21063.4836715160,21063.4836715160];
n=1;
 if HIGHT(n)>=h
 p=PRESSURE(n);
 Temp=TEMP(n);
 ro=(p/287.058/Temp);
 Speed_Sound=AIR_VELOCITY(n);
 else

 while HIGHT(n)< h

 n=n+1;
 if n==80
 disp('error')
 break
 end
 end

 p=((PRESSURE(n)-PRESSURE(n-1))*(h-HIGHT(n-1)) / (HIGHT(n)-HIGHT(n1)))+PRESSURE(n-1);
 Temp= (((TEMP(n)-TEMP(n-1))*(h-HIGHT(n-1)) / (HIGHT(n)-HIGHT(n1)))+TEMP(n-1));
 Temp=Temp+(Temp*dt/100);
 Speed_Sound=((AIR_VELOCITY(n)-AIR_VELOCITY(n-1))*(h-HIGHT(n-1)) /(HIGHT(n)-HIGHT(n-1)))+AIR_VELOCITY(n-1); ro=(p/287.058/Temp ); ro=ro+(ro*dd/100);
 end
end
 %Aerodynamics coefficients function
function [ aero,INER,tc ] = aero_data( d )
aero=zeros(13,21);
if d==81
aero(:,1)=[0.01 .5 .6 .8 .88 .9 .95 1 1.05 1.1 1.2 1.35 1.5];
aero(:,2)=[.157 .178 .168 .173 .244 .264 .507 .535 .621 .663 .642 .6 .567];
aero(:,3)=[3.125 3.125 3.125 3.125 4.25 5 5 5.25 5.75 6.5 6.75 6.5 6];
aero(:,4)=zeros(1,13);
aero(:,5)=[1.75 1.75 1.75 1.75 1.8 2 2 2.05 2.1 2.15 2.15 2.2 2.25];
aero(:,6)=[-1.3 -1.3 -1.4 -1.7 -2 -2.3 -2.6 -2.8 -2.8 -2.8 -2.8 -2.8 -2.8];
aero(:,7)=[-1.8 -1.8 -1.8 -2.1 -2.2 -2.4 -2.4 -2.5 -2.6 -2.7 -2.6 -2.5 -2.4];
aero(:,8)=[-2.5 -2.5 -2.5 -3 -3 -3.5 -3.5 -3.8 -4 -4.2 -4.4 -4.5 -4.5];
aero(:,9)=[-55.7 -56 -56 -57 -57.5 -58 -58 -58.5 -59 -59.5 -60 -60.5 -61];
aero(:,10)=[0.003 0.003 0.003 0.003 0.003 0.003 0.003 0.003 0.003 0.003 0.003 0.003 0.003];
aero(:,11)=[-.25 -.25 -.25 -.25 -.25 -.25 -.25 -.25 -.25 -.25 -.25 -.25 -.25];
INER=[1 .003382 .02725;2000 .003382 .02725];
tc=1/0;
clearvars filename startRow formatSpec fileID dataArray ans;
return
end
aero=zeros(13,21);
aero(:,1)=[0.01 .5 .6 .8 .88 .9 .95 1 1.05 1.1 1.2 1.35 1.5];
INER=zeros(2,10);
tc=0;
clearvars filename startRow formatSpec fileID dataArray ans;
end