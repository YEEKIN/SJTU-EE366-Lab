function smithfun(action) 
if nargin<1 
    action='initialize'; 
end

if strcmp(action,'initialize') 
    %建立用户控件界面 
    clf reset; 
    set(gcf,'menubar','none'); 
    set(gcf,'defaultuicontrolunits','normalized'); 
    set(gcf,'defaultuicontrolhorizontal','left'); 
    set(gcf,'resize','off'); 
    str='微波期中作业----单双枝节阻抗匹配'; 
    set(gcf,'name',str,'numbertitle','off'); 
    set(gcf,'unit','normalized','position',[0.2,0.2,0.5,0.6]);  
    H_axes=axes('position',[0.08,0.35,0.6,0.6],'xlim',[-1,1],'ylim',[-1,1]); 
    %生成框架控件 
    H_fig=get(H_axes,'parent');  
    H=uicontrol(H_fig,'style','frame','position',[0.72,0.05,0.25,0.65]);  
    H=uicontrol(H_fig,'style','frame','position',[0.72,0.75,0.25,0.2]);  
    H=uicontrol(H_fig,'style','frame','position',[0.08,0.05,0.6,0.2]); 
    %生成静态文本控件(显示作者姓名)  
    H=uicontrol(H_fig,'style','text','unit','normalized','position',[0.73,0.82,0.22,0.05],'fontname','微软雅黑','fontsize',12,'horizontal','left','string',{'518021910160 孔一鉴'});  
    %生成静态文本控件  
    H=uicontrol(H_fig,'style','text','unit','normalized','position',[0.73,0.63,0.20,0.05],'fontname','微软雅黑','fontsize',12,'horizontal','left','string',{' ZL =          '});  
    H=uicontrol(H_fig,'style','text','unit','normalized','position',[0.73,0.55,0.20,0.05],'fontname','微软雅黑','fontsize',12,'horizontal','left','string',{'  + j          '});  
    H=uicontrol(H_fig,'style','text','unit','normalized','position',[0.73,0.47,0.20,0.05],'fontname','微软雅黑','fontsize',12,'horizontal','left','string',{' Zo=          '});  
    %生成可编辑文本控件(输入R,X,Zo的值)  
    H_R=uicontrol(H_fig,'style','edit','position',[0.82,0.63,0.10,0.05],'fontname','微软雅黑');  
    H_X=uicontrol(H_fig,'style','edit','position',[0.82,0.55,0.10,0.05],'fontname','微软雅黑');  
    H_Zo=uicontrol(H_fig,'style','edit','position',[0.82,0.47,0.10,0.05],'fontname','微软雅黑'); 
    %生成静态文本控件(显示圆图的结果)  
    H_t1=uicontrol(H_fig,'style','text','unit','normalized','position',[0.74,0.39,0.22,0.05]);  
    H_t2=uicontrol(H_fig,'style','text','unit','normalized','position',[0.74,0.34,0.20,0.05]);  
    H_t3=uicontrol(H_fig,'style','text','unit','normalized','position',[0.74,0.29,0.20,0.05]);  
    H_t4=uicontrol(H_fig,'style','text','unit','normalized','position',[0.74,0.24,0.20,0.05]);  
    H_t5=uicontrol(H_fig,'style','text','unit','normalized','position',[0.1,0.1,0.54,0.08]);  
    H_t6=uicontrol(H_fig,'style','text','unit','normalized','position',[0.1,0.07,0.54,0.08]); 
    %生成按钮控件 
    H_circle=uicontrol(H_fig,'style','pushbutton','position',[0.735,0.21,0.22,0.07],'fontsize',10,'string','绘制Smith圆图','Callback',['smithfun(''plot__circle'');']); 
    H_circle=uicontrol(H_fig,'style','pushbutton','position',[0.735,0.14,0.22,0.07],'fontsize',10,'string','单支节并联匹配','callback',['smithfun(''plot_single_fun'');']); 
    H_circle=uicontrol(H_fig,'style','pushbutton','position',[0.735,0.07,0.22,0.07],'fontsize',10,'string','双支节并联匹配','callback',['smithfun(''plot_double_fun'');']); 
    %保存句柄矩阵用于交互式获取数据 
    Hdata=[H_R,H_X,H_Zo,H_t1,H_t2,H_t3,H_t4,H_t5,H_t6]; 
    set(H_fig,'userdata',Hdata); 
    %画出圆图      
    Hdata=get(gcf,'userdata'); 
    HR=Hdata(1); 
    HX=Hdata(2); 
    HZo=Hdata(3); 
    Ht1=Hdata(4); 
    Ht2=Hdata(5); 
    Ht3=Hdata(6); 
    Ht4=Hdata(7); 
    Ht5=Hdata(8);
    Ht6=Hdata(9); 
    R=str2num(get(Hdata(1),'string')); 
    X=str2num(get(Hdata(2),'string')); 
    Zo=str2num(get(Hdata(3),'string')); 
    %出错处理 
    if isempty(R)|isempty(X)|isempty(Zo) 
        set(Ht1,'string','illegal input!'); 
        set(Ht2,'string',''); set(Ht3,'string',''); 
        set(Ht4,'string',''); set(Ht5,'string',''); 
        set(Ht6,'string',''); 
    elseif R<0 
        set(Ht1,'string','illegal RESISTANCE!'); 
        set(Ht2,'string',''); set(Ht3,'string',''); 
        set(Ht4,'string',''); set(Ht5,'string',''); 
        set(Ht6,'string','');  
    elseif Zo<=0 
        set(Ht1,'string','illegal Zo!'); set(Ht2,'string',''); 
        set(Ht3,'string',''); set(Ht4,'string',''); 
        set(Ht5,'string',''); set(Ht6,'string',''); 
        %显示圆图匹配结果  
    else 
        [Ls11,Ls12,Ls21,Ls22]=doublefun(R,X,Zo); 
        [Gamma2,Lmin,Lmax]=circlefun(R,X,Zo); 
        hold on; 
        if imag(Ls11)==0 & imag(Ls12)==0 & imag(Ls21)==0 & imag(Ls22)==0 
            double_match1(Gamma2,R,X,Zo,Ls21,Ls22);  
        else 
            double_match2(Gamma2,R,X,Zo);  
        end 
        hold off; 
        rho=(1+abs(Gamma2))/(1-abs(Gamma2)); 
        set(Ht1,'string',strcat('Γ2=',num2str(Gamma2)),'fontname','Times New Roman','fontsize',8); 
        set(Ht2,'string',strcat('ρ=',num2str(rho)),'fontname','Times New Roman','fontsize',8,'horizontal','left'); 
        set(Ht3,'string',strcat('Lmin=',num2str(Lmin),'λ'),'fontname','Times New Roman','fontsize',8); 
        set(Ht4,'string',strcat('Lmax=',num2str(Lmax),'λ'),'fontname','Times New Roman','fontsize',8); 
        if imag(Ls11)==0 & imag(Ls12)==0 & imag(Ls21)==0 & imag(Ls22)==0 
            set(Ht5,'string',strcat('    在负载处并入长度为',num2str(Ls11),'λ 的短路支节,再在d=λ/ 8处并入长度为',num2str(Ls21),'λ 的短路支节就可实现匹配'),'fontname','TimesNewRoman','fontsize',8); 
            set(Ht6,'string',strcat('    或在负载处并入长度为',num2str(Ls12),'λ 的短路支节,再在d=λ/ 8处并入长度为',num2str(Ls22),'λ 的短路支节就可实现匹配'),'fontname','TimesNewRoman','fontsize',8);  
        else 
            set(Ht5,'string',strcat('     WARNING!等G圆与λ/8辅助圆无交点'),'fontname','Times New Roman','fontsize',10); 
            set(Ht6,'string',strcat('    双支节匹配出现盲区！'),'fontname','Times New Roman','fontsize',10);  
        end
    end
    
    
    
    
    
elseif strcmp(action,'plot__circle') 
    Hdata=get(gcf,'userdata'); 
    HR=Hdata(1); 
    HX=Hdata(2); 
    HZo=Hdata(3); 
    Ht1=Hdata(4); 
    Ht2=Hdata(5); 
    Ht3=Hdata(6); 
    Ht4=Hdata(7); 
    Ht5=Hdata(8); 
    Ht6=Hdata(9);
    R=str2num(get(Hdata(1),'string')); 
    X=str2num(get(Hdata(2),'string')); 
    Zo=str2num(get(Hdata(3),'string')); 
    %出错处理 
    if isempty(R)|isempty(X)|isempty(Zo) 
        set(Ht1,'string','无效输入'); 
        set(Ht2,'string',''); 
        set(Ht3,'string',''); 
        set(Ht4,'string',''); 
        set(Ht5,'string',''); 
        set(Ht6,'string',''); 
    elseif R<0 
        set(Ht1,'string','无效输入'); 
        set(Ht2,'string',''); 
        set(Ht3,'string',''); 
        set(Ht4,'string',''); 
        set(Ht5,'string',''); 
        set(Ht6,'string','');  
    elseif Zo<=0 
        set(Ht1,'string','无效输入'); 
        set(Ht2,'string',''); 
        set(Ht3,'string',''); 
        set(Ht4,'string',''); 
        set(Ht5,'string',''); 
        set(Ht6,'string',''); 
        %显示圆图结果  
    else 
        [Gamma2,Lmin,Lmax]=circle(R,X,Zo);  
    end 
%单支节并联匹配 
elseif strcmp(action,'plot_single_fun') 
    Hdata=get(gcf,'userdata'); 
    HR=Hdata(1); 
    HX=Hdata(2); 
    HZo=Hdata(3); 
    Ht1=Hdata(4); 
    Ht2=Hdata(5); 
    Ht3=Hdata(6); 
    Ht4=Hdata(7); 
    Ht5=Hdata(8); 
    Ht6=Hdata(9); 
    R=str2num(get(Hdata(1),'string')); 
    X=str2num(get(Hdata(2),'string')); 
    Zo=str2num(get(Hdata(3),'string')); 
 %出错处理 
    if isempty(R)|isempty(X)|isempty(Zo)
        set(Ht1,'string','illegal input!'); 
        set(Ht2,'string',''); 
        set(Ht3,'string',''); 
        set(Ht4,'string',''); 
        set(Ht5,'string','');   
        set(Ht6,'string',''); 
    elseif R<0
        set(Ht1,'string','illegal RESISTANCE!');
        set(Ht2,'string',''); 
        set(Ht3,'string',''); 
        set(Ht4,'string',''); 
        set(Ht5,'string',''); 
        set(Ht6,'string',''); 
    elseif Zo<=0 
        set(Ht1,'string','illegal Zo!'); 
        set(Ht2,'string',''); 
        set(Ht3,'string',''); 
        set(Ht4,'string',''); 
        set(Ht5,'string',''); 
        set(Ht6,'string',''); 
        %显示圆图匹配结果  
    else
        [Lo1,Lo2,Ls1,Ls2,d1,d2]=singlefun(R,X,Zo); 
        [Gamma2,Lmin,Lmax]=circlefun(R,X,Zo); 
        hold on;
        single_match(Gamma2,R,X,Zo,d1); 
        hold off; 
        rho=(1+abs(Gamma2))/(1-abs(Gamma2));  
        if R==Zo 
            set(Ht5,'string',strcat('在d1 = ',num2str(d1),'λ处并接入Lo=',num2str(Lo1),'λ 的短路支节可实现匹配'),'fontname','Times New Roman','fontsize',8); 
            set(Ht6,'string',strcat('或在d2 = ',num2str(d2),'λ处并接入Ls=',num2str(Ls1),'λ 的开路支节实现匹配'),'fontname','Times New Roman','fontsize',8);  
        else 
            set(Ht5,'string',strcat('在d1 = ',num2str(d1),'λ处并接入长度为Ls=',num2str(Ls1),'λ 的短路支节','或Lo=',num2str(Lo1),'λ 的开路支节可实现匹配'),'fontname','TimesNewRoman','fontsize',8); 
            set(Ht6,'string',strcat('或在d2 = ',num2str(d2),'λ处并接入长度为Ls=',num2str(Ls2),'λ 的短路支节','或Lo=',num2str(Lo2),'λ 的开路支节可实现匹配'),'fontname','TimesNewRoman','fontsize',8);  
        end
    end
    %双支节并联匹配  
elseif strcmp(action,'plot_double_fun')
    Hdata=get(gcf,'userdata'); 
    HR=Hdata(1); 
    HX=Hdata(2); 
    HZo=Hdata(3); 
    Ht1=Hdata(4); 
    Ht2=Hdata(5); 
    Ht3=Hdata(6); 
    Ht4=Hdata(7); 
    Ht5=Hdata(8);
    Ht6=Hdata(9); 
    R=str2num(get(Hdata(1),'string')); 
    X=str2num(get(Hdata(2),'string')); 
    Zo=str2num(get(Hdata(3),'string')); 
    %出错处理 
    if isempty(R)|isempty(X)|isempty(Zo) 
        set(Ht1,'string','illegal input!'); 
        set(Ht2,'string',''); set(Ht3,'string',''); 
        set(Ht4,'string',''); set(Ht5,'string',''); 
        set(Ht6,'string',''); 
    elseif R<0 
        set(Ht1,'string','illegal RESISTANCE!'); 
        set(Ht2,'string',''); set(Ht3,'string',''); 
        set(Ht4,'string',''); set(Ht5,'string',''); 
        set(Ht6,'string','');  
    elseif Zo<=0 
        set(Ht1,'string','illegal Zo!'); set(Ht2,'string',''); 
        set(Ht3,'string',''); set(Ht4,'string',''); 
        set(Ht5,'string',''); set(Ht6,'string',''); 
        %显示圆图匹配结果  
    else 
        [Ls11,Ls12,Ls21,Ls22]=doublefun(R,X,Zo); 
        [Gamma2,Lmin,Lmax]=circlefun(R,X,Zo); 
        hold on; 
        if imag(Ls11)==0 & imag(Ls12)==0 & imag(Ls21)==0 & imag(Ls22)==0 
            double_match1(Gamma2,R,X,Zo,Ls21,Ls22);  
        else 
            double_match2(Gamma2,R,X,Zo);  
        end 
        hold off; 
        rho=(1+abs(Gamma2))/(1-abs(Gamma2)); 
        set(Ht1,'string',strcat('Γ2=',num2str(Gamma2)),'fontname','Times New Roman','fontsize',8); 
        set(Ht2,'string',strcat('ρ=',num2str(rho)),'fontname','Times New Roman','fontsize',8,'horizontal','left'); 
        set(Ht3,'string',strcat('Lmin=',num2str(Lmin),'λ'),'fontname','Times New Roman','fontsize',8); 
        set(Ht4,'string',strcat('Lmax=',num2str(Lmax),'λ'),'fontname','Times New Roman','fontsize',8); 
        if imag(Ls11)==0 & imag(Ls12)==0 & imag(Ls21)==0 & imag(Ls22)==0 
            set(Ht5,'string',strcat('    在负载处并入长度为',num2str(Ls11),'λ 的短路支节,再在d=λ/ 8处并入长度为',num2str(Ls21),'λ 的短路支节就可实现匹配'),'fontname','TimesNewRoman','fontsize',8); 
            set(Ht6,'string',strcat('    或在负载处并入长度为',num2str(Ls12),'λ 的短路支节,再在d=λ/ 8处并入长度为',num2str(Ls22),'λ 的短路支节就可实现匹配'),'fontname','TimesNewRoman','fontsize',8);  
        else 
            set(Ht5,'string',strcat('     WARNING!等G圆与λ/8辅助圆无交点'),'fontname','Times New Roman','fontsize',10); 
            set(Ht6,'string',strcat('    双支节匹配出现盲区！'),'fontname','Times New Roman','fontsize',10);  
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%画阻抗圆图的函数 
function[Gamma2,Lmin,Lmax]=circle(R,X,Zo) 
%归一化阻抗 
r=R/Zo; x=X/Zo; 
%画出单位圆和标出电刻度 
t=0:0.0001:2*pi; 
plot(cos(t),sin(t),'--k'); 
text(-1.2,0,'0','fontname','arial','color','b','fonta','italic'); 
text(-0.1,1.03,'0.125','fontname','arial','color','b','fonta','italic'); 
text(1.03,0,'0.25','fontname','arial','color','b','fonta','italic'); 
text(-0.1,-1.18,'0.375','fontname','arial','color','b','fonta','italic'); 
hold on; 
plot([-1,1],[0,0],'k'); 
hold on; 
plot([0,0],[-1,1],'k'); 
hold on; 
axis('equal',[-1,1,-1,1]); 
%画出等R圆 
if r==inf 
    plot(1,0,'rp'); 
    axis('equal',[-1,1,-1,1]); 
else 
    a=r/(1+r); 
    r1=1/(1+r); 
    plot((r1*cos(t)+a),(r1*sin(t)),'b'); 
    axis('equal',[-1,1,-1,1]); 
    hold on; 
end
%画出等X圆 
if x==inf 
    plot(1,0,'rp'); 
    axis('equal',[-1,1,-1,1]); 
elseif x==0 
    plot([-1,1],[0,0],'r'); 
    axis('equal',[-1,1,-1,1]); 
else 
    b=1/x; r2=1/x; 
    plot((r2*cos(t)+1),(r2*sin(t)+b),'b');
    axis('equal',[-1,1,-1,1]); 
    hold on; 
end; 
%画出等反射圆 
z=r+j*x; 
Gamma2=(z-1)/(z+1); 
Mod=abs(Gamma2); 
Phi=angle(Gamma2); 
plot(Mod*cos(t),Mod*sin(t),'k'); 
hold on; 
axis('equal',[-1,1,-1,1]); 
hold on; 
%确定传播状态 
plot(Mod*cos(Phi),Mod*sin(Phi),'gp'); 
hold on; 
Re=[0,cos(Phi)]; 
Im=[0,sin(Phi)]; 
polyfit(Re,Im,1); 
plot(Re,Im,'b'); 
hold on; 
if X<0 
    if(Phi>=0) 
        Lmin=Phi/(4*pi); 
        Lmax=0.25+Lmin;  
    else 
        Lmin=(pi+Phi)/(4*pi); 
        Lmax=0.25+Lmin;  
    end
else
    if(Phi>=0) 
        Lmax=Phi/(4*pi); 
        Lmin=0.25+Lmax;  
    else 
        Lmax=(pi+Phi)/(4*pi); 
        Lmin=0.25+Lmax;  
    end 
    hold off; 
end 
title('SMITH阻抗圆图');    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%画导纳圆图的函数 
function[Gamma2,Lmin,Lmax]=circlefun(R,X,Zo) 
%归一化阻抗和确定传播状态 
r=R/Zo; x=X/Zo; z=r+i*x; y=1/z; 
g=real(y); b=imag(y); 
Gamma2=(z-1)/(z+1); Mod=abs(Gamma2); Phi=angle(Gamma2); 
Lambda=(pi-Phi)/(4*pi); Alpha=(y-1)/(y+1); 
plot(real(Alpha),imag(Alpha),'gp'); 
hold on; 
plot(real(Gamma2),imag(Gamma2),'gp'); 
hold on; 
aa=[real(Alpha),real(Gamma2)]; 
bb=[imag(Alpha),imag(Gamma2)]; 
polyfit(aa,bb,1); plot(aa,bb,'g'); 
hold on; 
if X<0 
    if(Phi>=0) 
        Lmin=Phi/(4*pi); Lmax=0.25+Lmin;  
    else 
        Lmin=(pi+Phi)/(4*pi); Lmax=0.25+Lmin;  
    end
else
    if(Phi>=0) 
        Lmax=Phi/(4*pi); Lmin=0.25+Lmax;  
    else 
        Lmax=(pi+Phi)/(4*pi); Lmin=0.25+Lmax;  
    end
end
%画出单位圆和标出电刻度 
t=0:0.0001:2*pi; 
plot(cos(t),sin(t),'--k'); 
text(-1.2,0,'0','fontname','arial','color','b','fonta','italic'); 
text(-0.1,1.03,'0.125','fontname','arial','color','b','fonta','italic'); 
text(1.03,0,'0.25','fontname','arial','color','b','fonta','italic'); 
text(-0.1,-1.18,'0.375','fontname','arial','color','b','fonta','italic'); 
hold on; 
plot([-1,1],[0,0],'k'); hold on; 
plot([0,0],[-1,1],'k'); hold on; 
axis('equal',[-1,1,-1,1]); 
%画出等G圆 
if g==inf 
    plot(1,0,'rp'); 
    axis('equal',[-1,1,-1,1]); 
else 
    a=g/(1+g); 
    g1=1/(1+g); 
    plot((g1*cos(t)+a),(g1*sin(t)),'b'); 
    axis('equal',[-1,1,-1,1]); hold on; 
end
%画出等B圆 
if b==inf 
    plot(1,0,'rp'); 
    axis('equal',[-1,1,-1,1]); 
elseif b==0 
    plot([-1,1],[0,0],'r'); 
    axis('equal',[-1,1,-1,1]); 
else 
    b1=1/b; r2=1/b; 
    plot((r2*cos(t)+1),(r2*sin(t)+b1),'b'); axis('equal',[-1,1,-1,1]); hold on; 
end
%画出等反射圆和匹配圆 
y=g+j*b; 
gamma=(y-1)/(y+1); Mod=abs(gamma); Phi=angle(gamma); 
plot(Mod*cos(t),Mod*sin(t),'k'); hold on; 
axis('equal',[-1,1,-1,1]); 
plot(0.5*(cos(t)+1),(0.5*sin(t)),'c'); hold off; 
title('SMITH导纳圆图'); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%单支节并联匹配函数 
function[Lo1,Lo2,Ls1,Ls2,d1,d2]=singlefun(R,X,Zo) 
%计算并联支节的位置和短路及开路支节的长度 
r=R/Zo; x=X/Zo; 
if R==Zo 
    m=-x/2; 
    B=(R^2*m-(Zo-X*m)*(Zo+X*m))/(Zo*(R^2+(Zo+X*m)^2));  
    if m>=0 
        d1=atan(m)/(2*pi);
        if d1>=0.5 
            d1=d1-0.5;  
        elseif d1<0 d1=d1+0.5;  
        else 
            d1=d1; 
        end 
        d2=atan(m)/(2*pi);  
        if d2>=0.5 
            d2=d2-0.5;  
        elseif d2<0 
            d2=d2+0.5;  
        else 
            d2=d2;  
        end 
        Lo1=(-atan(B*Zo))/(2*pi);  
        if Lo1>=0 
            Lo1=Lo1; Lo2=Lo1;  
        else 
            Lo1=0.5+Lo1; Lo2=Lo1;  
        end 
        Ls1=(atan(1/(B*Zo)))/(2*pi); 
        if Ls1>=0 
            Ls1=Ls1; Ls2=Ls1;  
        else 
            Ls1=0.5+Ls1; Ls2=Ls1;  
        end
    else
        d1=(atan(m)+pi)/(2*pi);  
        if d1>=0.5 
            d1=d1-0.5;  
        elseif d1<0 
            d1=d1+0.5;  
        else 
            d1=d1;  
        end 
        d2=(atan(m)+pi)/(2*pi);  
        if d2>=0.5 
            d2=d2-0.5;  
        elseif d2<0 
            d2=d2+0.5;  
        else 
            d2=d2;  
        end 
        Lo1=(-atan(B*Zo))/(2*pi);  
        if Lo1>=0 Lo1=Lo1; 
            Lo2=Lo1;  
        else 
            Lo1=0.5+Lo1; Lo2=Lo1;  
        end 
        Ls1=(atan(1/(B*Zo)))/(2*pi);  
        if Ls1>=0 
            Ls1=Ls1; Ls2=Ls1;  
        else 
            Ls1=0.5+Ls1; Ls2=Ls1;  
        end
    end
else
    m1=(X+sqrt(R*((Zo-R)^2+X^2)/Zo))/(R-Zo); 
    m2=(X-sqrt(R*((Zo-R)^2+X^2)/Zo))/(R-Zo); 
    B1=(R^2*m1-(Zo-X*m1)*(X+Zo*m1))/(Zo*(R^2+(X+Zo*m1)^2));
    B2=(R^2*m2-(Zo-X*m2)*(X+Zo*m2))/(Zo*(R^2+(X+Zo*m2)^2));
    Lo1=(-atan(B1*Zo))/(2*pi);  
    if Lo1>=0 
        Lo1=Lo1;  
    else 
        Lo1=0.5+Lo1;  
    end 
    Lo2=(-atan(B2*Zo))/(2*pi);  
    if Lo2>=0 
        Lo2=Lo2;  
    else 
    Lo2=0.5+Lo2;  
    end 
    Ls1=(atan(1/(B1*Zo)))/(2*pi);  
    if Ls1>=0 
        Ls1=Ls1;  
    else 
        Ls1=0.5+Ls1;  
    end 
    Ls2=(atan(1/(B2*Zo)))/(2*pi);  
    if Ls2>=0 
        Ls2=Ls2;  
    else 
        Ls2=0.5+Ls2;  
    end 
    if m1>=0 
        d1=atan(m1)/(2*pi);  
        if d1>=0.5 
            d1=d1-0.5;  
        elseif d1<0 
            d1=d1+0.5;  
        else 
            d1=d1;  
        end 
        d2=(atan(m2)+pi)/(2*pi);  
        if d2>=0.5 
            d2=d2-0.5;  
        elseif d2<0 
            d2=d2+0.5;  
        else 
            d2=d2;  
        end
    else
        d1=(atan(m1)+pi)/(2*pi);  
        if d1>=0.5 
            d1=d1-0.5;  
        elseif d1<0 
            d1=d1+0.5;  
        else 
            d1=d1;  
        end 
        d2=atan(m2)/(2*pi);  
        if d2>=0.5 
            d2=d2-0.5;  
        elseif d2<0 
            d2=d2+0.5;  
        else 
            d2=d2;  
        end
    end
end
hold off;   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%双支节并联匹配函数(第一支节在负载处) 
function[Ls11,Ls12,Ls21,Ls22]=doublefun(R,X,Zo) 
Z=R+i*X; Y=1/Z; Yo=1/Zo; G=real(Y); B=imag(Y); m=1; 
%两支节相距λ/8 
m1=(1+m^2)*G*Yo-G^2*m^2; m2=abs(1+m^2)*G*Yo-G^2*m^2; B11=-B+(Yo+sqrt(m1))/m; 
B21=(Yo*sqrt(m2)+G*Yo)/(G*m); B12=-B+(Yo-sqrt(m1))/m; 
B22=(-Yo*sqrt(m2)+G*Yo)/(G*m); Ls=-(atan(Yo/B11))/(2*pi); 
if Ls>=0 
    Ls11=Ls; 
else 
    Ls11=0.5+Ls; 
end 
Ls=-(atan(Yo/B21))/(2*pi); 
if Ls>=0 
    Ls21=Ls; 
else 
    Ls21=0.5+Ls; 
end 
Ls=-(atan(Yo/B12))/(2*pi); 
if Ls>=0 
    Ls12=Ls; 
else 
    Ls12=0.5+Ls; 
end 
Ls=-(atan(Yo/B22))/(2*pi); 
if Ls>=0 
    Ls22=Ls; 
else 
    Ls22=0.5+Ls; 
end 
hold off;   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%单支节并联圆图 
function[]=single_match(Gamma2,R,X,Zo,d1) 
%归一化及计参数 
r=R/Zo; x=X/Zo; z=r+i*x; y=1/z; 
Alpha=atan2(imag(Gamma2),real(Gamma2)); 
alpha1=(y-1)/(y+1); 
%计算匹配点位置 
if R==Zo 
    plot(real(Gamma2),imag(Gamma2),'rp'); 
    plot(real(Gamma2),-imag(Gamma2),'rp'); 
    m=[0,real(Gamma2)]; 
    Re1=[0,cos(Alpha)]; 
    Im1=[0,sin(Alpha)]; 
    Im2=[0,-sin(Alpha)]; 
    plot(Re1,Im1,'b'); 
    plot(Re1,Im2,'b'); 
    hold off; 
else 
    angle1=abs(atan2(imag(Gamma2),real(Gamma2))); 
    angle2=2*pi*(d1/0.5)-angle1;  
    if X>=0 
        if angle2<0 
            angle2=2*pi+angle2;  
            plot(-abs(Gamma2)*cos(angle2),abs(Gamma2)*sin(angle2),'rp');  
            plot(-abs(Gamma2)*cos(angle2),-abs(Gamma2)*sin(angle2),'rp');
            Re3=[0,cos(angle2)]; 
            Re4=[0,cos(angle2)]; 
            Im3=[0,sin(angle2)]; 
            Im4=[0,-sin(angle2)]; 
            plot(-Re3,Im3,'b'); 
            plot(-Re4,Im4,'b');
            hold off;  
        else 
            angle2=angle2;  
            plot(-abs(Gamma2)*cos(angle2),abs(Gamma2)*sin(angle2),'rp'); 
            plot(-abs(Gamma2)*cos(angle2),-abs(Gamma2)*sin(angle2),'rp'); 
            Re3=[0,cos(angle2)]; 
            Re4=[0,cos(angle2)]; Im3=[0,sin(angle2)]; 
            Im4=[0,-sin(angle2)]; plot(-Re3,Im3,'b'); 
            plot(-Re4,Im4,'b'); 
            holdoff;  
        end
    else
        angle1=abs(atan2(imag(Gamma2),real(Gamma2))); angle2=2*pi*(d1/0.5)+angle1-2*pi;  
        if angle2<0 
            angle2=2*pi+angle2;  
            plot(-abs(Gamma2)*cos(angle2),abs(Gamma2)*sin(angle2),'rp');  
            plot(-abs(Gamma2)*cos(angle2),-abs(Gamma2)*sin(angle2),'rp'); Re3=[0,cos(angle2)]; Re4=[0,cos(angle2)]; Im3=[0,sin(angle2)]; Im4=[0,-sin(angle2)]; plot(-Re3,Im3,'b'); plot(-Re4,Im4,'b'); hold off;  
        else 
            angle2=angle2;  
            plot(-abs(Gamma2)*cos(angle2),abs(Gamma2)*sin(angle2),'rp');  
            plot(-abs(Gamma2)*cos(angle2),-abs(Gamma2)*sin(angle2),'rp'); Re3=[0,cos(angle2)]; Re4=[0,cos(angle2)]; Im3=[0,sin(angle2)]; Im4=[0,-sin(angle2)]; plot(-Re3,Im3,'b'); plot(-Re4,Im4,'b'); hold off;  
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%双支节并联圆图(无盲区) 
function[]=double_match1(Gamma2,R,X,Zo,Ls21,Ls22) 
t=0:0.0001:2*pi; 
plot(0.5*(cos(t)),(0.5*sin(t)+0.5),'c'); hold on; r=R/Zo; x=X/Zo; z=r+i*x; y=1/z; 
g=real(y); b=imag(y); 
%计算并画出第二支节的匹配点位置 
x1=-tan(2*pi*Ls21); x2=-tan(2*pi*Ls22); y1=1+i*(1/x1); y2=1+i*(1/x2); 
gamma1=(y1-1)/(y1+1); gamma2=(y2-1)/(y2+1); aa1=real(gamma1); bb1=-imag(gamma1); aa2=real(gamma2); bb2=-imag(gamma2); plot(aa1,bb1,'rp'); plot(aa2,bb2,'rp'); alpha1=atan2(bb1,aa1); alpha2=atan2(bb2,aa2); Re1=[0,cos(alpha1)]; Re2=[0,cos(alpha2)]; Im1=[0,sin(alpha1)]; Im2=[0,sin(alpha2)]; plot(Re1,Im1,'r'); plot(Re2,Im2,'r'); 
%计算并画出第一支节的匹配点位置 
plot(abs(gamma1)*cos(alpha1+pi/2),abs(gamma1)*sin(alpha1+pi/2),'bp'); 
plot(abs(gamma2)*cos(alpha2+pi/2),abs(gamma2)*sin(alpha2+pi/2),'bp'); 
Re3=[0,cos(alpha1+pi/2)]; Re4=[0,cos(alpha2+pi/2)]; Im3=[0,sin(alpha1+pi/2)]; Im4=[0,sin(alpha2+pi/2)]; plot(Re3,Im3,'b'); 
plot(Re4,Im4,'b'); hold off; 
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%双支节并联圆图(有盲区) 
function[]=double_match2(Gamma2,R,X,Zo) 
t=0:0.0001:2*pi; 
plot(0.5*(cos(t)),(0.5*sin(t)+0.5),'c'); hold on; 
[Gamma2,Lmin,Lmax]=circlefun(R,X,Zo); 
axis('equal',[-1,1,-1,1]); 
hold off;


