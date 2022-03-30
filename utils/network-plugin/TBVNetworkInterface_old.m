% tbvNetworkInterface - Interface class between client and TBV server
%
% Usage:
%   >> obj = tbvNetworkInterface (OutputStream, InputStream)
%
% properties:
%
%
% Author(s): Bruno Direito, Jo?o Lima, Marco Sim?es, IBILI, 12 May 2014

classdef TBVNetworkInterface < handle
    
    %% Properties
    properties (SetAccess = private)
        tbvClient
        
    end
    
    
    %% Methods
    methods
        
        % constructor
        function obj = TBVNetworkInterface (tbvClient)
            obj.tbvClient = tbvClient;
        end
        
        
        function createConnection(obj)
            obj.tbvClient.createConnection();
        end
        
        function closeConnection(obj)
            obj.tbvClient.closeConnection();
        end
        
        
        % =====================================
        %% TBV server QUERIES
        % =====================================
        
        
        % --------------------
        %% Basic project queries
        % --------------------
        
        function CurrentTimePoint = tGetCurrentTimePoint(obj)
            %   Send: tGetCurrentTimePoint
            %   Receive: int CurrentTimePoint
            %   Provides the number of the currently processed step during real-time processing as an
            %       integer. Note that this function is 1-based, i.e. when the first step is processed the function
            %       returns "1" not "0"; this is important when the return value is used to access time-related
            %       information; in this case subtract "1" from the returned value.
            
            % send request and read message/response
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetCurrentTimePoint');
            
            %  int CurrentTimePoint
            CurrentTimePoint = byteToNum(tResponse);
            
            %             fprintf(1, '\n - answer received - message: %i \n\n',time_temp);
            
        end
        
        function NrOfTimePoints = tGetExpectedNrOfTimePoints(obj)
            %   Send: tGetExpectedNrOfTimePoints
            %   Receive: int NrOfTimePoints
            %   Provides the number of time points as an integer. The name contains the term "expected"
            %       since a real-time run might be interrupted by the user, i.e. this is the intended number of
            %       volumes as specified in the TBV settings file.
            
            % send request and read message/response
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetExpectedNrOfTimePoints' );
            
            % NrOfTimePoints
            NrOfTimePoints = byteToNum(tResponse);
            
            %             fprintf(1, '\n - answer received - message: %i \n\n', expTimePnts);
            
        end
        
        function [dim_x, dim_y, dim_z] = tGetDimsOfFunctionalData(obj)
            %   Send: tGetDimsOfFunctionalData
            %   Receive: int dim_x, int dim_y, int dim_z
            %   Provides the dimensions of the functional volumes; "dim_x" ...
            %       and "dim_y" are the dimensions of the slices constituting the...
            %       volume and "dim_z" corresponds to the number of slices.
            
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetDimsOfFunctionalData' );
            
            % dim_x
            dim_x = byteToNum(tResponse(1:4));
            tResponse(1:4) = [];
            
            % dim_y
            dim_y = byteToNum(tResponse(1:4));
            tResponse(1:4) = [];
            
            % dim_z
            dim_z = byteToNum(tResponse(1:4));
            tResponse(1:4) = [];
            
        end
        
        
        
        function projectName = tGetProjectName(obj)
            %   Send: tGetProjectName
            %   Receive: char[100] cProjectName
            %   Provides the name of the project as specified in the TBV file...
            %       as a C string; note that the received data must point to a pre-allocated...
            %       array that is large enough (a buffer of 100 bytes should be sufficient)....
            %       The returned name can, for example, be used as part of names identifying...
            %       exported data.
            
            % send request and read message/response
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetProjectName');
            
            
            % message size
            messageSize = byteToNum(tResponse(1:4));
            tResponse(1:4) = [];
            
            % char[100] cProjectName
            projectName = char(tResponse);
            
            %             fprintf(1, '\n - answer received - message: %s \n\n', projectName);
            
        end
        
        
        function cWatchFolder = tGetWatchFolder(obj)
            %   Send: tGetWatchFolder
            %   Receive: char[513] cWatchFolder
            %   Provides the path of the "watch folder" as specified in the TBV file...
            %       as a C string; Note that the received data must point to a...
            %       pre-allocated array that is large enough for the returned path...
            %       (a buffer of 513 bytes is recommended).
            
            % send request and read message/response
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetWatchFolder' );
            
            % message size
            messageSize = byteToNum(tResponse(1:4));
            tResponse(1:4) = [];
            
            cWatchFolder = char(tResponse);
            
            %             fprintf(1, '\n - answer received - message: %s \n\n', watchFolder);
            
            
        end
        
        function cTargetFolder = tGetTargetFolder(obj)
            %   Send: tGetTargetFolder
            %   Receive: char[513] cTargetFolder
            %   Provides the path of the "target folder" as specified in the TBV...
            %       file as a C string; note that the received data must point to a pre-allocated...
            %       array that is large enough for the returned path (a buffer of 513 bytes is...
            %       recommended). The target folder can be used to export data for custom processing.
            
            
            % send request and read message/response
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetTargetFolder' );
            
            
            % message size
            messageSize = byteToNum(tResponse(1:4));
            tResponse(1:4) = [];
            
            cTargetFolder = char(tResponse);
            
            %             fprintf(1, '\n - answer received - message: %s \n\n', cTargetFolder);
            
        end
        
        
        
        function feedbackFolder = tGetFeedbackFolder(obj)
            %   Send: tGetFeedbackFolder
            %   Receive: char[513] cFeedbackFolder
            %   Provides the path of the "feedback folder" as specified in the...
            %       TBV file as a C string; note that the provided data must point to a...
            %       pre-allocated array that is large enough for the received path...
            %       (a buffer of 513 bytes is recommended). The feedback folder can be...
            %       used to store the result of custom calculations, e.g. providing...
            %       custom input for the "Presenter" software tool.
            
            % send request and read message/response
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetFeedbackFolder' );
            
            % message size
            messageSize = byteToNum(tResponse(1:4));
            tResponse(1:4) = [];
            
            feedbackFolder = char(tResponse);
            
            % fprintf(1, '\n - answer received - message: %s \n\n', feedbackFolder);
            
        end
        
        % --------------------
        %% Protocol, DM, GLM Queries
        % --------------------
        
        function CurrentProtocolCondition = tGetCurrentProtocolCondition(obj)
            %   Send: tGetCurrentProtocolCondition
            %   Receive: int CurremtProtocolCondition
            %   TODO detailed description
            
            % send request and read message/response
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetCurrentProtocolCondition');
            
            %  int NrOfROIs
            CurrentProtocolCondition = byteToNum(tResponse) + 1;
            
            
            %             fprintf(1, '\n - answer received - message: %i \n\n', CurrentProtocolCondition);
            
        end
        
        function fullNrOfPredictors = tGetFullNrOfPredictors(obj)
            %   Receive: int tGetFullNrOfPredictors
            %   Provides the number of predictors of the design matrix.
            %       Note that this query returns the "full" number of intended
            %       predictors while the "tGetCurrentNrOfPredictors" returns
            %       the number of predictors currently in use.
            
            % send request and read message/response
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetFullNrOfPredictors');
            
            %  int NrOfROIs
            fullNrOfPredictors = byteToNum(tResponse);
            
            
            %             fprintf(1, '\n - answer received - message: %i \n\n', CurrentProtocolCondition);
            
        end
        
        function currentNrOfPredictors = tGetCurrentNrOfPredictors(obj)
            %   Receive: int currentNrOfPredictors
            %   Provides the currently effective number of predictors. Note
            %       that this query may return a smaller number than the
            %       "tGetFullNrOfPredictors" query since the internal GLM calculations
            %       use a restricted set of predictors in case that for one or more
            %       predictors not enough non-zero data points are available.
            %       Roughly speaking, the number of current predictors increases each time
            %       when a new condition is encountered during real-time processing.
            
            % send request and read message/response
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetCurrentNrOfPredictors');
            
            %  int NrOfROIs
            currentNrOfPredictors = byteToNum(tResponse);
            
        end
        
        
        function nrOfConfoundPredictors = tGetNrOfConfoundPredictors(obj)
            %   Receive: int nrOfConfoundPredictors
            %   Provides the full number of confound predictors. To get the full/effective
            %       number of predictors-of-interest, subtract the returned value from the
            %       "tGetFullNrOfPredictors" or "tGetCurrentNrOfPredictors" function, respectively.
            
            % send request and read message/response
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetNrOfConfoundPredictors');
            
            %  int NrOfROIs
            nrOfConfoundPredictors = byteToNum(tResponse);
            
        end
        
        
        function [pred, timepoint, valueOfDesignMatrix] = tGetValueOfDesignMatrix(obj, pred, timepoint)
            %   Send: tGetValueOfDesignMatrix, int pred, int timepoint
            %   Receive: int pred, int timepoint, float ValueOfDesignMatrix
            %   Provides the value of a predictor at a given time point of the
            %       current design matrix. Note that the design matrix always contains
            %       the "full" set of predictors, a reduced set of predictors is only
            %       used internally (predictors that are not used internally are those
            %       containing only "0.0" entries up to the current time point).
            %       Note that the "timepoint" parameter must be smaller than the value
            %       returned by the "tGetCurrentTimePoint" query
            
            % send int roi
            output(1) = {pred};
            output(2) = {timepoint};
            
            % send request and read message/response
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetValueOfDesignMatrix' , output);
            
            % int ROI
            pred = byteToNum(tResponse(1:4)) + 1; % zero index-based
            tResponse(1:4) = [];
            
            % int beta
            timepoint = byteToNum(tResponse(1:4)) + 1; % zero index-based
            tResponse(1:4) = [];
            
            % float betaOfROI
            valueOfDesignMatrix = typecast(uint8(tResponse(4:-1:1)), 'single');
            
        end
        
        function nrOfContrasts = tGetNrOfContrasts(obj)
            %   Receive: int nrOfContrasts
            %   Provides the number of (automatically or manually) specified contrasts
            %       in the TBV settings file. This value is important for accessing t maps,
            %       see the "tGetMapValueOfVoxel" and "tGetContrastMaps" queries.
            
            % send request and read message/response
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetNrOfContrasts');
            
            %  int NrOfROIs
            nrOfContrasts = byteToNum(tResponse);
            
        end
        
        % --------------------
        %% ROI queries
        % --------------------
        
        
        function NrOfROIs = tGetNrOfROIs(obj)
            %   Send: tGetNrOfROIs
            %   Receive: int NrOfROIs
            %   Provides the number of currently available ROIs. Note that the...
            %       number of ROIs may change during real-time processing since the user...
            %       may open additional ROI windows or close ROI windows at any time....
            %       It is thus important to use this function prior to other functions...
            %       accessing ROI information.
            
            % send request and read message/response
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetNrOfROIs');
            
            %  int NrOfROIs
            NrOfROIs = byteToNum(tResponse);
            
            
            %             fprintf(1, '\n - answer received - message: %i \n\n', NrOfROIs);
            
        end
        
        function meanOfROI = tGetMeanOfROI(obj, nrOfROI)
            %   Send: tGetMeanOfROI, int roi
            %   Receive: int roi, float MeanOfROI
            %   Returns the mean signal value of the ROI referenced with the "roi" ...
            %       parameter (0-based index). A valid number must be smaller than ...
            %       the value returned by the "tGetNrOfROIs" query. Note that the ...
            %       voxels defining a ROI might change in case that the user selects ...
            %       another region for the same ROI index (replaces the content of ...
            %       the same plot in the GUI). The query should be used in situations ...
            %       when ROIs are not changed, i.e. when a set of ROIs is pre-loaded ...
            %       for a neurofeedback study.
            
            
            % define output variable according to user guide
            output(1) = {nrOfROI-1};
            
            % send request and read message/response
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetMeanOfROI' , output);
            
            if numel(tResponse) ~=8
                % Find error
                if  ~numel(strfind (char(tResponse), 'NrOfROI out of range'))==0
                    responseString = char(tResponse(strfind (char(tResponse), 'NrOfROI out of range'):end));
                    fprintf(1, '%s. \n', responseString)
                end
            end
            
            % int ROI
            nrOfROI =byteToNum(tResponse(1:4)) + 1; % zero index-based
            tResponse(1:4) = [];
            
            % float MeanOfROI
            meanOfROI = typecast(uint8(tResponse(4:-1:1)), 'single');
            
            % fprintf(1, '\n - answer received - message: ROI # %i, meanvalue - %i \n\n',nrOfROI, meanOfROI);
            
        end
        
        function  [meanOfROI, timePnt] = tGetMeanOfROIAtTimePoint(obj, nrOfROI, timePntRequested)
            %   Send: tGetMeanOfROIAtTimePoint, int roi, int toTimePoint
            %   Receive: int roi, int toTimePoint, float MeanOfROIAtTimePoint
            %   Returns the mean signal value of the ROI referenced with the...
            %      "roi" parameter (0-based index) of a defined point in time....
            %       A valid ROI number must be smaller than the value returned by...
            %       the "tGetNrOfROIs" query, a valid toTimePoint number must be...
            %       smaller than the value returned by the "tGetCurrentTimePoint"...
            %       querry. Note that the voxels defining a ROI might change in...
            %       case that the user selects another region for the same ROI...
            %       index (replaces the content of the same plot in the GUI)...
            %       The query should be used in situations when ROIs are not changed,...
            %       i.e. when a set of ROIs is pre-loaded for a neurofeedback study.
            
            % define output variable according to user guide
            output(1) = {nrOfROI-1};
            output(2) = {timePntRequested};
            
            % send request and read message/response
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetMeanOfROIAtTimePoint' , output);
            
            if numel(tResponse)~=12
                % Find error
                if  ~numel(strfind (char(tResponse), 'NrOfROI out of range'))==0
                    responseString = char(tResponse(strfind (char(tResponse), 'NrOfROI out of range'):end));
                    fprintf(1, '%s. \n', responseString)
                end
            end
            
            
            % int ROI
            nrOfROI = byteToNum(tResponse(1:4)) + 1; % zero index-based
            tResponse(1:4) = [];
            
            % int toTimePoint
            timePnt = byteToNum(tResponse(1:4)); % zero index-based
            tResponse(1:4) = [];
            
            
            % float MeanOfROIAtTimePoint
            meanOfROI = typecast(uint8(tResponse(4:-1:1)), 'single');
            
            
            %             fprintf(1, '\n - answer received - message: ROI # %i, meanvalue - %i \n\n',nrOfROI, meanOfROI);
            
        end
        
        function NrOfVoxelsOfROI = tGetNrOfVoxelsOfROI(obj, nrOfROI)
            %   Send: tGetNrOfVoxelsOfROI, int roi
            %   Receive: int roi, int NrOfVoxelsOfROI
            %   Provides the number of voxels of the specified ROI. Note that the...
            %       returned number might change during real-time processing in case that the...
            %       user replaces a ROI with another set of voxels. The value of this query...
            %       is important for accessing information of individual ROI voxels (see below).
            
            % send int roi
            output(1) = {nrOfROI-1};
            
            % send request and read message/response
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetNrOfVoxelsOfROI' , output);
            
            
            
            nrROI = byteToNum(tResponse(1:4)) + 1;
            tResponse(1:4) = [];
            
            NrOfVoxelsOfROI = byteToNum(tResponse);
            
            
            %   fprintf(1, '\n - answer received - message: ROI # %i, value - %i \n\n',nrROI, nrVoxOfROI);
            
            
        end
        
        function betaOfROI = tGetBetaOfROI(obj, nrOfROI, beta)
            %   Send: tGetBetaOfROI, int roi, int beta
            %   Receive: int roi, int beta, float betaOfROI
            %   Retrieves the value of a specified beta (0-based index) of the specified ROI
            %       (0-based index). For each ROI a GLM is calculated incrementally using the
            %       mean signal time course; the betas of the calculated GLM are accessible
            %       with this query; note that the beta indices range from 0 to the full number
            %       of predictors; to retrieve only the betas of the predictors of interest,
            %       the beta index must be smaller than "tGetFullNrOfPredictors" minus "tGetNrOfConfoundPredictors".
            
            % send int roi
            output(1) = {nrOfROI-1};
            output(2) = {beta};
            
            % send request and read message/response
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetBetaOfROI' , output);
            
            % int ROI
            nrOfROI = byteToNum(tResponse(1:4)) + 1; % zero index-based
            tResponse(1:4) = [];
            
            % int beta
            beta = byteToNum(tResponse(1:4)) + 1; % zero index-based
            tResponse(1:4) = [];
            
            % float betaOfROI
            betaOfROI = typecast(uint8(tResponse(4:-1:1)), 'single');
            
            
        end
        
        function [x, y, z] = tGetCoordsOfVoxelOfROI(obj, nrOfROI, voxel)
            %   Send: tGetBetaOfROI, int roi, int voxel
            %   Receive: int roi, int voxel, int x, int y, int z
            %   Provides the coordinates of a voxel (0-based enumeration index)
            %       of the ROI specified with the "roi" parameter (0-based index);
            %       the value for the "voxel" index ranges from "0" to one less
            %       than the value returned by the "tGetNrOfVoxelsOfROI" query;
            %       since ROIs content may change, use the latter function for a
            %       specific ROI index always before using the current function.
            
            % send int roi
            output(1) = {nrOfROI-1};
            output(2) = {voxel};
            
            % send request and read message/response
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetCoordsOfVoxelOfROI' , output);
            
            % int ROI
            nrOfROI = byteToNum(tResponse(1:4)) + 1; % zero index-based
            tResponse(1:4) = [];
            
            % int voxel
            roi = byteToNum(tResponse(1:4)) + 1; % zero index-based
            tResponse(1:4) = [];
            
            % int x
            x = byteToNum(tResponse(1:4)) + 1; % zero index-based
            tResponse(1:4) = [];
            
            % int y
            y = byteToNum(tResponse(1:4)) + 1; % zero index-based
            tResponse(1:4) = [];
            
            % int z
            z = byteToNum(tResponse(1:4)) + 1; % zero index-based
            tResponse(1:4) = [];
            
        end
        
        
        
        function coordsOfVoxelsOfROI = tGetAllCoordsOfVoxelsOfROI(obj, nrOfROI)
            %   Send: tGetBetaOfROI, int roi
            %   Receive: int roi, coordsOfVoxelsOfROI
            %   Provides the coordinates of all voxels of the ROI specified with the
            %       "roi" parameter (0-based index); since ROIs content may change,
            %       use the latter function for a specific ROI index always before
            %       using the current function. For details, see the "ROI Processing"
            %       example plugin. If a coordinate of a specific voxel of a roi needs
            %       to be accessed, use the term
            %       "x_coord = voxel_roi+0; y_coord = voxel_roi+1; z_coord = voxel_roi+2".
            
            % send int roi
            output(1) = {nrOfROI-1};
            
            % send request and read message/response
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetAllCoordsOfVoxelsOfROI' , output);
            
            % int ROI
            nrOfROI = byteToNum(tResponse(1:4)) + 1; % zero index-based
            tResponse(1:4) = [];
            
            % number of voxels
            numOfVoxels = length(tResponse) / 4 ;
            
            % int []
            % %             for i = 1:numOfVoxels/3
            % %                 for j = 1:3 % three axes
            % %                     coordsOfVoxelsOfROI(i,j)= byteToNum(tResponse(1:4)) + 1; % zero index-based
            % %                     tResponse(1:4) = [];
            % %                 end
            % %             end
            
            for i = 1:numOfVoxels/3
                for j = 1:3 % three axes
                    coordsOfVoxelsOfROI(i,j)= typecast(uint8(tResponse(4:-1:1)), 'int32'); % zero index-based
                    tResponse(1:4) = [];
                end
            end
            
        end
        
        
        % --------------------
        %% Volume Data Access Queries
        % --------------------
        
         function [ValueOfVoxelAtTime] = tGetValueOfVoxelAtTime(obj, x, y, z, timePoint)
            %     Send: tGetValueOfVoxelAtTime, int x, int y, int z, int timepoint
            %     Receive: int x, int y, int z, int timepoint, float ValueOfVoxelAtTime
            %     Provides the signal value as a 4-byte float value of the voxel specified by the coordinate
            %         parameters "x", "y" and "z" for the given time point (0-based indices). The given "timepoint"
            %         parameter must be smaller than the value obtained by the "tGetCurrentTimePoint" query.
            
            %    send float ValueOfVoxelAtTime
            
            output(1) = {x}; %(0-based indices)
            output(2) = {y}; %(0-based indices)
            output(3) = {z}; %(0-based indices)
            output(4) = {timePoint};
            
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetValueOfVoxelAtTime', output);
            
            if numel(tResponse)~=20
                % Find error
                if  ~numel(strfind (char(tResponse), 'NrOfTimePoint out of range'))==0
                    responseString = char(tResponse(strfind (char(tResponse), 'NrOfTimePoint out of range'):end));
                    fprintf(1, '%s. \n', responseString)
                end
            end
            
            
            xCoord = byteToNum(tResponse(1:4)); % zero index-based
            tResponse(1:4) = [];
            yCoord = byteToNum(tResponse(1:4)); % zero index-based
            tResponse(1:4) = [];
            zCoord = byteToNum(tResponse(1:4)); % zero index-based
            tResponse(1:4) = [];
            timePnt = byteToNum(tResponse(1:4));
            tResponse(1:4) = [];
            
            
            %float ValueOfVoxelAtTime
            ValueOfVoxelAtTime = typecast(uint8(tResponse(4:-1:1)), 'single');
            
        end
        
        function valueOfAllVoxelsAtTime = tGetValueOfAllVoxelsAtTime(obj, timePoint)
            %             Send: tGetTimeCourseData, int x, int y, int z, int timepoint,
            %             Receive: int x, int y, int z, int timepoint, short int [dim_x*dim_y*dim_z] TimeCourseData
            %             Provides the full time course data to a given time point that is also used internally in TBV.
            %                 Individual values are 2-byte short integers. Note that the "timepoint" parameter must be
            %                 smaller than the value returned by the "tGetCurrentTimePoint()" function. If a voxel with
            %                 specific coordinates needs to be accessed, use the term "z_coord*dim_x*dim_y +
            %                 y_coord*dim_x + x_coord". For details, see the provided example clients.
            
            
            output = {timePoint};
            
            
            [rOK, aOK, tResponse]= obj.tbvClient.queryVolumeData('tGetValueOfAllVoxelsAtTime', output);
            
            TimeCourseData = [];
            tResponse (1:4) = []; 
            
            tResp_swap = zeros(size(tResponse));
            tResp_swap (2:2:end) = tResponse(1:2:end);
            tResp_swap (1:2:end) = tResponse(2:2:end);
            
            valVoxel = typecast(int8(tResp_swap), 'int16');
                
            valueOfAllVoxelsAtTime = valVoxel;
            
             
        end
        
        
        function RawValueTimeCourseData = tGetRawValueOfAllVoxelsAtTime(obj, timePoint)
            %             Send: tGetRawValueOfAllVoxelsAtTime, int timePoint
            %             Receive: short int [dim_x*dim_y*dim_z] TimeCourseData
            %             Provides raw (not pre-processed) the signal value of all voxels to a given time point that is
            %                 also used internally in TBV. Individual values are 2-byte short integers. Note that the
            %                 "timepoint" parameter must be smaller than the value returned by the
            %                 "tGetCurrentTimePoint()" function. If a voxel with specific coordinates needs to be accessed,
            %                 use the term "z_coord*dim_x*dim_y + y_coord*dim_x + x_coord". For details, see the
            %                 provided example clients.
            
            
            output = {timePoint};
            
            [rOK, aOK, tResponse]= obj.tbvClient.queryVolumeData('tGetRawValueOfAllVoxelsAtTime', output);
            
            RawValueTimeCourseData = [];
            
            tResp_swap = zeros(size(tResponse));
            tResp_swap (2:2:end) = tResponse(1:2:end);
            tResp_swap (1:2:end) = tResponse(2:2:end);
               
            rawValVoxel = typecast(int8(tResp_swap), 'uint16');
                
            RawValueTimeCourseData = rawValVoxel;
        end
        
        
        
        function BetaOfVoxel = tGetBetaOfVoxel(obj, beta, x, y, z)
            %             Send: tGetBetaOfVoxel, int beta, int x, int y, int z
            %             Receive: int beta, int x, int y, int z, double BetaOfVoxel
            %             Provides the value of a beta indexed by the "beta" parameter as an 8-byte double value for
            %                 the voxel specified by the coordinate parameters "x", "y" and "z" (0 -based indices). This
            %                 function allows to access estimated beta values resulting from the incremental GLM
            %                 performed by TBV. Note that the beta index ranges from 0 to the current number of predictors;
            %                 to retrieve only the betas of the predictors of interest, the beta index must be smaller than
            %                 "tGetCurrentNrOfPredictors" minus "tGetNrOfConfoundPredictors". For details, see the
            %                 "Export Volume Data" example client.
            
            output(1) = {beta-1}; %{beta-1}; %(0-based indices)
            output(2) = {x}; %(0-based indices)
            output(3) = {y}; %(0-based indices)
            output(4) = {z}; %(0-based indices)
            
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetBetaOfVoxel', output);
            
            beta = byteToNum(tResponse(1:4)); % zero index-based
            tResponse(1:4) = [];
            x = byteToNum(tResponse(1:4)); % zero index-based
            tResponse(1:4) = [];
            y = byteToNum(tResponse(1:4)); % zero index-based
            tResponse(1:4) = [];
            z = byteToNum(tResponse(1:4)); % zero index-based
            tResponse(1:4) = [];
            
            %double BetaOfVoxel
            BetaOfVoxel = typecast(uint8(tResponse(4:-1:1)), 'single');
            
        end
        
        function BetaMaps = tGetBetaMaps(obj)
            %             Send: tGetBetaMaps
            %             Receive:  float [CurrentNrOfPredictors*dim_x*dim_y*dim_z] BetaMaps
            %             Provides the full stack of beta maps that is also used internally in TBV. Individual entries are
            %                 4-byte float values. The data is organized as a flat array; in order to obtain the beta value of a
            %                 specific predictor index for a voxel with specific coordinates, use the term "beta_i*dim_xyz +
            %                 z_coord*dim_xy + y_coord*dim_x + x_coord". Note that the beta_i index must be in the
            %                 ranges from 0 to the current number of predictors; to retrieve only the betas of the predictors
            %                 of interest, the beta index must be smaller than tGetCurrentNrOfPredictors" minus
            %                 "tGetNrOfConfoundPredictors". For details, see the provided "Export Volume Data" client.
            
            
            [rOK, aOK, tResponse]= obj.tbvClient.queryVolumeData('tGetBetaMaps');
            
            BetaMaps = [];
            
        end
        
        
        function MapValueOfVoxel = tGetMapValueOfVoxel (obj, map, x, y, z)
            %             Send: tGetMapValueOfVoxel, int map, int x, int y, int z
            %             Receive: int map, int x, int y, int z, float MapValueOfVoxel
            %             Provides the value of a t map indexed by the "map" parameter as a 4-byte float value for the
            %                 voxel specified by the coordinate parameters "x", "y" and "z" (0-based indices). This function
            %                 allows to access calculated contrast values that are calculated based on the beta values from
            %                 the incremental GLM performed by TBV. The "map" index ranges from 0 to one less than the
            %                 number of contrasts specified in the TBV settings file (implicitly or via a specified contrast
            %                 ".ctr" file); the number of contrasts can be retrieved using the "tGetNrOfContrasts" query. For
            %                 details, see the "Export Volume Data" example client.
            
            output(1) = {map}; %(0-based indices)
            output(2) = {x}; %(0-based indices)
            output(3) = {y}; %(0-based indices)
            output(4) = {z}; %(0-based indices)
            
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetMapValueOfVoxel', output);
            
            map = byteToNum(tResponse(1:4)); % zero index-based
            tResponse(1:4) = [];
            x = byteToNum(tResponse(1:4)); % zero index-based
            tResponse(1:4) = [];
            y = byteToNum(tResponse(1:4)); % zero index-based
            tResponse(1:4) = [];
            z = byteToNum(tResponse(1:4)); % zero index-based
            tResponse(1:4) = [];
            
            %float BetaOfVoxel
            MapValueOfVoxel = typecast(uint8(tResponse(4:-1:1)), 'single');
            
            
        end
        
        
        function ContrastMaps = tGetContrastMaps(obj)
            %             Send: tGetContrastMaps
            %             Receive: float [tGetNrOfContrasts*dim_x*dim_y*dim_z] ContrastMaps
            %             Provides the full stack of contrast maps that is also used internally in TBV. Individual entries
            %                 are 4-byte float values. The data is organized as a flat array; in order to obtain the t value of a
            %                 specific contrast map index for a voxel with specific coordinates, use the term
            %                 "map_i*dim_xyz + z_coord*dim_xy + y_coord*dim_x + x_coord". The "map_i" index ranges
            %                 from 0 to one less than the number of contrasts specified in the TBV settings file (implicitly or
            %                 via a specified contrast ".ctr" file); the number of contrasts can be retrieved using the
            %                 "tGetNrOfContrasts" query. For details, see the provided "Export Volume Data" client.
            
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetContrastMaps');
            
            
            ContrastMaps = [];
            
        end
        
        
        % --------------------
        %% Volume Data Access Queries
        % --------------------
        
        function numClasses = tGetNumberOfClasses (obj)
            %       Send: tGetNumberOfClasses
            %       Receive: int n_classes
            %       Provides the number of classes for which values are provided.
            %           In case that the real-time SVM classifier is not used, this
            %           function returns -3; in case that the real-time SVM classifier
            %           dialog is open but the classifier is not producing incremental
            %           output, this function returns -2; if the classifier is
            %           working but no output has been generated yet, this function returns 0.
            %           You only should use the tGetCurrentClassifierOutput() function
            %           (see below) if this function returns a positive value. Based on the
            %           returned (positive) value (assigned to e.g. variable n_classes),
            %           the size of the array needed for the tGetCurrentClassifierOutput()
            %           function can be calculated as the number of pair comparisons n_pairs:
            %   n_pairs = n_classes * (n_classes - 1) / 2
            
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetNumberOfClasses');
            
            
            numClasses = tResponse;
            
            
        end
        
        %% Functional Connectivity Functions
        
        function [wSize,PearsonCorrelation] = tGetPearsonCorrelation(obj, windowSize)
            % Send: tGetPearsonCorrelation, int windowSize
            % Receive: float PearsonCorrelation[ncon]
            % Provides the calculated Pearson Correlation results of the current point in time
            % for all combinations of selected ROI?s. At least two ROI?s must be selected to
            % calculate a correlation.
            
            output = {windowSize};
            
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetPearsonCorrelation', output);
            
            wSize = byteToNum(tResponse(1:4));
            
            idx = 1;
            
            for i = 5:4:length(tResponse)
                PearsonCorrelation(idx) = typecast(uint8(tResponse(i+3:-1:i)), 'single');
                idx = idx + 1;
            end
            
        end
        
        function [wSize,tPoint,PearsonCorrelationAtTimePoint] = tGetPearsonCorrelationAtTimePoint(obj, windowSize, timePoint)
            % Send: tGetPearsonCorrelationAtTimePoint, int windowSize, int timePoint
            % Receive: float PearsonCorrelation[ncon]
            % Provides the calculated Pearson Correlation results of the point in time
            % defined by the timePoint parameter for all combinations of selected ROI?s.
            % At least two ROI?s must be selected to calculate a correlation.
            
            output(1) = {windowSize};
            output(2) = {timePoint};
            
            % send request and read message/response
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetPearsonCorrelationAtTimePoint' , output);
            
            wSize = byteToNum(tResponse(1:4));
            tPoint = byteToNum(tResponse(5:8));
            
            idx = 1;
            
            for i = 9:4:length(tResponse)
                PearsonCorrelationAtTimePoint(idx) = typecast(uint8(tResponse(i+3:-1:i)), 'single');
                idx = idx + 1;
            end
            
        end
        
        
        function [wSize,PartialCorrelation] = tGetPartialCorrelation(obj, windowSize)
            % Send: tGetPartialCorrelation, int windowSize
            % Receive: float PartialCorrelation[ncon]
            % Provides the calculated partial correlation results of the current point
            % in time for all combinations of selected ROI?s. At least two ROI?s must be
            % selected to calculate a correlation.
            
            output = {windowSize};
            
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetPartialCorrelation', output);
            
            wSize = byteToNum(tResponse(1:4));
            
            idx = 1;
            
            for i = 5:4:length(tResponse)
                PartialCorrelation(idx) = typecast(uint8(tResponse(i+3:-1:i)), 'single');
                idx = idx + 1;
            end
            
        end
        
        
        function [wSize,tPoint,PartialCorrelationAtTimePoint] = tGetPartialCorrelationAtTimePoint(obj, windowSize, timePoint)
            % Send: tGetPartialCorrelationAtTimePoint, int windowSize, int timePoint
            % Receive: float PartialCorrelation[ncon]
            % Provides the calculated partial correlation results of the point in time defined
            % by the timePoint parameter for all combinations of selected ROI?s. At least two
            % ROI?s must be selected to calculate a correlation.
            
            output(1) = {windowSize};
            output(2) = {timePoint};
            
            % send request and read message/response
            [rOK, aOK, tResponse]= obj.tbvClient.query('tGetPartialCorrelationAtTimePoint' , output);
            
            wSize = byteToNum(tResponse(1:4));
            tPoint = byteToNum(tResponse(5:8));
            
            idx = 1;
            
            for i = 9:4:length(tResponse)
                PartialCorrelationAtTimePoint(idx) = typecast(uint8(tResponse(i+3:-1:i)), 'single');
                idx = idx + 1;
            end
            
        end
        
        
        
    end
    
    
end