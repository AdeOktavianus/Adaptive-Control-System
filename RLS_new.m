%% Persiapan Data
clear all
load('Data_Motor.mat'); % Data
%% Memisahkan data
time=table2array(TS);
u=table2array(Input);
y=table2array(Output);
%% Inisiasi
x = [y(1),0.0,0.0,0.0,0.0,0.0]; % [yk yk2 yk1 uk1 uk2 t]
ypredict = [];
na = 2;
nb = 2;
%% RLS Algorithm
for k=1:(length(u)-na)
yk = x(1);
yk1 = x(2);
yk2 = x(3);
uk1 = x(4);
uk2 = x(5);
t = x(6);
lambda = 0.98; % Forgetting Factor
if t==0
phi = zeros(na+nb,1);
theta = zeros(na+nb,1);
P = 500*eye(na+nb,na+nb); %Inisiasi matriks P
K = eye(na+nb,1);
a1= 0;
a2= 0;
b1= 0;
b2= 0;
ytopi= 0;
end
phi = [-yk1 -yk2 uk1 uk2]';
K = P*phi/(1*lambda+phi'*P*phi);
P = 1/lambda*P-(K*phi'*1/lambda*P);
theta = theta + K*(yk-phi'*theta);
ytopi = phi'*theta;
a1 = theta(1);
a2 = theta(2);
b1 = theta(3);
b2 = theta(4);
x = [y(k+na),y(k+1),y(k),u(k+nb),u(k+1),time(k+na)];
ypredict = [ypredict;ytopi];
end
plot(time(na+1:end,1),y(na+1:end),time(na+1:end,1),ypredict)
xlabel('Waktu (detik)')
ylabel('Tegangan Tacho (v)')
legend y yhat
RMSE = sqrt(sum((y(na+1:end)-ypredict).^2)/length(ypredict));
parameters = [a1 a2 b1 b2]