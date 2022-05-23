

meas_list = 3;
data = WTApril2022(meas_list);

%%
figure; hold on; grid on;

Xname = 't';

% Yname = 'V';
Yname = 'Fx';


% data.plt(Xname, Yname)

plot(data.steady{1}.t, data.steady{1}.V)