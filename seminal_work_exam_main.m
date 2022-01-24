
% in the first run we run ica on signal, plot W^-1 topography and save
% curent workspace to a file
first_run = false;

if first_run
    [insig, icasig, tm , W, W1] = read_and_decompose_signal('database/eegmmidb/S001R03.edf');
    display_component_topography(W1);
    filename = 'workspace.mat';
    save(filename);
else
    load('workspace.mat');
    artifact_removal_ica(insig, icasig, tm, W, W1, 22, true, [2, 3, 17, 19, 24, 28, 34, 46]);
end

function artifact_removal_ica(insig, icasig, tm, W, W1, electrode_num, display_all, sigs_to_remove)

    
    if display_all
        figure;
        for i=1:(size(insig, 2))
            subplot(16, 4, i);
            plot(tm, insig(:, i)); 
        end 
        saveas(gcf,'insig_all.png');
    end
    
    to_display_icasig = icasig';
    if display_all
        figure;
        for i=1:(size(to_display_icasig, 2))
            subplot(16, 4, i);
            plot(tm, to_display_icasig(:, i)); 
        end     
        saveas(gcf,'icasig_all.png');
    end
    
    W1(:, sigs_to_remove) = [];
    icasig(sigs_to_remove, :) = [];
    
    Wap = W1;
    Yap = icasig;
    Xap = Wap*Yap;
    
    processed_sig = Xap';
    
    if display_all
        figure;
        for i=1:(size(processed_sig, 2))
            subplot(16, 4, i);
            plot(tm, processed_sig(:, i)); 
        end     
        saveas(gcf,'outsig_all.png');
    end
    
    figure;    
    tiledlayout(2,1);
    
    nexttile;
    plot(tm, insig(:, electrode_num)); 
    title('Vhodni signal ' + string(electrode_num));
    
    nexttile;
    plot(tm, processed_sig(:, electrode_num)); 
    title('Signal z odstranjenimi artefakti ' + string(electrode_num));
    
    saveas(gcf, string(electrode_num) + '_insig_outsig.png');
    
end


function display_component_topography(W1)

    ch_list = {
        'Fc5', 'Fc3', 'Fc1', 'Fcz', 'Fc2', 'Fc4', 'Fc6', ...
        'C5',  'C3',  'C1',  'Cz',  'C2',  'C4',  'C6', ...
        'Cp5', 'Cp3', 'Cp1', 'Cpz', 'Cp2', 'Cp4', 'Cp6', ...
        'Fp1', 'Fpz', 'Fp2', ...
        'Af7', 'Af3', 'Afz', 'Af4', 'Af8', ...
        'F7',  'F5',  'F3',  'F1',  'Fz',  'F2',  'F4',  'F6',  'F8', ...
        'Ft7', 'Ft8', ...
        'T9',  'T7',  'T8',  'T10', ...
        'Tp7', 'Tp8', ...
        'P7',  'P5',  'P3',  'P1',  'Pz',  'P2',  'P4',  'P6',  'P8', ...
        'Po7', 'Po3', 'Poz', 'Po4', 'Po8', ...
        'O1',  'Oz',  'O2', ...
        'Iz'
        };

    
    for i = 1:64
        figure;
        plot_topography(ch_list, W1(:, i));
        title(string(i));
        saveas(gcf,'topografical_distributions/' + string(i) + '_com' + '.png');
        close;
    end

end

function [insig, icasig, tm , W, W1] = read_and_decompose_signal(filedir)

    [insig, freq, tm] = rdsamp(filedir, 1:64);
    [icasig, W1, W] = fastica(insig');
    
end
