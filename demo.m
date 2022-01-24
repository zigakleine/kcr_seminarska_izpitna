[sig, mix] = demosig();

[icasig, W1, W] = fastica(mix);

% izlocimo stolpce
Wap = W1(:, 1:2);

% izlocimo vrstice
sigs = icasig(1:2, :);

Xap = Wap*sigs;

figure;
for i=1:size(icasig, 1)
   
    subplot(4, 1, i);
    plot(icasig(i, :));
end


figure;
for i=1:size(Xap, 1)
   
    subplot(4, 1, i);
    plot(Xap(i, :));
end


