function output_signal = remove_artefacts_ica(input_signal, sigs_to_remove)

    [icasig, W, W1] = fastica(input_signal');


  
    output_signal = Xap';
    
end