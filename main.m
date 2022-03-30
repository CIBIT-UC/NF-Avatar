% defaults
subjectName = 'teste';
configs = init();


%% -------------- to run dynamic localizer ----------------
% % % % % localizerDynamicExpressions();
localizerDynamicExpressions('../data/dynamic-images/', 1, 'C:\neurofeedback_protocols', 'Dynamic_expressions_protocol',0); 
logger = NFLogger.getLogger();
logger.saveToFile( sprintf('%sDynamicLocalizer%s.log', configs.LOGS_PATH, subjectName) )


%% ---------------- to run train run -----------------
outputs = neurofeedbackTransfer('../data/dynamic-images/', 1, 'C:\neurofeedback_protocols', 'TrainFeedbackPrt', 0);
save(sprintf('../outputs/results/TrainRun%s.mat', subjectName), 'outputs');
logger = NFLogger.getLogger();
logger.saveToFile( sprintf('%sTrainRun%s.log', configs.LOGS_PATH, subjectName) );


%% --------------- to run visual #1 feedback ----------------
outputs = neurofeedbackVisual('../data/dynamic-images/', 1, 'C:\neurofeedback_protocols', 'Visual1FeedbackPrt', 0);
save(sprintf('../outputs/results/VisualRun1%s.mat', subjectName), 'outputs');
logger = NFLogger.getLogger();
logger.saveToFile( sprintf('%sVisualRun1%s.log', configs.LOGS_PATH, subjectName) );


%% --------------- to run visual #2 feedback ----------------
outputs = neurofeedbackVisual('../data/dynamic-images/', 1, 'C:\neurofeedback_protocols', 'Visual2FeedbackPrt', 0);
save(sprintf('../outputs/results/VisualRun2%s.mat', subjectName), 'outputs');
logger = NFLogger.getLogger();
logger.saveToFile( sprintf('%sVisualRun2%s.log', configs.LOGS_PATH, subjectName) );


%% ---------------- to run transfer run -----------------
outputs = neurofeedbackTransfer('../data/dynamic-images/', 1, 'C:\neurofeedback_protocols', 'TransferFeedbackPrt', 0);
save(sprintf('../outputs/results/TransferRun%s.mat', subjectName), 'outputs');
logger = NFLogger.getLogger();
logger.saveToFile( sprintf('%sTransferRun%s.log', configs.LOGS_PATH, subjectName) );