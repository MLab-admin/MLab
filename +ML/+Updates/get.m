function out = get(varargin)
%ML.Updates.get Get MLAB updates (file list)
%
%   ML.UPDATES.GET 
%  
%   Reference page in Help browser: <a href="matlab:doc ML.Updates.get">doc ML.Updates.get</a>
%   <a href="matlab:doc ML">MLab documentation</a>

% === Input variables =====================================================

in = inputParser;
in.addParameter('force', false, @islogical);
in.parse(varargin{:});
in = in.Results;

% === Persistent variables ================================================

mlock
persistent flist

% =========================================================================

% --- Get file list
if isempty(flist) || in.force
    
    % --- Definitions
    
    config = ML.Config.get;
    server = config.updates.mirror_url;
    
    % --- Remote files
    
    % Get URL
    url = [server 'MLab.php?list=MLab'];
    P = ML.Plugins.list('local');
    for i = 1:numel(P)
        url = [url ',' P{i}];
    end
    
    % Get URL content
    try
        tmp = ML.Internal.fetch(url, 'delimiter', {'\n','\r','\t'});
    catch
        fprintf('No internet connection found, MLab starts in offline mode\n.');
        out = NaN;
        return
    end
    
    % Remote file names
    rf = tmp(2:2:end);
    
    % Remote dates
   rd = cellfun(@(x) datenum(x, 'yyyy:mm:dd:HH:MM:SS'), tmp(1:2:end));
        
    % --- Local files
    
    [lf, ld] = rdir(config.path(1:end-1));
    
    % Local file names
    lf = cellfun(@(x) x(numel(config.path)+1:end), lf, ...
        'UniformOutput', false);
       
    % --- File list
    flist = struct();
    
    % Files to add / update
    [tf, I] = ismember(rf, lf);
    tmp = rf(tf);
    flist.to_add = [rf(~tf) ; tmp(rd(tf) > ld(I(tf)))];
    
    % Files to delete
    if config.updates.check_delete
        flist.to_del = lf(~ismember(lf, rf));
    else
        flist.to_del = {};
    end
    
end

out = flist;

% -------------------------------------------------------------------------
function [F, D] = rdir(in)

F = {};
D = [];
d = dir(in);
for i = 1:numel(d)
    if d(i).isdir
        switch d(i).name
            case {'.', '..', 'private'}, continue;
            otherwise
                [tf, tD] = rdir([in filesep d(i).name]);
                F = [F ; tf];
                D = [D ; tD];
        end
    else
        F{end+1,1} = [in filesep d(i).name];
        
        % --- Fix locale date bug
        tmp = d(i).date;
        if ismember(computer, {'GLNX86', 'GLNXA64'})
            tmp = strrep(tmp, 'fev', 'feb');
            tmp = strrep(tmp, 'avr', 'apr');
            tmp = strrep(tmp, 'mai', 'may');
            tmp = strrep(tmp, 'juin', 'june');
            tmp = strrep(tmp, 'juillet', 'july');
            tmp = strrep(tmp, 'août', 'aug');
            tmp = strrep(tmp, 'déc', 'dec');
        end
        
        D(end+1,1) = datenum(tmp);
    end
end