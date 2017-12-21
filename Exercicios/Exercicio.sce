clc; clear; resethistory(); 

/** Exercicio em aula: 19/10/17 **/

// Dados
Eye = [7, 1.8, 2.5, 1];
LookAt = [5., .75, 2.5, 1.];
ViewUpPnt = [5., 1.75, 2.5]; Vup = ViewUpPnt;
d = 0.7; 
w = 0.5; h = 0.5;
i_ = 250; j_ = 250;
nx = 500; ny = 500;

// Pontos do triangulo, em coordenadas de mundo
Pw_1 = [6.79, 1.12, 3., 1.];
Pw_2 = [6.52, 1., 2., 1.];
Pw_3 = [6.27, 2.55, 2.5, 1.];

// 1) Avaliacao da matriz de transformacao Tw->c

K = Eye - LookAt;
k = K / norm(K);

// ViewUpVector = ViewUpPnt - Eye

Vuv = Vup - Eye(1:3);

I = cross(Vuv, k(1:3));
i = I / norm(I);

j = cross(k(1:3),i);

Twc = [i           -Eye(1:3)*i'; 
       j           -Eye(1:3)*j'; 
       k(1:3)      -Eye(1:3)*k(1:3)'; 
       0 0 0                       1];

// 2) Avaliar objetos em coordenadas de camera

Pc_1 = Twc * Pw_1';
Pc_2 = Twc * Pw_2';
Pc_3 = Twc * Pw_3';

// 3) Eq. Raio

Pij_x = (-w / 2.) + (w / nx)*(i_ + 0.5);
Pij_y = (h / 2.) + (-h / nx)*(j_ + 0.5);
Pij_z = -d;

Pij = [Pij_x Pij_y Pij_z];

// 4) Teste de intersecao

// Estrategia 1
N = cross((Pc_2 - Pc_1)(1:3), (Pc_3 - Pc_1)(1:3));
n = N / norm(N);

// ponto de intersecao
t_num = n'*Pc_1(1:3); t_den = n'*Pij';

t_i = t_num / t_den; //0.7621;
P_i = (t_i * Pij)';

// Teste P1P2Pi
N1 = cross((Pc_2 - Pc_1)(1:3), P_i - Pc_1(1:3));
n1 = N1 / norm(N1);
//disp(n'*n1) //ok

// Teste P2P3Pi
N2 = cross((Pc_3 - Pc_2)(1:3), P_i - Pc_2(1:3));
n2 = N2 / norm(N2);
//disp(n'*n2) //ok

// Teste P3P1Pi
N3 = cross((Pc_1 - Pc_3)(1:3), P_i - Pc_3(1:3));
n3 = N3 / norm(N3);
//disp(n'*n3) //ok

// Estrategia 2
A = [(Pc_3 - Pc_1)(1:3) (Pc_3 - Pc_2)(1:3) Pij'];
invA = inv(A);

lambda1 = (invA * Pc_3(1:3))(1)
lambda2 = (invA * Pc_3(1:3))(2)
t       = (invA * Pc_3(1:3))(3)
