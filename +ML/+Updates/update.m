function update(varargin)
%ML.Updates.update Updates MLAB
%
%   ML.UPDATES.UPDATE()
%
%   Reference page in Help browser: <a href="matlab:doc ML.Updates.update">doc ML.Updates.update</a>
%   <a href="matlab:doc ML">MLab documentation</a>

% === Input variables =====================================================

in = inputParser;
in.addParamValue('action', 'display', @ischar);
in.addParamValue('force', false, @islogical);
in.addParamValue('quiet', false, @islogical);

in.parse(varargin{:});
in = in.Results;

% =========================================================================

% --- Get configutation
config = ML.config;

% --- Get file list
L = ML.Updates.get('force', in.force);

% --- Action
switch in.action
    
    case 'update'
        
        % Adding files
        if numel(L.to_add)
            h = waitbar(0,'MLab update (adding files) ...');
            for i = 1:numel(L.to_add)
                
                % Create subdirectory (if it does not exist)
                D = fileparts([config.path L.to_add{i}]);
                if ~exist(D, 'dir'), mkdir(D); end
                
                % Load file from server
                urlwrite([config.updates.mirror_url 'Code/' L.to_add{i}], ...
                    [config.path L.to_add{i}], 'Charset', 'UTF-8');
                
                % Waitbar
                waitbar(i/numel(L.to_add));
            end
            close(h);
        end
        
        % Removing files
        if numel(L.to_del)
            h = waitbar(0,'MLab update (removing files) ...');
            for i = 1:numel(L.to_del)
                
                delete([config.path L.to_del{i}]);
                
                % Waitbar
                waitbar(i/numel(L.to_del));
            end
            close(h);
        end
        
        clc
        ML.Updates.check('quiet', false);
        
    otherwise
        
        if numel(L.to_add) || numel(L.to_del)
            
            fprintf('\n<strong>MLab Update</strong>\n');
            
            if numel(L.to_add)
                fprintf('\n  <strong>Files to add:</strong>\n');
                for i = 1:numel(L.to_add)
                    fprintf('\t%s\n', L.to_add{i});
                end
            end
            
            if numel(L.to_del)
                fprintf('\n  <strong>Files to remove:</strong>\n');
                for i = 1:numel(L.to_del)
                    fprintf('\t%s\n', L.to_del{i});
                end
            end
            
            fprintf('\n<a href="matlab:ML.Updates.update(''action'', ''update'');">Click here</a> to start the update.\n\n')
            
        else
            if ~in.quiet
                disp('MLab is up to date.');
            end
        end
end