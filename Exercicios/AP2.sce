clc(); clear; //resethistory();
getd('/Users/helio/Documents/GitHub/CK0245/AP1');

//format("e",8);
deff('y0=at(vecI, vecK)','y0=[vecI(1)*vecK(1) vecI(2)*vecK(2) vecI(3)*vecK(3)]');

/** AP1 20161 **/

A=6.;B=4.;C=4.;D=6.;E=9.;F=3.;
L=A+B+C+D+E+F;
P1=[A+10, B+5, 0];
P2=P1+[L,0,0];
P3=P1+[L/2.,L*sqrt(3)/2.,0];
P4=P1+[L/2.,L*sqrt(3)/6.,L*sqrt(6)/6.];
Po=[A-5,B+L,L*sqrt(6)/6.];


// Q1 ..........................................................................
// Dados

ViewUpPnt = [0, 0, 1]; Vup = ViewUpPnt; AVUp = Vup;

LookAt = P4-[0,0,L*sqrt(6)/6.];//[D, E, F, 1.]; 
LookAt = [LookAt(1), LookAt(2), LookAt(3), 1];

LAt = LookAt;

// O ponto Eye tem coordenadas (Eyex, Eyey, Eyez) = 
Eye = [Po(1),Po(2),Po(3),1];//[4 * (A + D + 2), 4 * (B + E + 3), 4 * (C + F + 5), 1];

// Monte o frame da camera e as matrizes de transformacao da camera seguindo a 
// seguinte sequencia

// 1) Calcule o vetor unitario k' (k_cam)

K = Eye - LookAt;
k = K / norm(K);

// 2) Calcule o vetor unitario i' (i_cam)

// ViewUpVector = ViewUpPnt - Eye

Vuv = AVUp - Eye(1:3);

I = cross(Vuv, k(1:3));
i = I / norm(I);

// 3) Calcule o vetor unitario j' (j_cam)
j = cross(k(1:3), i);

// 4) Determine a matriz que transforma um ponto do frame do mundo para o frame
// da camera: Tw->c
Twc = [i           -Eye(1:3)*i'; 
       j           -Eye(1:3)*j'; 
       k(1:3)      -Eye(1:3)*k(1:3)'; 
       0 0 0                       1];


P1cam = Twc * [P1(1),P1(2),P1(3),1]';
P2cam = Twc * [P2(1),P2(2),P2(3),1]';
P3cam = Twc * [P3(1),P3(2),P3(3),1]';
P4cam = Twc * [P4(1),P4(2),P4(3),1]';
// 5) Determine a matriz que transforma um ponto do frame da camera para o frame
// do mundo: Tc->w
Tcw = [ i(1) j(1) k(1) Eye(1);
        i(2) j(2) k(2) Eye(2);
        i(3) j(3) k(3) Eye(3);
          0.   0.   0.     1.];

// Q2 ..........................................................................
// 1
KAr = A/50.;
KAg = B/50.;
KAb = C/50.;
KA = [KAr, KAg, KAb];
// 2
KDr = 3.*KAr;
KDg = 3.*KAg;
KDb = 3.*KAb;
KD = [KDr, KDg, KDb];

KS = KD;
// 3
m = 1.;

IAr = .4;
IAg = .4;
IAb = .4;
IA = [IAr,IAg,IAb];

IFr = .7;
IFg = .7;
IFb = .7;
IF = [IFr,IFg,IFb];

PF = [A+10,B+L,2.*L]; 
PFcam = Twc*[PF(1),PF(2),PF(3),1]';

Pq2 = P4-[.0,.0,L*sqrt(6)/12.];
Pq2cam = Twc*[Pq2(1),Pq2(2),Pq2(3),1]';


Nz = cross((P2cam-P4cam)(1:3),(P3cam-P4cam)(1:3)); nz = Nz/norm(Nz);
//Tz = cross((P2cam-P1cam)(1:3),(Pq2cam-P1cam)(1:3)); tz= Tz/norm(Tz);
Tz = cross((P4cam-P2cam)(1:3),(Pq2cam-P2cam)(1:3)); tz= Tz/norm(Tz);

ok=sum(tz.*nz); //nz'*tz
disp(ok)

L2=PFcam-Pq2cam;
l2=L2/norm(L2);
V2=-Pq2cam;
v2=V2/norm(V2);
// Dados
// ..., o plano de projecao seja perpendicular ao eixo z' da camera (z_cam) e
// esteja situado em z' = -4m
d = 4;

// ... janela com dimensao 10m x 10m delimita o campo de visao do observador 
// (Frustum)
w = 10; h = w;

i_ = A + B + C; // de cima para baixo
j_ = D + E + F; // da esquerda para direita

// ... , e a imagem projetada na janela sera exposta numa regiao de 1000 x 1000
// pixels (viewport)
nx = 1000; ny = nx; 

// Encontrar as coordenadas do pixel da linha i_ e coluna j_
x_pix = (-w / 2.) + (w / (2*nx)) + j_*(w / (nx));
y_pix = (h / 2.) - (h / (2*ny)) - i_*(h / (ny));
z_pix = -d;

// pixel em questao
Pix = [x_pix y_pix z_pix];

// a //
// Encontrar o ponto de intersecao (PI). Primeiro: encontrar o vetor Pix, dado por
Pix = Pix - [0. 0. 0.];
// Normalizar Pix:
pix = Pix / norm(Pix);

// O ponto de intersecao dista 20 m da origem ao longo de Pix (pix?). Temos
// que PI = 20 * pix. Logo, o ponto de intersecao ee
PI = 20 * pix;

// b //
// O vetor unitario, vec_n, normal a superficie no ponto de intersecao, PI, 
// aponta na direcao do canto superior direito da janela, 
SD = [5 5 -4]

// Encontrar o vetor normal ao PI. vecN aponta na direcao de SD = [5 5 -4]. Assim, 
// vecN = SD - PI
vecN = SD - PI;

// Normalizando vecN, temos
vec_n = vecN / norm(vecN);

// c //
// Ha uma fonte luminosa pontual de intensidade I = (.8, .6, .4) situada no 
// ponto PF = (10, 10, -20)
I = [.8 .6 .4];
PF = [10 10 -20];

// Encontrando vec_l
vecL = PF - PI;
vec_l = vecL / norm(vecL);

// Encontrando vec_v
vecV = [0 0 0] - PI;
vec_v = vecV / norm(vecV);

// Encontrando vec_r
vec_r = 2 * (vec_n * vec_l') * vec_n - vec_l;

// d //
// O material do objeto tem k_s = k_d = k_a = (D/10, E/10, F/10) e coeficiente 
// de polimento m = F
k_a = [D/10. E/10. F/10.];
k_d = k_a; k_s = k_a;
m = F;

// e //
// Ha uma iluminacao ambiente de intensidade I_a = (A/10, B/10, C/10).
I_a = [A/10. B/10. C/10.];

// Calculando a intensidade de cor no pixel
I_d = I; I_s = I;

I_pix = at(I_a,k_a) + at(I_d,k_d)*(vec_n*vec_l') + at(I_s,k_s)*((vec_r*vec_v')^m);

// Componentes (R, G, B) do pixel situado na linha de indice (A+B+C) e na coluna
// de indice (D+E+F):
i_pix = I_pix / max(I_pix);

// Q3 ..........................................................................
// Calcule a imagem do ponto de intersecao da questao anterior em um espelho que
// passa pelos seguintes tres pontos em coordenadas de camera
P1 = [-5 -5 -4];
P2 = [5 5 -4];
P3 = [0 5 -20];

// P1, P2 e P3 definem um plano. Vamos encontrar o vetor n normal a esse plano.
W1 = P2 - P1;
W2 = P3 - P1;
N = cross(W1, W2);
n = N / norm(N);
n = [n 0];
// ok ate aqui..................................................................

// ... Como esse plano nao passa pela origem, vamos desloca-lo para a origem.
// Escolhemos o ponto P1 como referencia. Logo, o vetor t de translacao ee dado
// por
vec_t_p1_0 = [0 0 0] - P1;

// Logo a matriz de translacao ee
T1 = T(vec_t_p1_0(1), vec_t_p1_0(2), vec_t_p1_0(3))

// Agora, nesse novo sistema, obtemos n_s = T1 x n e PI_s = T1 x n
