getd(pwd());

A = 6; B = 4; C = 4; D = 6; E = 9; F = 3;

disp('  P3          P4          P2          P1');
// pontos originais
/** x **/ P3 = [3.+B; 0.; 0.; 1.];    
/** y **/ P4 = [0.; 1.+C; 0.; 1.];
/** z **/ P2 = [0.; 0.; 2.+A; 1.];
/** O **/ P1 = [0.; 0.; 0.; 1.];

//** Questao.1 **//

a = sqrt(100/2.);
// fatores de escala para questao 1
sx = a / P3(1); sy = a / P4(2); sz = a / P2(3);

// novas posicoes dos pontos
passo0 = S(sx,sy,sz) * [P3, P4, P2, P1];

//** Questao.2 **//

// translacao: levar o ponto p3 para origem: [1/5]
passo1 = T(-a,0.,0.) * (S(sx,sy,sz) * [P3, P4, P2, P1]);// p1;

// rotacao: 135deg em torno do eixo-y: [2/5]
theta3 = 135.; 
passo2 = Ry(theta3) * (T(-a,0.,0.) * (S(sx,sy,sz) * [P3, P4, P2, P1]));// p2;

// rotacao em torno do eixo-x: [3/5]
h = sqrt(sqrt(50.)**2.-(10/2.)**2.)
theta4_ = (atan(sqrt(50.)/h) * 180. / %pi); // 54.73561deg
theta4 = 90 - theta4_; // 35.26439deg
passo3 = Rx(-theta4) * (Ry(theta3) * (T(-a,0.,0.) * (S(sx,sy,sz) * [P3, P4, P2, P1])));// p3;

// rotacao em torno do eixo-z: [4/5]
p3bar = [30. * (1.+D); 10. * (2.+F); 0.; 1.];
theta5 = atan(p3bar(2)/p3bar(1)) * 180. / %pi; // 13.392498deg
passo4 = Rz(theta5) * (Rx(-theta4) * (Ry(theta3) * (T(-a,0.,0.) * (S(sx,sy,sz) * [P3, P4, P2, P1]))));// p4;

// translacao: levar ponto p3 da origem para o espaco: [5/5]
passo5 = T(p3bar(1),p3bar(2),p3bar(3)) * (Rz(theta5) * (Rx(-theta4) * (Ry(theta3) * (T(-a,0.,0.) * (S(sx,sy,sz) * [P3, P4, P2, P1])))));// p5;

//disp('  P3     P4          P2          P1');
//disp(passo5);

// processo direto:
T0 = T(-a,0.,0.);
Ry0 = Ry(theta3);
Rx0 = Rx(-theta4);
Rz0 = Rz(theta5);
T1 = T(p3bar(1),p3bar(2),p3bar(3));
coordMonumento = T1 * (Rz0 * (Rx0 * (Ry0 * (T0 * passo0))));

/** Questao.3 **/

//disp('  P3          P4          P2          P1');
// translacao do ponto p2 para origem
Tp2_o = T(-passo5(1,3),-passo5(2,3),-passo5(3,3))

// translacao da origem para o ponto p2
To_p2 = T(passo5(1,3),passo5(2,3),passo5(3,3))

p2to0xyz = Tp2_o * passo5;

//disp(p2to0xyz)

p1 = p2to0xyz(1:3,4)
p2 = p2to0xyz(1:3,3)
p3 = p2to0xyz(1:3,1)
p4 = p2to0xyz(1:3,2)

p1p2 = p2-p1
p1p4 = p4-p1

A = p1p2
B = p1p4

ax = A(1); ay = A(2); az = A(3);
bx = B(1); by = B(2); bz = B(3);

Nx = ay*bz-az*by
Ny = az*bx-ax*bz
Nz = ax*by-ay*bx

Novo = [Nx;Ny;Nz]

N = cross(p1p2, p1p4)

n = [N / norm(N); 0]

E = eye(4,4) - 2*(n*n')

p_ = (To_p2 * (E * (Tp2_o * passo5)))
//disp('  P3          P4          P2          P1');
//disp(p_)
