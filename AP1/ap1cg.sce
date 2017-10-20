getd(pwd());

/* Computação Grafica I - AP1 - 2017.2 */

// Dados
A = 6; B = 4; C = 4; D = 6; E = 9; F = 3;

disp('  P3          P4          P2          P1');
/* Um amigo lhe enviou por e-mail um tetraedro (objeto 3D com 4 vértices e  quatro faces triangulares) cujos vértices em coordenadas cartesianas no R3 são: P1 = (0, 0, 0), P2 = (0, 0, 2+A), P3 = (3+B, 0, 0), P4 = (0, 1+C, 0). */

/** x **/ P3 = [3.+B;   0.;   0.; 1.];    
/** y **/ P4 = [  0.; 1.+C;   0.; 1.];
/** z **/ P2 = [  0.;   0.; 2.+A; 1.];
/** O **/ P1 = [  0.;   0.;   0.; 1.];

/* Questao.1 
Aplique uma matriz de escala sobre os vertices do tetraedro, de modo que a face P2’-P3’-P4’ seja um triangulo equilatero de lado igual a 10m. */

a = sqrt(100/2.);

// fatores de escala
sx = a / P3(1); sy = a / P4(2); sz = a / P2(3);

// novas posicoes dos pontos
passo0_P1 = S(sx,sy,sz) * P1;
passo0_P2 = S(sx,sy,sz) * P2;
passo0_P3 = S(sx,sy,sz) * P3;
passo0_P4 = S(sx,sy,sz) * P4;

passo0 = [passo0_P3 passo0_P4 passo0_P2 passo0_P1]; 

/* Questao.2
Aplique uma sequencia de transformacoes sobre o tetraedro resultante da questao anterior de modo que ele se transforme no monumento ilustrado na Figura 1. Na figura, os eixos de coordenadas do mundo obedecem a regra da mão direita, o vértice P3bar tem coordenadas (30(1 + D), 10(2 + F), 0), a aresta P3barP2bar está alinhada com o segmento de reta pontilhado e, obviamente, o vértice P1bar tem coordenada z positiva. */

// translacao: levar o ponto p3 para origem: [1/5]
passo1_P1 = T(-a,0.,0.) * passo0_P1;
passo1_P2 = T(-a,0.,0.) * passo0_P2;
passo1_P3 = T(-a,0.,0.) * passo0_P3;
passo1_P4 = T(-a,0.,0.) * passo0_P4;

// rotacao: 135deg em torno do eixo-y: [2/5]
theta2 = 135.; 

passo2_P1 = Ry(theta2) * passo1_P1;
passo2_P2 = Ry(theta2) * passo1_P2;
passo2_P3 = Ry(theta2) * passo1_P3;
passo2_P4 = Ry(theta2) * passo1_P4;

// rotacao em torno do eixo-x: [3/5]
h = sqrt(sqrt(50.)**2.-(10/2.)**2.);
theta3_ = rad2deg(atan(sqrt(50.)/h)); //54.73561deg
theta3 = 90 - theta3_; //35.26439deg

passo3_P1 = Rx(-theta3) * passo2_P1;
passo3_P2 = Rx(-theta3) * passo2_P2;
passo3_P3 = Rx(-theta3) * passo2_P3;
passo3_P4 = Rx(-theta3) * passo2_P4;

// rotacao em torno do eixo-z: [4/5]
p3bar = [30. * (1. + D); 10. * (2. + F); 0.; 1.];
theta4 = rad2deg(atan(p3bar(2) / p3bar(1))); //13.392498deg

passo4_P1 = Rz(theta4) * passo3_P1;
passo4_P2 = Rz(theta4) * passo3_P2;
passo4_P3 = Rz(theta4) * passo3_P3;
passo4_P4 = Rz(theta4) * passo3_P4;

// translacao: levar ponto p3 da origem para o espaco: [5/5]

passo5_P1 = T(p3bar(1), p3bar(2), p3bar(3)) * passo4_P1;
passo5_P2 = T(p3bar(1), p3bar(2), p3bar(3)) * passo4_P2;
passo5_P3 = T(p3bar(1), p3bar(2), p3bar(3)) * passo4_P3;
passo5_P4 = T(p3bar(1), p3bar(2), p3bar(3)) * passo4_P4;

// processo direto:
T0 = T(-a, 0., 0.);
Ry0 = Ry(theta2);
Rx0 = Rx(-theta3);
Rz0 = Rz(theta4);
T1 = T(p3bar(1), p3bar(2), p3bar(3));

coordMonumento = T1 * (Rz0 * (Rx0 * (Ry0 * (T0 * passo0))));

/* Questao.3 
Calcule a imagem do vértice P3bar sobre um espelho que contém a face P1barP2barP4bar. */

// translacao do ponto  para origem
Tp2_o = T(-coordMonumento(1, 3), -coordMonumento(2, 3), -coordMonumento(3, 3));
p2to0xyz = Tp2_o * coordMonumento;

p1 = p2to0xyz(1:3, 4); 
p2 = p2to0xyz(1:3, 3); 
p3 = p2to0xyz(1:3, 1); 
p4 = p2to0xyz(1:3, 2);

p1p2 = p2 - p1;
p1p4 = p4 - p1;

A = p1p2;
B = p1p4;

ax = A(1); ay = A(2); az = A(3);
bx = B(1); by = B(2); bz = B(3);

Nx = (ay * bz) - (az * by);
Ny = (az * bx) - (ax * bz);
Nz = (ax * by) - (ay * bx);

Novo = [Nx; Ny; Nz];

N = cross(p1p2, p1p4); 
n = [N / norm(N); 0];
E = eye(4, 4) - 2 * (n * n');

// translacao da origem para o ponto p2
To_p2 = T(coordMonumento(1,3), coordMonumento(2,3), coordMonumento(3,3));

// resultado
p_ = (To_p2 * (E * (Tp2_o * coordMonumento)));
