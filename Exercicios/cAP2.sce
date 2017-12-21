clc; clear; resethistory();

//format("e",8);
deff('y0=at(vecI, vecK)','y0=[vecI(1)*vecK(1) vecI(2)*vecK(2) vecI(3)*vecK(3)]');

A=6; B=4; C=4; D=6; E=9; F=3;

//A=8; B=5; C=0; D=4; E=5; F=3;

L = A+B+C+D+E+F; //disp(L); //32 

P1w = [A+10, B+5, 0]; //disp(P1w);
P2w = P1w+[L, 0, 0]; //disp(P2w);
P3w = P1w+[L/2., L*sqrt(3.)/2., 0]; //disp(P3w);
P4w = P1w+[L/2., L*sqrt(3.)/6., L*sqrt(6.)/6.]; //disp(P4w);

Pow = [A-5,B+L,L*sqrt(6.)/6.]; //disp(Pow);
LAt = P4w-[0,0,L*sqrt(6.)/6.]; //disp(LAt);

// QUESTAO 1
// 1.1
//disp('K-zao')
K = Pow-LAt; //disp(K);
//disp('k')
k = K/norm(K); //disp(k);

Avup = P4w; //disp(Avup);
//disp('Vup')
Vup = Avup-Pow; //disp(Vup);
I = cross(Vup,K); //disp(I);
//disp('i')
i = I/norm(I); //disp(i);
//disp('j')
j = cross(k,i); //disp(j);

// 1.2
//disp('Mwc')
Mwc = [i(1), i(2), i(3), -i*Pow';
       j(1), j(2), j(3), -j*Pow';
       k(1), k(2), k(3), -k*Pow';
         0.,   0.,   0.,      1.]; //disp(Mwc);

// 1.3
//disp('Pc_s')
P1c = Mwc * [P1w(1), P1w(2), P1w(3), 1.]'; //disp(P1c');
P2c = Mwc * [P2w(1), P2w(2), P2w(3), 1.]'; //disp(P2c');
P3c = Mwc * [P3w(1), P3w(2), P3w(3), 1.]'; //disp(P3c');
P4c = Mwc * [P4w(1), P4w(2), P4w(3), 1.]'; //disp(P4c');

// QUESTAO 2

//1)
KA = [A/50., B/50., C/50.]; //disp(KA);

//2)
KD = 3.*KA; //disp(KD);
KS = KD; //disp(KS);

//3)
m=1.;

IA = [0.4, 0.4, 0.4];
IF = [0.7, 0.7, 0.7];

pontoFw = [A+10, B+L, 2.0*L, 1]; //disp(pontoFw);

pontoFc = Mwc * pontoFw'; //disp(pontoFc');

pontoPw = P4w - [0,0,L*sqrt(6.)/12.]; //disp(pontoPw); // ok

pontoPc = Mwc * [pontoPw(1), pontoPw(2), pontoPw(3), 1]'; //disp(pontoPc');

F1 = cross((P1c-P3c)(1:3),(P4c-P3c)(1:3));
n1 = F1/norm(F1);

F2 = cross((P4c-P2c)(1:3),(P1c-P2c)(1:3));
n2 = F2/norm(F2);

F3 = cross((P3c-P2c)(1:3),(P4c-P2c)(1:3));
n3 = F3/norm(F3);

F4 = cross((P3c-P1c)(1:3),(P2c-P1c)(1:3));
n4 = F4/norm(F4);

p = pontoPc / norm(pontoPc); // ok

disp('backface cull.')
disp(p(1:3)'*n1);
disp(p(1:3)'*n2);
disp(p(1:3)'*n3);
disp(p(1:3)'*n4);

////////////////////////////////////////////////////////////////////////////////
disp('tere-t-t')
t = ([n1(1),n1(2),n1(3),0] * P1c) / ([n1(1),n1(2),n1(3),0] * pontoPc); //disp(t)

disp('Pin')
Pin = t * pontoPc; //disp(Pin);

// verificacao
w1 = P1c-Pin;
w2 = P4c-Pin;
w3 = P3c-Pin;

//disp('emes')
m1 = cross(w1(1:3),w2(1:3)); //disp(m1');
m2 = cross(w2(1:3),w3(1:3)); //disp(m2');
m3 = cross(w3(1:3),w1(1:3)); //disp(m3');

disp('produtos')
disp(n1'*m1)
disp(n1'*m2)
disp(n1'*m3)

vetorV = [p(1),p(2),p(3),0];
vetorN = [n1(1),n1(2),n1(3),0];
vetorL = (pontoFc-Pin)/norm(pontoFc-Pin);

vetorR = 2*(vetorL*vetorN)*vetorN'-vetorL
//vetorRfe = 2*(vetorN*vetorL')*(vetorN-vetorL);

// I = Ia+Id+Is
Ia = at(KA,IA);
Id = (vetorN*vetorL) * at(KD,IF);
Is = ((vetorV*vetorR)^m) * at(KS,IF);

//disp('I final:')
I_final = Ia+Id+Is; //disp(I_final);
