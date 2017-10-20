clc; clear;
//format("e",8);
deff('y0=deg2rad(degree)','y0=((degree*%pi)/180.)');
deff('y0=rad2deg(radian)','y0=((radian*180.)/%pi)');

/** transformacoes **/

/** rotacao em torno do eixo-x **/
deff('y1=Rx(thetax)','y1=[1. 0. 0. 0.; 0. cos(deg2rad(thetax)) -sin(deg2rad(thetax)) 0.; 0. sin(deg2rad(thetax)) cos(deg2rad(thetax)) 0.; 0. 0. 0. 1.]');
/** rotacao em torno do eixo-y **/
deff('y2=Ry(thetay)','y2=[cos(deg2rad(thetay)) 0. sin(deg2rad(thetay)) 0.; 0. 1. 0. 0.; -sin(deg2rad(thetay)) 0. cos(deg2rad(thetay)) 0.; 0. 0. 0. 1.]');
/** rotacao em torno do eixo-z **/
deff('y3=Rz(thetaz)','y3=[cos(deg2rad(thetaz)) -sin(deg2rad(thetaz)) 0. 0.; sin(deg2rad(thetaz)) cos(deg2rad(thetaz)) 0. 0.; 0. 0. 1. 0.; 0. 0. 0. 1.]');

/** escala **/ deff('y4=S(sx,sy,sz)','y4=[sx 0. 0. 0.; 0. sy 0. 0.; 0. 0. sz 0.; 0. 0. 0. 1.]');

/** translacao **/ deff('y5=T(tx,ty,tz)','y5=[1. 0. 0. tx; 0. 1. 0. ty; 0. 0. 1. tz; 0. 0. 0. 1.]');

/** espelho/reflexao **/
/** plano xy **/ deff('y6=Exy','y6=[1. 0. 0. 0.; 0. 1. 0. 0.; 0. 0. -1. 0.; 0. 0. 0. 1.]');
/** plano yz **/ deff('y7=Eyz','y7=[-1. 0. 0. 0.; 0. 1. 0. 0.; 0. 0. 1. 0.; 0. 0. 0. 1.]');
/** plano xz **/ deff('y8=Exz','y8=[1. 0. 0. 0.; 0. -1. 0. 0.; 0. 0. 1. 0.; 0. 0. 0. 1.]');
