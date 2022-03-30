function sendTrigger( trigger, configs )
% SENDTRIGGER Envia trigger para porta paralela
% Envia o trigger para a porta port, espera 4ms e limpa a porta com o valor
% 0
    if configs.PC_NOVO
        io64(configs.io64, configs.EEG_PORT, trigger); % trigger de est?mulo
        WaitSecs( 0.004 );
        io64(configs.io64, configs.EEG_PORT, 0);
    else
        lptwrite(configs.EEG_PORT, trigger);
        WaitSecs( 0.004 );
        lptwrite(configs.EEG_PORT, 0);
    end
end